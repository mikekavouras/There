//
//  MainStreamViewController.swift
//  There
//
//  Created by Michael Kavouras on 10/2/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit
import Parse

class MainStreamViewController: UIViewController,
    UICollectionViewDelegateFlowLayout,
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UIViewControllerPreviewingDelegate,
LocationManagerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var data: [Entry]?
    
    
    // MARK: -
    // MARK: Constants
    
    let NUMBER_OF_COLUMNS: CGFloat = 2.0
    
    
    // MARK: -
    // MARK: Life cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setup()
        startLocationUpdates()
    }
    
    
    // MARK: -
    // MARK: Setup
    
    private func setup() {
        
        setupCollectionView()
        if #available(iOS 9.0, *) {
            registerForPreviewingWithDelegate(self, sourceView: collectionView)
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
        
        if let navController = segue.destinationViewController as? UINavigationController {
            if let viewController = navController.viewControllers[0] as? CreateEntryViewController {
                viewController.onCreateHandler = { (entry: Entry) -> Void in
                    let loc = entry.location!
                    let location = CLLocation(latitude: loc.latitude, longitude: loc.longitude)
                    self.refreshContent(location)
                }
            } else if let viewController = navController.viewControllers[0] as? EntryDetailViewController {
                if let data = data {
                    if let indexPaths = collectionView.indexPathsForSelectedItems(),
                        indexPath = indexPaths.first {
                            viewController.entry = data[indexPath.row]
                    }
                    
                }
            }
        }
    }
    
    // MARK: -
    // MARK: View controller previewing
    
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        showViewController(viewControllerToCommit, sender: self)
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if #available(iOS 9.0, *) {
            let collectionView = previewingContext.sourceView as! UICollectionView
            let indexPath = collectionView.indexPathForItemAtPoint(location)
            if let indexPath = indexPath {
                if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
                    previewingContext.sourceRect = cell.frame
                }
                if let data = data {
                    let viewController = storyboard?.instantiateViewControllerWithIdentifier("EntryDetailControllerIdentifier") as! EntryDetailViewController
                    let entry = data[indexPath.row]
                    viewController.entry = entry
                    return viewController
                }
            }
        }
        

        return UIViewController()
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
        
        return 1.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 1.0
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
        }
        
        return cell
    }
    
    
    // MARK: -
    // MARK: Location manager delegate
    
    func locationManagerDidUpdateLocations(manager: LocationManager) {
        
        refreshContent(manager.location!)
    }
}

