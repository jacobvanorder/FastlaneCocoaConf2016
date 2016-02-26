//
//  GenericTableViewController.swift
//  FastlaneDemo
//
//  Created by mrJacob on 2/27/16.
//  Copyright © 2016 SushiGrass. All rights reserved.
//

import UIKit

class GenericViewController: UIViewController {
    
    internal func showError(optionalMessage: String?, optionalError: NSError?) {
        NSOperationQueue.mainQueue().addOperationWithBlock({
            SwiftSpinner.hide()
            
            let message: String
            
            if optionalMessage != .None {
                message = optionalMessage!
            }
            else if optionalError != .None {
                message = optionalError!.description
            }
            else {
                message = "There was an issue."
            }
            
            let alertController = UIAlertController(title: "Whoopsie Doodle", message: message, preferredStyle: .Alert)
            let action = UIAlertAction(title: "Okay!", style: .Cancel, handler: .None)
            alertController.addAction(action)
            self.presentViewController(alertController, animated: true, completion: nil)
        })
    }
    
}
