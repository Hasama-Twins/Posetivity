//
//  MyPosesViewController.swift
//  Posetivity
//
//  Created by Summer Hasama on 10/18/20.
//

import UIKit
import Firebase

struct MyPoses {
    var posename: String
    var imagename: String
    var date: String
}


class MyPosesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
var db = Firestore.firestore()
var myPose = MyPoses?.self
var numOfCells = 0
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: 180, height:201)
        print(layout.itemSize)
        
        loadData()
        self.collectionView.reloadData()
        print("viewdidLoad")
        }
    
        // Do any additional setup after loading the view.
    
    var myPoseArray = [MyPoses]()
    
    func loadData() {
        db.collection("usersposes").order(by: "Date", descending: true).getDocuments { (querySnapshot, error) in
               if let error = error {
                   print("\(error.localizedDescription)")
               }
               else {
                for document in (querySnapshot?.documents)! {
                    let myPose = MyPoses(posename: document.data()["Name"] as! String, imagename: document.data()["File Name"] as! String, date: document.data()["Date"] as! String)
                    self.myPoseArray.append(myPose)
                    self.numOfCells += 1
                        }
                    }
                self.collectionView.reloadData()
                print("load data")
            
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(numOfCells)
        return numOfCells
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("begincollectionviewcells")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyPoseCollectionViewCell", for: indexPath) as! MyPoseCollectionViewCell
        let pose = myPoseArray[indexPath.item]
        cell.poseNameLabel.text = pose.posename
        cell.dateLabel.text = pose.date
        
        let storageRef = Storage.storage().reference()

        // Points to "images"
        let imagesRef = storageRef.child("usersposes")

        // Points to "images/space.jpg"
        // Note that you can use variables to create child values
    
        let poseRef = imagesRef.child(pose.imagename)
            
        poseRef.getData(maxSize: 1 * 3024 * 3024) { data, error in
          if let error = error {
            print("error: \(error)")
          } else {
            let image = UIImage(data: data!)
            cell.coverPhoto?.image = image
          }
        }
        print("collectionviewcells")
        return cell
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

