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
    LocationManagerDelegate {
    
    // MARK: - Constants
    let NUMBER_OF_COLUMNS: CGFloat = 2.0

    @IBOutlet weak var collectionView: UICollectionView!
    var data: [Entry]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        startLocationUpdates()
    }
    
    @objc private func reload(sender: UIRefreshControl) {
//        refreshContent()
        sender.endRefreshing()
    }
    
    // MARK: - Setup
    
    private func setup() {
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self

//        setupRefreshControl()
    }
    
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "reload:", forControlEvents: .ValueChanged)
        collectionView.addSubview(refreshControl)
    }
    
    private func refreshContent(location: CLLocation) {
        Entry.fetchAtLocation(location) { (results: [Entry]?) -> Void in
            self.data = results
            self.collectionView.reloadData()
        }
    }
    
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
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let navController = segue.destinationViewController as? UINavigationController {
            if let viewController = navController.viewControllers[0] as? CreateEntryViewController {
                viewController.onCreateHandler = { (entry: Entry) -> Void in
                    let loc = entry.location!
                    let location = CLLocation(latitude: loc.latitude, longitude: loc.longitude)
                    self.refreshContent(location)
                }
            }
        } else if let viewController = segue.destinationViewController as? EntryDetailViewController {
            if let data = data {
                if let indexPaths = collectionView.indexPathsForSelectedItems(),
                    indexPath = indexPaths.first {
                    viewController.entry = data[indexPath.row]
                }
                
            }
        }
    }
    
    // MARK: - Collection view layout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = view.frame.size.width / NUMBER_OF_COLUMNS
        return CGSizeMake(width, width)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    // MARK: - Collection view data source
    
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
        cell.backgroundColor = UIColor.groupTableViewBackgroundColor()
        cell.imageView.image = nil
        
        if let data = data {
            let d = data[indexPath.row]
            cell.textLabel.text = d.caption
            
            cell.imageView.file = d.media
            cell.imageView.loadInBackground()
        }
        
        return cell
    }
    
    // MARK: - Location manager delegate
    
    func locationManagerDidUpdateLocations(manager: LocationManager) {
        refreshContent(manager.location!)
    }
}

