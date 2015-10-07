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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshContent()
    }
    
    @objc private func reload(sender: UIRefreshControl) {
        refreshContent()
        sender.endRefreshing()
    }
    
    // MARK: - Setup
    
    private func setup() {
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self

        setupRefreshControl()
    }
    
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "reload:", forControlEvents: .ValueChanged)
        collectionView.addSubview(refreshControl)
    }
    
    private func refreshContent() {
        Entry.fetchLatest { (results: [Entry]?) -> Void in
            self.data = results
            self.collectionView.reloadData()
        }
    }
    
    private func startLocationUpdates() {
        if LocationManager.authorizationStatus() == .Denied {
            let alert = UIAlertController(title: "Location", message: "This app is useless without your location", preferredStyle: .Alert)
            presentViewController(alert, animated: true, completion: nil)

        } else {
            let manager = LocationManager.sharedManager
            manager.delegate = self
            manager.requestWhenInUseAuthorization()
            manager.start()
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let viewController = segue.destinationViewController as? CreateEntryViewController {
            viewController.onCreateHandler = {
                self.collectionView.reloadData()
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
        print(manager.location)
    }
}

