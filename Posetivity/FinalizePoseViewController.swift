//
//  AvailablePosesViewController.swift
//  Posetivity
//
//  Created by Summer Hasama on 10/17/20.
//

import UIKit
import Firebase

class FinalizePoseViewController: UIViewController {
    
    var db = Firestore.firestore()
    var passposename: String = ""
    var poseimagename: String = ""
    var myStringafd: String = ""
    
    @IBOutlet weak var poseTopLabel: UILabel!
    @IBOutlet weak var poseImageView: UIImageView!
    @IBOutlet weak var poseNameLabel: UILabel!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBAction func justSave(_ sender: Any) {
        db.collection("usersposes").document(poseimagename).setData([
        "File Name": poseimagename,
            "Date": myStringafd,
            "Name": passposename
        ])
        let storageRef = Storage.storage().reference()
        if let uploadData = self.poseImageView.image!.pngData(){
            let posesRef = storageRef.child("usersposes/\(poseimagename)")
            posesRef.putData(uploadData)
        }
    }
    @IBAction func saveShare(_ sender: Any) {
        db.collection("usersposes").document(poseimagename).setData([
        "File Name": poseimagename,
            "Date": myStringafd,
            "Name": passposename,
        ])
        db.collection("feed").document(poseimagename).setData([
        "File Name": poseimagename,
            "Date": myStringafd,
            "Name": passposename,
            "Caption": captionTextView.text!,
            "Username": "Penny",
            "Likes":0 as Int
        ])
        let storageRef = Storage.storage().reference()
        if let uploadData = self.poseImageView.image!.pngData(){
            let posesRef = storageRef.child("usersposes/\(poseimagename)")
            posesRef.putData(uploadData)
            let feedposesRef = storageRef.child("feed/\(poseimagename)")
            feedposesRef.putData(uploadData)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.poseTopLabel.text = "Your body can do "+passposename+" pose!"
        self.poseNameLabel.text = passposename
        // Do any additional setup after loading the view.
        let storageRef = Storage.storage().reference()

        let imagesRef = storageRef.child("temporaryimages")
        let poseRef = imagesRef.child(poseimagename)
            
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        poseRef.getData(maxSize: 1 * 4024 * 4024) { data, error in
          if let error = error {
            print("error: \(error)")
          } else {
            let image = UIImage(data: data!)
            self.poseImageView?.image = image
          }
        }
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
        captionTextView.becomeFirstResponder()
            // Get metadata properties
            poseRef.getMetadata() {metadata,error in
                if let error = error{
                    print(error)
                }
                else{
                    if let data = metadata{
                        let timeCreated = data.timeCreated
                        let formatter = DateFormatter()
                        // initially set the format based on your datepicker date / server String
                        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let myString = formatter.string(from: timeCreated!) // string purpose I add here
                        // convert your string to date
                        let yourDate = formatter.date(from: myString)
                        //then again set the date format whhich type of output you need
                        formatter.dateFormat = "yyyy-MM-dd"
                        // again convert your date to string
                        self.myStringafd = formatter.string(from: yourDate!)
                        self.dateLabel.text = self.myStringafd
                }
              // Metadata now contains the metadata for 'images/forest.jpg'
                   
            }
        
    }
        }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

 }

