//
//  FeedViewController.swift
//  19-Instagram Clone
//
//  Created by Selcuk Baki on 24/8/21.
//

import UIKit
import Firebase
import SDWebImage



class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    


    @IBOutlet weak var tableView: UITableView!
    
    var userEmailArray = [String]()
    var commentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var postedDateArray = [Date]()
    override func viewDidLoad() {
        super.viewDidLoad()

            //Github icin test
        //GITHUB ICIN TEST2
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromFirestore()
    }
    
    func getDataFromFirestore(){
        let firestoreDatabase = Firestore.firestore()
        firestoreDatabase.collection("Posts").addSnapshotListener { snapshot, error in
            if error != nil {
                print(error?.localizedDescription)
            }else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.commentArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.postedDateArray.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents{
                        let documentID = document.documentID
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
        
        return cell
    }
}
