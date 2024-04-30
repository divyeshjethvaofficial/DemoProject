//
//  CustomViewController.swift
//  DemoProject
//
//  Created by P21-0043 on 29/04/24.
//

import UIKit

class CustomViewController: UIViewController {

    @IBOutlet weak var customView: CustomView!
    @IBOutlet weak var lblHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblHeightConstraint.constant = customView.sizeOfText
    }

}
