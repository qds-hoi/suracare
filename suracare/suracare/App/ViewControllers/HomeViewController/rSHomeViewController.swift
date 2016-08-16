//
//  rSHomeViewController.swift
//  suracare
//
//  Created by hoi on 8/16/16.
//  Copyright © 2016 Sugar Rain. All rights reserved.
//

import UIKit

class rSHomeViewController: rSBaseViewController {
    
    
    
    lazy var layoutLoader: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
//        layout.itemSize = CGSize(width: self.talentinCollectionView.bounds.size.width/2 , height: self.talentinCollectionView.bounds.size.height/2.5)
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        return layout
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 
    func registerDelegateCollectionView() {
//        self.talentinCollectionView.delegate = self
//        self.talentinCollectionView.dataSource = self
//        self.talentinCollectionView.collectionViewLayout = self.layoutLoader
//        self.talentinCollectionView.registerNib(TAHomeCollectionViewCell.nib, forCellWithReuseIdentifier: TAHomeCollectionViewCell.nibName)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TAHomeCollectionViewCell.nibName, forIndexPath: indexPath) as! TAHomeCollectionViewCell
//        return cell
//    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        //device screen size
        let width = (collectionView.bounds.size.width/2) - 1
        let height = collectionView.bounds.size.height/2.2
        //calculation of cell size
        return CGSize(width: width   , height: height)
    }

}
