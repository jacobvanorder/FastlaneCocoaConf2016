//
//  CameraDisplayTableViewController.swift
//  FastlaneDemo
//
//  Created by mrJacob on 2/27/16.
//  Copyright © 2016 SushiGrass. All rights reserved.
//

import UIKit

class CameraDisplayTableViewController: GenericViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cameraToCameraDetailsSegueIdentifier = "CameraControllerDidShowCameraDetailsController"
    
    @IBOutlet var tableView: UITableView!
    private var brand: FlickrBrand?
    
    func readFlickrBrand(brand: FlickrBrand) {
        self.brand = brand
        self.title = self.brand?.name
        if self.brand?.cameras.count == 0 {
            SwiftSpinner.show(NSLocalizedString("Loading", comment: "The Loading string for cameras fetch"))
            self.brand?.fetchCameras({
                [weak self]
                (success, optionalError) -> Void in
                
                guard let checkedSelf = self else { return }
                
                if success {
                    checkedSelf.tableView.reloadData()
                    SwiftSpinner.hide()
                }
                else {
                    checkedSelf.showError(.None, optionalError: optionalError)
                }
                })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == cameraToCameraDetailsSegueIdentifier {
            guard let cell = sender as? UITableViewCell,
                let indexPath = tableView.indexPathForCell(cell),
                let cameraDetailsViewController = segue.destinationViewController as? CameraDetailsViewController,
                validBrand = brand else {
                    return
            }
            
            let selectedCamera = validBrand.cameras[indexPath.row]
            cameraDetailsViewController.readBrand(validBrand, camera: selectedCamera)
        }
    }
    
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let validBrand = brand else { return 0 }
        return validBrand.cameras.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CameraCell", forIndexPath: indexPath)
        if let camera = brand?.cameras[indexPath.row] {
            cell.textLabel?.text = camera.name
        }
        return cell
    }
}
