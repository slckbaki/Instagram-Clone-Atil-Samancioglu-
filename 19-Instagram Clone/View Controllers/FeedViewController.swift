//
//  FeedViewController.swift
//  19-Instagram Clone
//
//  Created by Selcuk Baki on 24/8/21.
//

import UIKit
import Firebase
import SDWebImage
import OneSignal




class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    


    @IBOutlet weak var tableView: UITableView!
    
    var userEmailArray = [String]()
    var commentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var postedDateArray = [Date]()
    var documentIdArray = [String]()
    
    let firestoreDatabase = Firestore.firestore()

    
    override func viewDidLoad() {
        super.viewDidLoad()


        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromFirestore()
        
        // PUSH NOTIFICATION
       // OneSignal.postNotification(["contents": ["en": "Test Message"], "include_player_ids": ["3b79117d-e15e-4e05-9cf4-38bb4bd441ef"]])
        
        // PLAYER ID
        
        let status = OneSignal.getDeviceState()
        let playerId = status?.userId
        print("PLAYER ID : \(playerId!)")
        
        if let playerNewId = playerId {

            firestoreDatabase.collection("PlayerId").whereField("email", isEqualTo: Auth.auth().currentUser!.email).getDocuments { snapshot, error in
                if error == nil {
                    if snapshot?.isEmpty == false && snapshot != nil {
                        for document in snapshot!.documents {
                            if let playerIDFromFireBase = document.get("player_id"){
                                print("playerIdFromFirebase : \(playerIDFromFireBase)")
                                let documentId = document.documentID
                                if playerNewId != playerIDFromFireBase as! String {
                                    let playerIdDictionary = ["email" : Auth.auth().currentUser?.email!, "player_id" : playerNewId] as! [String : Any]
                                    self.firestoreDatabase.collection("PlayerId").addDocument(data: playerIdDictionary) { error in
                                        if error != nil{
                                            print(error?.localizedDescription)
                                        }
                                        
                                    }
                                }

                            }
                        }
                    }else{
                        let playerIdDictionary = ["email" : Auth.auth().currentUser?.email!, "player_id" : playerNewId] as! [String : Any]
                        self.firestoreDatabase.collection("PlayerId").addDocument(data: playerIdDictionary) { error in
                            if error != nil{
                                print(error?.localizedDescription)
                            }
                            
                        }
                        
                    }
                }
            }
            

            
        }
        
        

    }
    
    func getDataFromFirestore(){
        firestoreDatabase.collection("Posts").order(by: "date", descending: true)
            
            .addSnapshotListener { snapshot, error in
            if error != nil {
                print(error?.localizedDescription)
            }else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.commentArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.postedDateArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents{
                        let documentID = document.documentID
                        self.documentIdArray.append(documentID)
                        
                        
                        if let postedBy = document.get("postedBy") as? String{
                            self.userEmailArray.append(postedBy)
                        }
                        if let postComment = document.get("postComment") as? String {
                            self.commentArray.append(postComment)
                        }
                        if let likes = document.get("likes") as? Int{
                            self.likeArray.append(likes)
                        }
                        if let date = document.get("date") as? Timestamp {
                            self.postedDateArray.append(date.dateValue())
                        }
                        if let imageURL = document.get("imageUrl") as? String{
                            self.userImageArray.append(imageURL)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.userEmailLabel.text = userEmailArray[indexPath.row]
        cell.likeLabel.text = String(likeArray[indexPath.row])
        
        cell.postedDate.date = postedDateArray[indexPath.row]
        cell.postedDate.timeZone = TimeZone.current

        cell.commentsLabel.text = commentArray[indexPath.row]

        cell.postImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
        cell.documentIDLabel.text = documentIdArray[indexPath.row]
        return cell
    }
}
