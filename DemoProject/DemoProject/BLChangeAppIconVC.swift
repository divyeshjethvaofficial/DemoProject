//
//  BLChangeAppIconVC.swift
//  DemoProject
//
//  Created by P21-0043 on 17/04/24.
//

import UIKit

class BLChangeAppIconVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var setAppIconButton: UIButton!
    
    var arr : [String] = ["icon1",
    "icon2",
    "icon3",
    "icon4",
    "icon5"]
    
    var arrIconName : [String] = ["Basic icon",
    "Gold icon 1",
    "Gold icon 2",
    "Gold icon 3",
    "Gold icon 4"]
    
    var selIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setAppIconButton.layer.cornerRadius = setAppIconButton.frame.size.height/2
        selIndex = UserDefaults.standard.integer(forKey: "selectedIndex") 
    }
    
    @IBAction func setAppIconButtonTapped(_ sender: Any) {
        UserDefaults.standard.setValue(selIndex, forKey: "selectedIndex")
    }
    
}

extension BLChangeAppIconVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BLChangeAppIconCell", for: indexPath) as! BLChangeAppIconCell
        cell.imgAppIcon.image = UIImage(named: arr[indexPath.row])
        cell.lblAppTitle.text = arrIconName[indexPath.row]
        cell.bgView.layer.cornerRadius = 12
        if selIndex == indexPath.row{
            cell.bgView.layer.borderWidth = 1
            cell.bgView.layer.borderColor = UIColor.blue.cgColor
            cell.imgCheckMark.setImage(UIImage(named: "tick_fill"), for: .normal)
        }else{
            cell.bgView.layer.borderWidth = 0
            cell.imgCheckMark.setImage(UIImage(named: "tick_empty"), for: .normal)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selIndex = indexPath.row
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width / 2) - 5, height: (collectionView.frame.size.width / 2) - 5)
    }
    
}


class BLChangeAppIconCell: UICollectionViewCell{
    
    @IBOutlet weak var imgCheckMark: UIButton!
    @IBOutlet weak var imgAppIcon: UIImageView!
    @IBOutlet weak var lblAppTitle: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    override class func awakeFromNib() {
        
    }
}
