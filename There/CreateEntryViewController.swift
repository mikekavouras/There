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
    
    var onCreateHandler: ((entry: Entry) -> Void)?
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var postToolbarBottomConstraint: NSLayoutConstraint!
    
    lazy var entry: Entry = {
        let e = Entry()
        e.typeMapped = .Text
        return e
    }()
    
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
        audioButton.enabled = false
    }

    // MARK: - User actions
    
    @IBAction func submitButtonTapped(sender: AnyObject) {
        if let location = LocationManager.sharedManager.location {
            if location.horizontalAccuracy <= MAX_DISTANCE_FILTER {
                entry.caption = textView.text
                entry.location = PFGeoPoint(location: LocationManager.sharedManager.location)
                entry.saveInBackgroundWithBlock { (finished: Bool, error: NSError?) -> Void in
                    if let handler = self.onCreateHandler {
                        handler(entry: self.entry)
                    }
                }
                dismiss()
            } else {
                throwLocationAlert()
            }
        } else {
            throwLocationAlert()
        }
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let type = info[UIImagePickerControllerMediaType] as? String {
            if type == "public.image" {
                if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                    let imageData = UIImageJPEGRepresentation(image, 0.8)!
                    entry.media = PFFile(data: imageData)
                    entry.typeMapped = .Image
                }
            } else if type == "public.movie" {
                if let file = info[UIImagePickerControllerMediaURL] as? NSURL {
                    if let videoData = NSData(contentsOfURL: file) {
                        entry.media = PFFile(data: videoData)
                        entry.typeMapped = .Video
                    }
                }
            }
        }
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
            picker.videoMaximumDuration = 5
        }
        
        picker.delegate = self
        picker.sourceType = .Camera
        picker.cameraCaptureMode = captureMode
        presentViewController(picker, animated: true, completion: nil)
    }
    
    private func throwLocationAlert() {
        let alert = UIAlertController(title: "Location", message: "Location accuracy isn't good enough", preferredStyle: .Alert)
        let action = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @objc private func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
