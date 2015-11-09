//
//  CreateEntryViewController.swift
//  There
//
//  Created by Michael Kavouras on 10/2/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit
import MobileCoreServices
import Parse

class CreateEntryViewController: UIViewController,
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate {
    
    // MARK: -
    // MARK: Constants
    
    
    /* VIDEO QUALITY (10 seconds) (Parse max upload = 10mb)
    TypeLow:               67289 bytes (0.067mb)
    TypeMedium:           964722 bytes (0.9mb)
    Type640x480:         4467734 bytes (4.47mb)
    TypeHigh:           15775077 bytes (15.78mb)
    TypeIFrame960x540:  37579515 bytes (37.58mb)
    TypeIFrame1280x720: 49055343 bytes (49.06mb)
    */
    let VIDEO_QUALITY: UIImagePickerControllerQualityType = .TypeMedium
    
    let MAX_VIDEO_DURATION: NSTimeInterval = 10
    
    let FINAL_IMAGE_WIDTH: CGFloat = 1080.0
    let FINAL_IMAGE_QUALITY: CGFloat = 0.6
    
    @IBOutlet weak var imageButton: DesignableButton!
    @IBOutlet weak var videoButton: DesignableButton!
    @IBOutlet weak var audioButton: DesignableButton!
    @IBOutlet weak var submitButton: DesignableButton!
    
    @IBOutlet weak var saveToCameraRollToggle: SelectableCircleView!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var postToolbarBottomConstraint: NSLayoutConstraint!
    
    private lazy var entry: Entry = {
        let e = Entry()
        e.typeMapped = .Text
        return e
    }()
    
    
    // MARK: -
    // MARK: Life cycle

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    deinit {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    // MARK: -
    // MARK: Setup
    
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

    
    // MARK: -
    // MARK: User actions
    
    @IBAction func submitButtonTapped(sender: AnyObject) {
        saveEntry()
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
        
        print("audio button tapped")
    }
    
    
    // MARK: -
    // MARK: Notifications
    
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
    
    
    // MARK: -
    // MARK: Image picker delegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let type = info[UIImagePickerControllerMediaType] as? String {
            if type == kUTTypeImage as String {
                if let image = info[UIImagePickerControllerOriginalImage] as? UIImage,
                    scaledImage = image.scale(FINAL_IMAGE_WIDTH / image.size.width) {
                    let imageData = UIImageJPEGRepresentation(scaledImage, FINAL_IMAGE_QUALITY)
                    entry.media = PFFile(data: imageData!, contentType: "image/jpeg")
                    entry.typeMapped = .Image
                    entry.image = image
                }
            } else if type == kUTTypeMovie as String {
                if let file = info[UIImagePickerControllerMediaURL] as? NSURL,
                    videoData = NSData(contentsOfURL: file),
                    image = file.thumbnailImagePreview(),
                    scaledImage = image.scale(FINAL_IMAGE_WIDTH / image.size.width) {
                        let imageData = UIImageJPEGRepresentation(scaledImage, FINAL_IMAGE_QUALITY)
                        entry.videoURL = file
                        entry.posterImage = PFFile(data: imageData!, contentType: "image/jpeg")
                        entry.media = PFFile(data: videoData, contentType: "video/mp4")
                        entry.typeMapped = .Video
                }
            }
        }
        
        dismiss()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: -
    // MARK: Declarative
    
    private func saveEntry() {
        
        if let location = LocationManager.sharedManager.location {
            if location.horizontalAccuracy <= MAX_DISTANCE_FILTER {
                entry.caption = textView.text
                entry.location = PFGeoPoint(location: LocationManager.sharedManager.location)
                if entry.isValid {
                    
                    entry.saveLocal = saveToCameraRollToggle.selected
                    UploadQueue.sharedQueue.addItem(Upload(entry: entry))
                    
                    dismiss()
                } else {
                    throwInvalidAlert()
                }
            } else {
                throwLocationAlert()
            }
        } else {
            throwLocationAlert()
        }
    }
    
    private func showCamera(captureMode: UIImagePickerControllerCameraCaptureMode) {
        
        let picker = UIImagePickerController()
        
        if captureMode == .Video {
            picker.mediaTypes = [kUTTypeMovie as String]
            picker.videoMaximumDuration = MAX_VIDEO_DURATION
            picker.videoQuality = VIDEO_QUALITY
        } else {
            picker.mediaTypes = [kUTTypeImage as String]
            if #available(iOS 9.1, *) {
//                picker.mediaTypes += [kUTTypeLivePhoto as String]
            }
        }
        
        picker.delegate = self
        picker.sourceType = .Camera
        picker.cameraCaptureMode = captureMode
        picker.cameraFlashMode = .Off
        presentViewController(picker, animated: true, completion: nil)
    }
    
    private func throwLocationAlert() {
        
        let alert = UIAlertController(title: "Location", message: "Location accuracy isn't good enough", preferredStyle: .Alert)
        let action = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    private func throwInvalidAlert() {
        
        let alert = UIAlertController(title: "Entry", message: "You need to add media or text", preferredStyle: .Alert)
        let action = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @objc private func dismiss() {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
