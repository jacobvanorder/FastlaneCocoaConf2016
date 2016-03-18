//
//  CameraDetailsViewController.swift
//  FastlaneDemo
//
//  Created by mrJacob on 2/27/16.
//  Copyright © 2016 SushiGrass. All rights reserved.
//

import UIKit

class CameraDetailsViewController: GenericViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var brandLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    var brand: FlickrBrand?
    var camera: FlickrCamera?
    
    func readBrand(brand: FlickrBrand, camera: FlickrCamera) {
        self.brand = brand
        self.camera = camera
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        brandLabel.text = brand?.name
        nameLabel.text = camera?.name
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        guard let largeImageURL = camera?.largeImageURL else { return }
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(largeImageURL) {
            [weak self]
            (optionalData, _, optionalError) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                guard let data = optionalData,
                    let image = UIImage(data: data) else {
                        self?.showError(.None, optionalError: optionalError)
                        return
                }
                
                self?.imageView.image = image
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            })
        }
        
        task.resume()
    }
}
