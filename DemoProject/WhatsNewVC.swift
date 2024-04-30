//
//  WhatsNewVC.swift
//  DemoProject
//
//  Created by P21-0043 on 09/04/24.
//

import UIKit

class WhatsNewVC: UIViewController {

    
    @IBOutlet weak var whatsNewBGView: UIView!
    @IBOutlet weak var whatsNewLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pagination: UIPageControl!
    
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        
    }
}

extension WhatsNewVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WhatsNewCell", for: indexPath) as! WhatsNewCell
        cell.imgView.image = UIImage(named: "bee")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(indexPath.row)
        index = indexPath.row
    }
}

extension WhatsNewVC : UIPageViewControllerDelegate{
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.pagination.currentPage = index
    }
}
