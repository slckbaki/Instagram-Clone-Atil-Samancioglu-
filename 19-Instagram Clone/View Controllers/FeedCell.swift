//
//  FeedCell.swift
//  19-Instagram Clone
//
//  Created by Selcuk Baki on 27/8/21.
//

import UIKit
import Firebase

class FeedCell: UITableViewCell {

    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var documentIDLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var postedDate: UIDatePicker!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func likeClick(_ sender: Any) {
        
        let fireStoreDatabase = Firestore.firestore()
        if let likeCount = Int(likeLabel.text!) {
            let likeStore = ["likes" : likeCount + 1] as [String : Any]
            fireStoreDatabase.collection("Posts").document(documentIDLabel.text!).setData(likeStore, merge: true)
            
            guard let userID = Auth.auth().currentUser?.uid else { return }
            print(userID)
        }
    }
}
