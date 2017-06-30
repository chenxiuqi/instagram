//
//  EditProfileViewController.swift
//  instagram
//
//  Created by Xiu Chen on 6/29/17.
//  Copyright © 2017 Xiu Chen. All rights reserved.
//

import UIKit
import Parse

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var bioField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var usernameLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = PFUser.current()!
        usernameLabel.text = user.username
        bioField.text = user["biography"] as? String
        nameField.text = user["name"] as? String
        let imageURL = user["profile_picture"] as? PFFile
        
        imageURL?.getDataInBackground { (imageData:Data!,error: Error?) in
            self.selectedImage.image = UIImage(data:imageData)
        
        self.selectedImage.layer.cornerRadius = (self.selectedImage.frame.size.width / 2)
        self.selectedImage.layer.masksToBounds = true
            
            
            // Do any additional setup after loading the view.
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onEditImage(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        // let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        selectedImage.image = originalImage
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onSaveChanges(_ sender: Any) {
        
        let user = PFUser.current()!
        if selectedImage.image != nil {
            user["profile_picture"] = Post.getPFFileFromImage(image: selectedImage.image)
        }
        user["name"] = nameField.text
        user["biography"] = bioField.text
        user.saveInBackground()
        
        
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
