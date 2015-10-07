//
//  CreateEntryViewController.swift
//  There
//
//  Created by Michael Kavouras on 10/2/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit
import Parse

class CreateEntryViewController: UIViewController,
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate {
    
    @IBOutlet weak var imageButton: DesignableButton!
    @IBOutlet weak var videoButton: DesignableButton!
    @IBOutlet weak var audioButton: DesignableButton!
    @IBOutlet weak var submitButton: DesignableButton!
    
    var onCreateHandler: (() -> Void)?
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var postToolbarBottomConstraint: NSLayoutConstraint!
    
    var entry: Entry = Entry()
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Setup
    
    private func setup() {
        checkFeatureRequirements()
        setupNotificationObservers()
    }
    
    private func setupNotificationObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    private func checkFeatureRequirements() {
        imageButton.enabled = UIDevice.hasCamera()
        videoButton.enabled = UIDevice.hasCamera()
    }

    // MARK: - User actions
    
    @IBAction func submitButtonTapped(sender: AnyObject) {
        entry.caption = textView.text
        entry.saveInBackgroundWithBlock { (finished: Bool, error: NSError?) -> Void in
            if let handler = self.onCreateHandler {
                handler()
            }
        }
        dismiss()
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func imageButtonTapped(sender: AnyObject) {
        showCamera(.Photo)
    }
    
    @IBAction func videoButtonTapped(sender: AnyObject) {
        showCamera(.Video)
    }
    
    @IBAction func audioButtonTapped(sender: AnyObject) {
        
    }
    
    // MARK: - Notifications
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let info = notification.userInfo {
            if let duration = (info[UIKeyboardAnimationDurationUserInfoKey] as? NSValue) as? NSTimeInterval,
                size = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
                    postToolbarBottomConstraint.constant = size.height
                    UIView.animateWithDuration(duration, animations: {
                        self.view.setNeedsLayout()
                    })
            }
        }
    }
    
    // MARK: - Image picker delegate
    

    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        let imageData = UIImageJPEGRepresentation(image, 0.8)!
        entry.media = PFFile(data: imageData)
        dismiss()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Declarative
    
    private func showCamera(captureMode: UIImagePickerControllerCameraCaptureMode) {
        let picker = UIImagePickerController()
        
        if captureMode == .Video {
            picker.mediaTypes = ["public.movie"]
        }
        
        picker.delegate = self
        picker.sourceType = .Camera
        picker.cameraCaptureMode = captureMode
        presentViewController(picker, animated: true, completion: nil)
    }
    
    @objc private func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
