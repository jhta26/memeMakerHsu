//
//  MemeEditorViewController.swift
//  MemeExperiment
//
//  Created by Jason Hsu on 2/15/17.
//  Copyright © 2017 Jason Hsu. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var albumButton: UIBarButtonItem!
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet var shareButton: UIBarButtonItem!
    
    var memedImage : UIImage?
    var meme: Meme!
    
    
   
    
     func configureTextFields(_ textfield: UITextField){
        
        
    let textAttributes: [String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -4.0
        ]
        
        textfield.defaultTextAttributes = textAttributes
        
        textfield.adjustsFontSizeToFitWidth = true
        textfield.textAlignment = .center
        textfield.delegate = self
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        topTextField.text = "Top"
        bottomTextField.text = "Bottom"
        
        configureTextFields(topTextField)
        configureTextFields(bottomTextField)
        
        shareButton.isEnabled = false
        
        
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeToKeyboardNotifications()
    }
   
    

    @IBAction func pickAnImageFromAlbum(_sender: UIBarButtonItem){
      pickAnImage(sourceType: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_sender:UIBarButtonItem){
       pickAnImage(sourceType: .camera)
    }
    
     func pickAnImage(sourceType: UIImagePickerControllerSourceType) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        self.present(imagePicker,animated: true, completion: nil)
        shareButton.isEnabled = true
    }
       func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
       dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image = image
            
        }
        dismiss(animated: true, completion: nil)
        
    }
    func textFieldDidBeginEditing(_ textfield: UITextField){
        if topTextField.isEditing {
            textfield.text = ""
        }
        if (bottomTextField.isEditing) {
            textfield.text = ""
      
        }
    }
    func textFieldShouldReturn (_ textfield: UITextField) -> Bool{
       textfield.resignFirstResponder()
        return true
    }
    
    func subscribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
     func keyboardWillShow(_ notification: Notification){
        if bottomTextField.isEditing{
        view.frame.origin.y = 0 - getKeyboardHeight(notification)
    }
    }
    func getKeyboardHeight(_ notification: Notification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    func keyboardWillHide(_ notification: Notification){
        view.frame.origin.y = 0
    }
 
    func generateMemeImage() -> UIImage {
        
        hideNavBarAndToolBar(hide: true)
        
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        
        hideNavBarAndToolBar(hide: false)
        
        return memedImage
        
    }
    
    func hideNavBarAndToolBar (hide: Bool){
            navigationController?.navigationBar.isHidden = hide
            toolBar.isHidden = hide
    
        }
    func save(){
        meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: generateMemeImage())
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    @IBAction func cancelButton(_sender: AnyObject){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareButton(_ sender: AnyObject){
        memedImage = generateMemeImage()
        
        let activityViewController = UIActivityViewController(activityItems: [memedImage as Any], applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = {activityType, completed, returnedItems, error in if (completed){
            
            self.save()
            self.dismiss(animated: true, completion: nil)
            }
        }
            present(activityViewController, animated: true, completion: nil)
        
    }
    
    
}





