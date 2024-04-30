//
//  IAPVC.swift
//  DemoProject
//
//  Created by P21-0054 on 2/22/24.
//

import UIKit
import StoreKit
import SwiftyStoreKit

struct IAPData {
    let title: String
    let productID: String
}

class IAPVC: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        IAPManager.shared.fetchProuducts {
            DispatchQueue.main.async {
                self.tblView.reloadData()
            }
        }
    }
    
    @IBAction func btnChangeAppIconTapped(_ sender: Any) {
        changeAppIcon(to: "bee")
    }
    
    func changeAppIcon(to iconName: String) {
        if UIApplication.shared.supportsAlternateIcons {
            UIApplication.shared.setAlternateIconName(iconName) { error in
                if let error = error {
                    print("Failed to change app icon: \(error)")
                } else {
                    print("App icon changed successfully to \(iconName)")
                }
            }
        } else {
            print("Alternate icons not supported on this device")
        }
    }
}

extension IAPVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IAPManager.shared.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let iapData = IAPManager.shared.products[indexPath.row]
        
        let cell = tblView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = iapData.productIdentifier
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productID = IAPManager.shared.products[indexPath.row].productIdentifier
        print(productID)
        IAPManager.shared.doPurchase(productId: productID)
    }
}


class IAPManager: NSObject {
    static let shared = IAPManager()
    
    let ids = ["com.test.removeAds", "com.test.diamonds"]
    var products = [SKProduct]()
    
    override init() {
        SwiftyStoreKit.completeTransactions { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                default:
                    break
                }
            }
        }
    }
    
    func fetchProuducts(completion: @escaping(() -> Void)) {
        SwiftyStoreKit.retrieveProductsInfo(Set(ids.map({$0}))) { results in
            for result in results.retrievedProducts {
                print("Product Info: \(result.productIdentifier)")
                self.products.append(result)
            }
//            completion()
        }
    }

    func doPurchase(productId: String) {
        SwiftyStoreKit.purchaseProduct(productId) { result in
            switch result {
            case .success:
                self.verifyReceipt()
                print("Purchase success")
                break
            case .error:
                print("Purchase error")
                break
            case .deferred:
                print("Purchase deferred")
                break
            }
        }
    }
    
    func verifyReceipt() {
        SwiftyStoreKit.verifyReceipt(using: AppleReceiptValidator(service: .sandbox, sharedSecret: ""), forceRefresh: true) { result in
            switch result {
            case .success(let receipt):
                let purchaseRes = SwiftyStoreKit.verifySubscriptions(productIds: Set(self.ids.map({$0})), inReceipt: receipt)
                switch purchaseRes {
                case .purchased(let date, let receiptItem):
                    print("Purchased \(receiptItem) \(date)")
                case .notPurchased:
                    print("Not Purchased")
                case .expired(let date, let receiptItem):
                    print("Expired \(receiptItem) \(date)")
                }
            case .error(let e):
                print("Error \(e.localizedDescription)")
            }
        }
    }
}
