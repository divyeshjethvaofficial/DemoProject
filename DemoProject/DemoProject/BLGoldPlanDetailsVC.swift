//
//  BLGoldPlanDetailsVC.swift
//  DemoProject
//
//  Created by P21-0043 on 18/04/24.
//

import UIKit

class BLGoldPlanDetailsVC: UIViewController {
  
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var segmentControll: UISegmentedControl!
    var collectionViewData = ["Cell 1 Data", "Cell 2 Data", "Cell 3 Data"]
    let numberOfData = 6
    override func viewDidLoad() {
        super.viewDidLoad()
//        collectionViewHeightConstraint.constant = UIScreen.main.bounds.height - 200
    }
    
    override func viewDidLayoutSubviews() {
                collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    @IBAction func segmentChange(_ sender: Any) {
        print("Index : \(segmentControll.selectedSegmentIndex)")
    }
    
}

extension BLGoldPlanDetailsVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WhatsNewCell", for: indexPath) as! WhatsNewCell
        cell.tableView.reloadData()
        cell.updateTableViewHeight()
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cell = collectionView.cellForItem(at: indexPath) as? WhatsNewCell
        if cell != nil {
            collectionViewHeightConstraint.constant = cell!.tableView.contentSize.height
            print("IndexPath : \(indexPath.row), Width : \(collectionView.frame.size.width)")
            return CGSize(width: collectionView.frame.size.width - 20, height: cell!.tableView.contentSize.height)
        }
        print("collectionView.bounds.size : \(collectionView.bounds.size)")
        return collectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        var visibleIndex = collectionView.indexPathsForVisibleItems
        print("visibleIndex : \(visibleIndex) indexPath : \(indexPath.row)")
        var indexPathItem = 0
        for indexPath in visibleIndex {
            // Get the row (or item) from the index path
            indexPathItem = indexPath.item
            print("Row: \(indexPathItem)")
        }
        self.segmentControll.selectedSegmentIndex = indexPathItem
    }
    
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        let x = targetContentOffset.pointee.x
//        segmentControll.selectedSegmentIndex = Int(x / view.frame.width)
//    }
}
