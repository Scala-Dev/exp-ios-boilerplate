//
//  FolderViewController.swift
//  EXP iOS Boilerplate
//
//  Created by Galloways on 11/2/15.
//  Copyright (c) 2015 Adam Galloway. All rights reserved.
//

import UIKit
import ExpSwift


class FolderViewController: UICollectionViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    var folderUuid = "root"

    var thumbnailArray:[UIImage] = []
    var contentArray:[ContentNode] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func viewControllerInit(){
        ExpSwift.getContentNode(folderUuid).then { (content: ContentNode) -> Void  in
            content.getChildren().then { (children: [ContentNode]) -> Void in
                for child in children {
                    let url = NSURL(string: child.getUrl())
                    let data = NSData(contentsOfURL: url!)
                    var image = UIImage(data: data!)
                    
                    self.thumbnailArray.append(image!)
                }
                
                self.collectionView!.reloadData()
            }.catch { error in
                println(error)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.contentArray.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ContentCollectionViewCell
        cell.imageView?.image = self.thumbnailArray[indexPath.row]
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedContent = self.contentArray[indexPath.row]
        
        if (selectedContent.get("subtype") as! String == "scala:content:folder") {
            self.performSegueWithIdentifier("showDetail", sender: self)
        } else {
            self.performSegueWithIdentifier("showDetail", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let indexPaths = self.collectionView!.indexPathsForSelectedItems()
            let indexPath = indexPaths[0] as! NSIndexPath
            let vc = segue.destinationViewController as! DetailViewController
            vc.content = self.contentArray[indexPath.row]
        } else if segue.identifier == "showFolder" {
            let indexPaths = self.collectionView!.indexPathsForSelectedItems()
            let indexPath = indexPaths[0] as! NSIndexPath
            let vc = segue.destinationViewController as! FolderViewController
            vc.folderUuid = self.contentArray[indexPath.row].uuid
        }
    }
    
}