//
//  DetectPoseViewController.swift
//  Posetivity
//
//  Created by Summer Hasama on 10/17/20.
//

import UIKit
import Firebase
import MLKit




class DetectPoseViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    
    @IBOutlet weak var inputImage: UIImageView!
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var poseLabel: UILabel!
    @IBOutlet weak var poseImageView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        let storageRef = Storage.storage().reference()
        if let uploadData = self.inputImage.image!.pngData(){
            let posesRef = storageRef.child("temporaryimages/\(poseimagename)")
            posesRef.putData(uploadData)
        }
            }
    
    
    var imageLabeler : ImageLabeler?
    var poseimagename: String = ""
    var passposename: String = ""
    
    
    @IBAction func fetchFromGallery(_ sender: Any) {
    let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    
    }
    
    
    @IBAction func fetchFromCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            present(imagePicker, animated: true)
    }
    
    func initializeMLModel(){
        guard let manifestPath = Bundle.main.path(forResource: "manifest", ofType: "json", inDirectory:"downloadedmodel") else{
            print("Couldn't find manifest.json file")
            return
        }
        let myLocalModel = AutoMLImageLabelerLocalModel(manifestPath: manifestPath)
        let labelerOptions = AutoMLImageLabelerOptions(localModel: myLocalModel)
        labelerOptions.confidenceThreshold = 0.5
        imageLabeler = ImageLabeler.imageLabeler(options: labelerOptions)
    }
     
    func performMLMagicOn( visionImage: VisionImage){
        imageLabeler?.process(visionImage, completion: { (labels, error) in
            if let error = error {
                print("error: \(error.localizedDescription)")
                return
            }
            if let labels = labels {
                if labels.count == 0 {
                    self.resultsLabel.text = "Please choose or retake image"
                    self.nextButton.setTitleColor(.white, for: .normal)
                    return
                }
                for visionLabel in labels {
                    var returnString = ""

                 //   let confidence = visionLabel.confidence
                    if self.passposename == "Tree"{
                        if visionLabel.text == "tree" {
                            returnString = "Congrats your strong body enables you to perform the tree pose"
                            self.resultsLabel.text = returnString
                            self.nextButton.setTitleColor(.black, for: .normal)
                        } else {
                            let returnString = "Almost there, try again"
                            self.resultsLabel.text = returnString
                            self.nextButton.setTitleColor(.white, for: .normal)
                        }
                    }
                    if self.passposename == "Warrior 1" {
                        if visionLabel.text == "warrior1" {
                            let returnString = "Congrats your strong body enables you to perform the warrior 1 pose"
                            self.resultsLabel.text = returnString
                            self.nextButton.setTitleColor(.black, for: .normal)
                        } else {
                            let returnString = "Almost there, try again"
                            self.resultsLabel.text = returnString
                            self.nextButton.setTitleColor(.white, for: .normal)
                        }
                    }
                    if self.passposename == "Side Forearm Plank"{
                        if visionLabel.text == "sideplank" {
                            let returnString = "Congrats your strong body enables you to perform the side plank pose"
                            self.resultsLabel.text = returnString
                            self.nextButton.setTitleColor(.black, for: .normal)
                        } else {
                            let returnString = "Almost there, try again"
                            self.resultsLabel.text = returnString
                            self.nextButton.setTitleColor(.white, for: .normal)
                        }
                    }
            }
        }
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeMLModel()
        
        self.poseLabel.text = passposename
        self.view.bringSubviewToFront(poseLabel)
        
        let storageRef = Storage.storage().reference()

        let imagesRef = storageRef.child("poses")

        let fileName = poseimagename + ".png"
        let poseRef = imagesRef.child(fileName)
            
            
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        poseRef.getData(maxSize: 1 * 4024 * 4024) { data, error in
          if let error = error {
            print("error: \(error)")
          } else {
            let image = UIImage(data: data!)
            self.poseImageView?.image = image
          }
            
            self.nextButton.setTitleColor(.white, for: .normal)
        
        
        // Do any additional setup after loading the view.
    }
    }
      
      //  extension DetectPoseViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
        
    private func imagePickerControllerDidCancel( picker: UIImagePickerControllerDelegate){
            dismiss(animated: true)
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            var imageToSave: UIImage?
            if let editedImage = info[.editedImage] as? UIImage {
                imageToSave = editedImage
            }else if let originalImage = info[.originalImage] as? UIImage {
                imageToSave = originalImage
            }
            inputImage.image = imageToSave
            resultsLabel.text = ""
            dismiss(animated:true)
            guard imageToSave != nil else{
                print("got no image")
                return
            }
            let visionImage = VisionImage(image: imageToSave!)
            self.resultsLabel.text = ""
            performMLMagicOn(visionImage: visionImage)
              
                }
            
        
            
    

        // Success. Get pose landmarks here.
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let FinalizePoseViewController = segue.destination as! FinalizePoseViewController
        FinalizePoseViewController.poseimagename = poseimagename
        FinalizePoseViewController.passposename = passposename
            
        
        }
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
}

 
