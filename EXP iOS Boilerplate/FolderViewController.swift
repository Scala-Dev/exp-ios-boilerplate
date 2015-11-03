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

    var folderArray:[ContentNode] = []
    var contentArray:[ContentNode] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func viewControllerInit() {
        
        ExpSwift.getContentNode(folderUuid).then { (content: ContentNode) -> Void  in
            self.title = content.get("path") as? String
            
            content.getChildren().then { (children: [ContentNode]) -> Void in
                for child in children {
                    if (child.get("subtype") as? String == "scala:content:folder") {
                        self.folderArray.append(child)
                    } else {
                        self.contentArray.append(child)
                    }
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
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (section == 0) ? self.folderArray.count : self.contentArray.count
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier:"sectionHeader", forIndexPath: indexPath) as! SectionHeaderView

        headerView.headerLabel.text = (indexPath.section == 0) ? "Folders" : "Files";
        
        return headerView;

    }
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if (indexPath.section == 0) {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("folderCell", forIndexPath: indexPath) as! FolderViewCell
            
            let child = self.folderArray[indexPath.row]
            
            cell.setContentNode(child)
            cell.backgroundColor = UIColor.lightGrayColor()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("contentCell", forIndexPath: indexPath) as! ContentViewCell
            
            let child = self.contentArray[indexPath.row]
            
            cell.setContentNode(child)
            cell.backgroundColor = UIColor.lightGrayColor()
            return cell
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 0) {
            self.performSegueWithIdentifier("showFolder", sender: self)
        } else {
            self.performSegueWithIdentifier("showDetail", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let indexPaths = self.collectionView!.indexPathsForSelectedItems()
            let indexPath = indexPaths[0] as! NSIndexPath
            let nav = segue.destinationViewController as! UINavigationController
            let vc = nav.viewControllers.last as! DetailViewController
            vc.content = self.contentArray[indexPath.row]
        } else if segue.identifier == "showFolder" {
            let indexPaths = self.collectionView!.indexPathsForSelectedItems()
            let indexPath = indexPaths[0] as! NSIndexPath
            let nav = segue.destinationViewController as! UINavigationController
            let vc = nav.viewControllers.last as! FolderViewController
            vc.folderUuid = self.folderArray[indexPath.row].uuid
            vc.viewControllerInit()
        }
    }
    
}