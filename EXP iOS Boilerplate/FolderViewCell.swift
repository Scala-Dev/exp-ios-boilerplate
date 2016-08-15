//
//  FolderViewCell.swift
//  EXP iOS Boilerplate
//
//  Created by Adam Galloway on 11/3/15.
//  Copyright (c) 2015 Adam Galloway. All rights reserved.
//

import UIKit
import ExpSwift

class FolderViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    var content:Content?
    
    func setContentNode(content:Content?) {
        self.content = content
        
        if let label = self.detailDescriptionLabel {
            label.text = content!.get("name") as? String
        }
        
    }
    
}