//
//  CountryListDemoCell.swift
//  DemoProject
//
//  Created by P21-0043 on 10/04/24.
//

import UIKit

class CountryListDemoCell: UICollectionViewCell {
    @IBOutlet weak var tableView: UITableView!
    
}

extension CountryListDemoCell: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableCell", for: indexPath) as! CountryTableCell
        return cell
    }
    
    
}
