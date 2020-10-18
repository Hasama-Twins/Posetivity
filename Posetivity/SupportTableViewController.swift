//
//  SupportTableViewController.swift
//  Posetivity
//
//  Created by Summer Hasama on 10/17/20.
//

import UIKit
import Firebase

struct Posts {
    var postcaption: String
    var postdate: String
    var username: String
    var posename: String
    var filename: String
}

class SupportTableViewController: UITableViewController {



    
    
var db = Firestore.firestore()
var post = Posts?.self
var numOfCells = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        loadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    var postArray = [Posts]()
    // MARK: - Table view data source
    func loadData() {
        db.collection("feed").order(by: "Date", descending: true).getDocuments { (querySnapshot, error) in
               if let error = error {
                   print("\(error.localizedDescription)")
               }
               else {
                for document in (querySnapshot?.documents)! {
                    let post = Posts(postcaption: document.data()["Caption"] as! String, postdate: document.data()["Date"] as! String, username: document.data()["Username"] as! String, posename: document.data()["Name"] as! String, filename: document.data()["File Name"] as! String)
                    self.postArray.append(post)
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


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell{
        // #warning Incomplete implementation, return the number of rows
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SupportPostCell", for: indexPath) as! SupportPostCell
        let post = postArray[indexPath.row]
        cell.poseTopLabel.text = post.username + " can do " + post.posename + " pose!"
        cell.dateLabel.text = post.postdate
        cell.captionLabel.text = post.postcaption
        
        
        
        let storageRef = Storage.storage().reference()

        // Points to "images"
        let imagesRef = storageRef.child("feed")

        // Points to "images/space.jpg"
        // Note that you can use variables to create child values
        let fileName = post.filename
        let poseRef = imagesRef.child(fileName)
            
            
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        poseRef.getData(maxSize: 1 * 4024 * 4024) { data, error in
          if let error = error {
            print("error: \(error)")
          } else {
            let image = UIImage(data: data!)
            cell.coverPhoto?.image = image
          }
        }
        return cell
    }

   
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


