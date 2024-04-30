//
//  CollectionVC.swift
//  DemoProject
//
//  Created by P21-0043 on 28/02/24.
//

import UIKit
import SDWebImage
import UIView_Shimmer
import SkeletonView

class CollectionVC: UIViewController{
    
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var arrData = [Post]()
    var arrData1 = [Post]()
    var index1 = IndexPath()

    var isLoading = true {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    let color1 = UIColor(hex: "#9F762E")
    let color2 = UIColor(hex: "#EABB6D")
    let color3 = UIColor(hex: "#9F7A2A")
    let color4 = UIColor(hex: "#3C9E88")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        fetchPosts(completion: {
            //            self.collectionView.stopSkeletonAnimation()
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
//                self.isLoading = false
                self.collectionView.reloadData()
            })
        })
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        applyGradient(toLabel: textLabel, colors: [color1, color2, color3])
    }
}


//MARK: - API Calling
extension CollectionVC {
    
    func fetchPosts(completion: @escaping(() -> Void)) {
        
        if let url = URL(string: "https://jsonplaceholder.typicode.com/photos") {
            let urlReq = URLRequest(url: url)
            URLSession.shared.dataTask(with: urlReq) { data, response, error in
                if error == nil {
                    do {
                        if let json = data {
                            let jsonData = try JSONDecoder().decode([Post].self, from: json)
                            self.arrData = jsonData
                            self.arrData1 = jsonData
                            completion()
                        }
                    } catch(let e) {
                        print("Catch block Error \(e.localizedDescription)")
                    }
                } else {
                    print("Error \(error?.localizedDescription ?? "--Error--")")
                }
            }.resume()
        }
    }
    
    func applyGradient(toLabel label: UILabel, colors: [UIColor]) {
            // Create a CAGradientLayer
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = label.bounds
            gradientLayer.colors = colors.map { $0.cgColor }
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5) // Left side
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            // Create a mask layer for the text
            let textMaskLayer = CATextLayer()
            textMaskLayer.string = label.text
            textMaskLayer.font = label.font
            textMaskLayer.fontSize = label.font.pointSize
            textMaskLayer.foregroundColor = UIColor.black.cgColor
            textMaskLayer.frame = label.bounds
            textMaskLayer.alignmentMode = .center
            
            // Set the mask of the gradient layer to be the text mask layer
            gradientLayer.mask = textMaskLayer

            // Add the gradient layer to the label's layer
            label.layer.addSublayer(gradientLayer)
        }
}

//MARK: - CollectionView Configuration
extension CollectionVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SkeletonCollectionViewDataSource{
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return "cellVC"
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrData1.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellVC", for: indexPath) as! cellVC

        cell.setTemplateWithSubviews(isLoading, animate: true, viewBackgroundColor: .systemCyan)

        let image = UIGraphicsImageRenderer(size: CGSize(width: 200.0, height: 200.0)).image { rendererContext in
            UIColor.white.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: CGSize(width: 200.0, height: 200.0)))
        }
        cell.cellImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        if let imgUrl = URL(string: self.arrData1[indexPath.row].url){
            DispatchQueue.global().async {
                cell.cellImage.sd_setImage(with: imgUrl, placeholderImage: image, completed: {_,_,_,_ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                            cell.setTemplateWithSubviews(false)
                    })
                })
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (self.view.frame.size.width / 3) - 20
        return CGSize(width: size, height: size)
    }
}

class cellVC: UICollectionViewCell, ShimmeringViewProtocol{
    
    @IBOutlet weak var cellImage: UIImageView!
    
    var shimmeringAnimatedItems: [UIView] {
        [
            cellImage
        ]
    }
    
    override func awakeFromNib() {
        cellImage.layer.cornerRadius = 15
    }
}

extension UIColor {
    public convenience init(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat((hexNumber & 0x0000ff) >> 0) / 255
                    a = 1.0
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        self.init(red: 0, green: 0, blue: 0, alpha: 1)
        return
    }
}
