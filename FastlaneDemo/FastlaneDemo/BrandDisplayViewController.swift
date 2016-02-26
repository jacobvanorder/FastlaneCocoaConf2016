//
//  ViewController.swift
//  FastlaneDemo
//
//  Created by mrJacob on 2/7/16.
//  Copyright © 2016 SushiGrass. All rights reserved.
//

import UIKit

class BrandDisplayViewController: GenericViewController, UITableViewDelegate, UITableViewDataSource {
    
    let brandToCameraSegueIdentifier = "BrandControllerDidShowCameraController"
    
    @IBOutlet var tableView: UITableView!
    var brandArray: [FlickrBrand] = [FlickrBrand]()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        struct TokenHolder {
            static var token: dispatch_once_t = 0;
        }
        
        dispatch_once(&TokenHolder.token) {
            
            FlickrBrand.fetchAllBrands({
                [weak self]
                (optionalBrandArray, optionalError) -> Void in
                
                guard let checkedSelf = self else { return }
                
                guard let newBrandArray = optionalBrandArray else {
                    checkedSelf.showError("There was a problem!", optionalError: optionalError)
                    return
                }
                
                checkedSelf.brandArray = newBrandArray
                checkedSelf.tableView.reloadData()
                SwiftSpinner.hide()
                })
            
            SwiftSpinner.show("Loading")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == brandToCameraSegueIdentifier {
            guard let cell = sender as? UITableViewCell,
                let indexPath = tableView.indexPathForCell(cell),
                let cameraDisplayViewController = segue.destinationViewController as? CameraDisplayTableViewController else {
                    return
            }
            
            let selectedBrand = brandArray[indexPath.row]
            cameraDisplayViewController.readFlickrBrand(selectedBrand)
        }
    }
    
    //MARK: - UITableViewDataSource && UITableViewDelegate -
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brandArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BrandCell", forIndexPath: indexPath)
        let brand = brandArray[indexPath.row]
        cell.textLabel?.text = brand.name
        cell.detailTextLabel?.text = "Rank: \(brand.rank)"
        return cell
    }
}

