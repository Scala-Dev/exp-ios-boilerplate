//
//  ContentViewCell.swift
//  EXP iOS Boilerplate
//
//  Created by Adam Galloway on 11/3/15.
//  Copyright (c) 2015 Adam Galloway. All rights reserved.
//

import UIKit
import ExpSwift

class ContentViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    var content:ContentNode?
    
    func setContentNode(content:ContentNode?) {
        self.content = content
        
        if let urlValue = content!.getVariantUrl("320.png") {
            let url = NSURL(string: urlValue)
            let data = NSData(contentsOfURL: url!)
            var image = UIImage(data: data!)
            
            self.imageView!.image = image!
        } else {
            self.imageView!.image = UIImage(named: "FileIcon")!
        }
    }
    
}