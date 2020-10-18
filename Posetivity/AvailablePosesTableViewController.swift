//
//  AvailablePosesTableViewController.swift
//  Posetivity
//
//  Created by Summer Hasama on 10/17/20.
//

import UIKit
import Firebase


struct Poses {
    var posename: String
    var poselevel: String
    var posedescription: String
    var imagename: String
    
}

class AvailablePosesTableViewController: UITableViewController {
    
var db = Firestore.firestore()
var pose = Poses?.self
var numOfCells = 0 

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        loadData()
    }

    // MARK: - Table view data source
    
    var poseArray = [Poses]()
    
    func loadData() {
        db.collection("poses").getDocuments { (querySnapshot, error) in
               if let error = error {
                   print("\(error.localizedDescription)")
               }
               else {
                for document in (querySnapshot?.documents)! {
                    let pose = Poses(posename: document.data()["Name"] as! String, poselevel: document.data()["Level"] as! String, posedescription: document.data()["Description"] as! String, imagename: document.data()["File Name"] as! String)
                    self.poseArray.append(pose)
                    self.numOfCells += 1
                        }
                    }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
                    
            }
        }
        
        
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return numOfCells
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AvailablePosesCell", for: indexPath) as! AvailablePosesCell
        let pose = poseArray[indexPath.row]
        cell.poseName.text = pose.posename
        cell.poseLevel.text = pose.poselevel
        cell.poseDescription.text = pose.posedescription
        
        let storageRef = Storage.storage().reference()

        // Points to "images"
        let imagesRef = storageRef.child("poses")

        // Points to "images/space.jpg"
        // Note that you can use variables to create child values
        let fileName = pose.imagename + ".png"
        let poseRef = imagesRef.child(fileName)
            
            
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        poseRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
          if let error = error {
            print("error: \(error)")
          } else {
            let image = UIImage(data: data!)
            cell.availablePoseImage?.image = image
          }
        }
        return cell
    }

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let poseimagename = poseArray[indexPath!.row].imagename
        let passposename = poseArray[indexPath!.row].posename
        // Pass the selected object to the new view controller.
        let DetectPoseViewController = segue.destination as! DetectPoseViewController
        DetectPoseViewController.poseimagename = poseimagename
        DetectPoseViewController.passposename = passposename
        
    }
    

}
