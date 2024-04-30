//
//  ViewController.swift
//  DemoProject
//
//  Created by P21-0054 on 1/5/24.
//

import UIKit
import UIView_Shimmer
import SDWebImage

class Model {
    var title = String()
    var img = String()
    
    init(title: String, img: String) {
        self.title = title
        self.img = img
    }
}

struct Post: Codable {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}


class ViewController: UIViewController {
    
    @IBOutlet weak var colView: UICollectionView!
    @IBOutlet weak var colView1: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var arrData = [Post]()
    var arrData1 = [Post]()
    
    let placeHolderImg = UIImage(named: "bee")
    
    private var isLoading = true {
        didSet {
            colView1.isUserInteractionEnabled = !isLoading
            colView1.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        colView.isPagingEnabled = true
//        pageControl.numberOfPages = arrData.count
        view.backgroundColor = .systemBackground
        
        isLoading = true
        
        self.fetchPosts {
            DispatchQueue.main.async {
                self.colView.reloadData()
                self.colView1.reloadData()
                self.colView1.performBatchUpdates(nil, completion: nil)
            }
        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.view.setTemplateWithSubviews(false)
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
        }
    }
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        self.view.setTemplateWithSubviews(true, viewBackgroundColor: .systemBackground)
//    }
}

extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return collectionView == colView ? arrData.count : arrData1.count
        return arrData1.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colView.dequeueReusableCell(withReuseIdentifier: "CVCell", for: indexPath) as! CVCell
        //        if collectionView == colView {
        //            if let imgUrl = URL(string: arrData[indexPath.row].url) {
        //                cell.imgView.sd_setImage(with: imgUrl) { img, e, _, url in
        //                    cell.imgView.image = img
        //                }
        //            }
        //            return cell
        //        } else {
        //            cell.imgView.startAnimating()
        cell.setTemplateWithSubviews(isLoading, animate: true, viewBackgroundColor: .systemGray5)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            cell.setTemplateWithSubviews(false)
        })
        
        if let imgUrl = URL(string: arrData1[indexPath.row].url) {
            //                    cell.imgView.sd_setImage(with: imgUrl, placeholderImage: self.placeHolderImg)
            cell.imgView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgView.sd_setImage(with: imgUrl, placeholderImage: self.placeHolderImg)
            //                cell.setTemplateWithSubviews(false)
            
            //                cell.imgView.sd_setImage(with: imgUrl) { img, e, _, url in
            //                    cell.imgView.stopAnimating()
            //                    cell.imgView.image = img != nil ? img : self.placeHolderImg
            //                }
        }

        print("Title \(arrData1[indexPath.row].title)")
        cell.title.text = arrData1[indexPath.row].title
        return cell
        //        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        let cell = colView.dequeueReusableCell(withReuseIdentifier: "CVCell", for: indexPath) as! CVCell
//        cell.setTemplateWithSubviews(true, viewBackgroundColor: .systemBlue)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if collectionView == colView {
//            let size = (self.view.frame.size.width) - 60
//            return CGSize(width: size, height: colView.frame.size.height)
//        } else {
            let size = (self.view.frame.size.width / 3) - 20
            return CGSize(width: size, height: 150)
//        }
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
//        pageControl.currentPage = Int(pageIndex)
//    }
}

//MARK: - API Calling
extension ViewController {
    
    func fetchPosts(completion: @escaping(() -> Void)) {
//        self.showShimmer()
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
}


class CVCell: UICollectionViewCell, ShimmeringViewProtocol{
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    var shimmeringAnimatedItems: [UIView] {
        [
            imgView,
            title
        ]
    }
    
    override func awakeFromNib() {
        imgView.layer.cornerRadius = 10
    }
}

extension UILabel: ShimmeringViewProtocol { }
extension UIImageView: ShimmeringViewProtocol { }
