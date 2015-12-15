//
//  MainStreamViewController.swift
//  There
//
//  Created by Michael Kavouras on 10/2/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit
import Parse
import ParseTwitterUtils

class MainStreamViewController: UIViewController,
    UICollectionViewDelegateFlowLayout,
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UIViewControllerPreviewingDelegate,
    LocationManagerDelegate,
    UploadQueueDelegate {
    
    @IBOutlet weak var statusView: UploadStatusView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var data: [Entry]?
    
    
    // MARK: -
    // MARK: Constants
    
    let NUMBER_OF_COLUMNS: CGFloat = 3.0
    
    
    // MARK: -
    // MARK: Life cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setup()
        startLocationUpdates()
        
        // questionable
        UploadQueue.sharedQueue.delegate = self
        
//        if let user = PFUser.currentUser() {
//            if PFAnonymousUtils.isLinkedWithUser(user) {
//                showTwitterLogin()
//            }
//        }
    }
    
    private func showTwitterLogin() {
        PFTwitterUtils.logInWithBlock({ (user: PFUser?, error: NSError?) -> Void in
            print(user)
        })
    }
    
    
    // MARK: -
    // MARK: Setup
    
    private func setup() {
        
        setupCollectionView()
        
        if #available(iOS 9.0, *) {
            if traitCollection.forceTouchCapability == .Available {
                registerForPreviewingWithDelegate(self, sourceView: collectionView)
            }
        }
    }
    
    private func setupCollectionView() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func refreshContent(location: CLLocation) {
        
        Entry.fetchAtLocation(location) { (results: [Entry]?) -> Void in
            self.data = results
            self.collectionView.reloadData()
        }
    }
    
    
    // MARK: -
    // MARK: Location manager
    
    private func startLocationUpdates() {
        
        let manager = LocationManager.sharedManager
        manager.delegate = self
        
        switch LocationManager.authorizationStatus() {
        case .Denied:
            let alert = UIAlertController(title: "Location", message: "This app is useless without your location", preferredStyle: .Alert)
            let action = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
            alert.addAction(action)
            presentViewController(alert, animated: true, completion: nil)
        case .NotDetermined:
            manager.requestWhenInUseAuthorization()
        default:break
        }
        
        manager.start()
    }
    
    
    // MARK: -
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let viewController = segue.destinationViewController as? EntryDetailViewController,
            indexPaths = collectionView.indexPathsForSelectedItems(),
            indexPath = indexPaths.first,
            data = data {
                viewController.entry = data[indexPath.row]
        }
    }
    
    
    // MARK: -
    // MARK: View controller previewing
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        
        if let viewController = viewControllerToCommit as? EntryDetailViewController {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        if #available(iOS 9.0, *) {
            let collectionView = previewingContext.sourceView as! UICollectionView
            let indexPath = collectionView.indexPathForItemAtPoint(location)
            if let indexPath = indexPath,
                cell = collectionView.cellForItemAtIndexPath(indexPath),
                viewController = storyboard?.instantiateViewControllerWithIdentifier("EntryDetailControllerIdentifier") as?EntryDetailViewController,
                data = data {
                    
                    previewingContext.sourceRect = cell.frame
                    let entry = data[indexPath.row]
                    viewController.entry = entry
                    return viewController
            }
        }
        
        return nil
    }

    // MARK: -
    // MARK: Collection view layout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let width = view.frame.size.width / NUMBER_OF_COLUMNS - 0.5
        return CGSizeMake(width, width)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 0.5
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 0.5
    }
    
    
    // MARK: -
    // MARK: Collection view data source
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let data = data {
            return data.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MainStreamCellIdentifier", forIndexPath: indexPath) as! MainStreamCollectionViewCell
        
        if let data = data {
            let entry = data[indexPath.row]
            cell.entry = entry
            cell.imageView.file = entry.typeMapped == .Video ? entry.posterImage : entry.media
            cell.imageView.loadInBackground()
        }
        
        return cell
    }
    
    
    // MARK: -
    // MARK: Location manager delegate
    
    func locationManagerDidUpdateLocations(manager: LocationManager) {
        
        refreshContent(manager.location!)
    }
    
    
    // MARK: -
    // MARK: Upload queue delegate
    
    func uploadQueueWillProcessUpload(queue: UploadQueue) {
        
        statusView.statusLabel.text = queue.description
        
        statusView.show()
    }
    
    func uploadQueueDidProcessUpload(queue: UploadQueue) {
        
        statusView.statusLabel.text = queue.description
        
        if let location = LocationManager.sharedManager.location {
           refreshContent(location)
        }
        
        if queue.isEmpty {
            statusView.statusLabel.text = "Uploaded :)"
            statusView.hide()
        }
    }
}

