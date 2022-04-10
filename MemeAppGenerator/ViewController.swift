//
//  ViewController.swift
//  MemeAppGenerator
//
//  Created by Rekeningku on 10/04/22.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var navigationTop: UINavigationBar!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var placeholderImage: UILabel!
    @IBOutlet weak var topTextfield: UITextField!
    @IBOutlet weak var bottomTextfield: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    let cameraController = UIImagePickerController()
    let albumController = UIImagePickerController()
    
    
    override func viewDidLoad() {
        
        navigationController?.setNavigationBarHidden(false, animated: false)
       
        setNeedsStatusBarAppearanceUpdate()
        
        cameraController.delegate = self
        albumController.delegate = self
        
        topTextfield.delegate = self
        bottomTextfield.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            cameraController.sourceType = .camera
            cameraButton.isEnabled = true
        }
        
        super.viewDidLoad()
    }
    
    
    @IBAction func openCamera(_ sender: Any) {
        present(cameraController, animated: true)
    }
    
    @IBAction func openAlbum(_ sender: Any) {
        present(albumController, animated: true)
    }
    
    
    @IBAction func onReturn(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage?{
            imageView.image = image
            placeholderImage.isHidden = true
            topTextfield.isHidden = false
            bottomTextfield.isHidden = false
            topTextfield.text = "TOP"
            bottomTextfield.text = "BOTTOM"
            saveButton.isEnabled = true
            deleteButton.isEnabled = true
        }
        dismiss(animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.isEmpty {
            return true
        }
        
        if let text = textField.text {
            textField.text = "\(text)\(string)".uppercased()
        } else {
            textField.text = string.uppercased()
        }
        
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    private func generatedImage() -> UIImage {
        UIGraphicsBeginImageContext(viewImage.frame.size)
        viewImage.drawHierarchy(in: CGRect(x: 0, y: 0, width: viewImage.frame.width, height: viewImage.frame.height), afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return memedImage
    }
    
    @IBAction func shareImage(_ sender: Any) {
        
        let topText = topTextfield.text
        let bottomText = bottomTextfield.text
        let originalImage = imageView.image
        
        if topText != nil && bottomText != nil && originalImage != nil {
            let meme = Meme(topText: topText!, bottomText: bottomText!, originalImage: originalImage!, memedImage: generatedImage())
            
            let activityViewController = UIActivityViewController(activityItems: [meme.memedImage], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = view
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.openInIBooks ]
            present(activityViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func deleteImage(_ sender: Any) {
        imageView.image = nil
        placeholderImage.isHidden = false
        topTextfield.isHidden = true
        bottomTextfield.isHidden = true
        saveButton.isEnabled = false
        deleteButton.isEnabled = false
    }
    
}

