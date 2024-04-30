//
//  WhatsNewCell.swift
//  DemoProject
//
//  Created by P21-0043 on 09/04/24.
//

import UIKit

class WhatsNewCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    var numberOfData = 5
    var planData = ["All standard plan features are included.", "Call Forwarding", "Anonymous Call", "Remove Credits", "Unlimited MMS", "Change App Icon", "Unlimited Calling", "Unlimited Business Texting", "Cell 1 Data", "Cell 2 Data", "Cell 3 Data"]
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func updateTableViewHeight() {
        // Calculate the total height of the table view
        let totalHeight = tableView.contentSize.height
        
        // Update the height constraint of the collection view cell
        tableViewHeightConstraint.constant = totalHeight //+ self.tableView.sectionHeaderHeight
        if let collectionView = superview as? UICollectionView {
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
}

extension WhatsNewCell : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return planData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoldPlanDetailTableViewCell", for: indexPath) as! GoldPlanDetailTableViewCell
//        cell.textLabel?.text = "Hello \(indexPath.row)"
        print("1 : \(tableView.contentSize.height)")
        print("Cell Size : \(cell.bgView.frame.size.height) ")
        cell.titleLabel.text = planData[indexPath.row]
        cell.bgView.clipsToBounds = true
        tableView.invalidateIntrinsicContentSize()
        
        if indexPath.row == 0{
            cell.bgView.layer.cornerRadius = 12
            cell.bgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            cell.bgView.backgroundColor = .black
            cell.titleLabel.textColor = .white
            cell.tickImageView.isHidden = true
        } else if indexPath.row == planData.count - 1{
            cell.bgView.layer.cornerRadius = 12
            cell.bgView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.bgView.backgroundColor = .systemBackground
            cell.titleLabel.textColor = .black
            cell.tickImageView.isHidden = false
        } else {
            cell.bgView.layer.cornerRadius = 0
            cell.bgView.backgroundColor = .systemBackground
            cell.titleLabel.textColor = .black
            cell.tickImageView.isHidden = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44 // Set your desired row height here
    }
    
}
