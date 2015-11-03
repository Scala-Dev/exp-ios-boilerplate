//
//  DetailViewController.swift
//  EXP iOS Boilerplate
//
//  Created by Adam Galloway on 11/2/15.
//  Copyright (c) 2015 Adam Galloway. All rights reserved.
//

import UIKit
import ExpSwift

class DetailViewController: UIViewController {

    @IBOutlet weak var detailImage: UIImageView!
    
    @IBOutlet weak var flingButton: UIButton!
    
    var content:ContentNode? = nil

    func configureView() {
        // Update the user interface for the detail item.
        if let detail: ContentNode = self.content {
            // set label
            self.title = detail.get("name") as? String
            
            // set image
            if let image = self.detailImage {
                if let urlValue = detail.getVariantUrl("1080.png") {
                    let url = NSURL(string: urlValue)
                    let data = NSData(contentsOfURL: url!)
                    var imageData = UIImage(data: data!)
                    image.image = imageData
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

}

