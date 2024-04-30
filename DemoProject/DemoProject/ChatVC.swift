//
//  ChatVC.swift
//  EncryptedAPIDemo
//
//  Created by P21-0054 on 30/08/22.
//

import UIKit
//import IQKeyboardManagerSwift
import Photos
import PhotosUI

class ChatVC: UIViewController {

    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var viewDrawer: UIView!
    @IBOutlet weak var txtFieldBottom: NSLayoutConstraint!
    
    
    var chatArr: [ChatModel]!
    let imgArr = ["1", "2", "3", "4", "1", "2", "3", "4", "1", "2", "3", "4"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatArr = [
            ChatModel(imgUser: "bee", media: "2", username: "Vishal Kumar", msg: "Hello", date: "12:02pm", isLoggedInUser: false, type: 0),
            ChatModel(imgUser: "bee", media: "4", username: "Abhishek Sharma", msg: "Hello", date: "12:02pm", isLoggedInUser: true, type: 1),
            ChatModel(imgUser: "bee", media: "1", username: "Abhishek Sharma", msg: "How are you", date: "12:02pm", isLoggedInUser: true, type: 0),
            ChatModel(imgUser: "bee", media: "2", username: "Vishal Kumar", msg: "I am fine, what about you?", date: "12:02pm", isLoggedInUser: false, type: 1),
            ChatModel(imgUser: "bee", media: "1", username: "Vishal Kumar", msg: "Latin professor at Hampden-Sydney College", date: "12:02pm", isLoggedInUser: false, type: 0),
            ChatModel(imgUser: "bee", media: "4", username: "Abhishek Sharma", msg: "Latin professor at Hampden-Sydney College", date: "12:02pm", isLoggedInUser: true, type: 1),
            ChatModel(imgUser: "bee", media: "3", username: "Vishal Kumar", msg: "Latin professor at Hampden-Sydney College", date: "12:02pm", isLoggedInUser: false, type: 0),
            ChatModel(imgUser: "bee", media: "2", username: "Vishal Kumar", msg: "Latin professor at Hampden-Sydney College", date: "12:02pm", isLoggedInUser: false, type: 1),
            ChatModel(imgUser: "bee", media: "1", username: "Abhishek Sharma", msg: "Latin professor at Hampden-Sydney College", date: "12:02pm", isLoggedInUser: true, type: 0),
            ChatModel(imgUser: "bee", media: "3", username: "Vishal Kumar", msg: "Latin professor at Hampden-Sydney College", date: "12:02pm", isLoggedInUser: false, type: 1),
            ChatModel(imgUser: "bee", media: "1", username: "Abhishek Sharma", msg: "Latin professor at Hampden-Sydney College", date: "12:02pm", isLoggedInUser: true, type: 0),
            ChatModel(imgUser: "bee", media: "4", username: "Vishal Kumar", msg: "Latin professor at Hampden-Sydney College", date: "12:02pm", isLoggedInUser: false, type: 1),
        ]
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.chatArr.count-1, section: 0)
            self.tblView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    @IBAction func btnMenuTapped(_ sender: Any) {}
    
    @IBAction func btnShowHideTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func btnCloseTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}

extension ChatVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        tblView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 320, right: 0)
        txtFieldBottom.constant = 300
//        tblView.reloadData()
        scrollToBottom()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        tblView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        txtFieldBottom.constant = 25
//        tblView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}



extension ChatVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatData = chatArr[indexPath.row]
        if chatData.type == 0 {
            if chatData.isLoggedInUser {
                let cell = tableView.dequeueReusableCell(withIdentifier: "fromCell") as! ChatCell
                cell.viewMain.backgroundColor = .systemYellow.withAlphaComponent(0.2)
                cell.lblMsg.text = chatData.msg
                cell.imgView.image = UIImage(named: chatData.imgUser)
                cell.lblName.text = chatData.username
                cell.lblDate.text = chatData.date
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "toCell") as! ChatCell
                cell.viewMain.backgroundColor = .systemCyan.withAlphaComponent(0.2)
                cell.lblMsg.text = chatData.msg
                cell.imgView.image = UIImage(named: chatData.imgUser)
                cell.lblName.text = chatData.username
                cell.lblDate.text = chatData.date
                return cell
            }
        } else {
            if chatData.isLoggedInUser {
                let fromMediaCell = tableView.dequeueReusableCell(withIdentifier: "fromMediaCell") as! ChatMediaCell
                fromMediaCell.viewMain.backgroundColor = .systemYellow.withAlphaComponent(0.2)
                fromMediaCell.img.image = UIImage(named: chatData.imgUser)
                fromMediaCell.imgUser.image = UIImage(named: chatData.media)
                fromMediaCell.lblName.text = chatData.username
                fromMediaCell.lblDate.text = chatData.date
                return fromMediaCell
            } else {
                let toMediaCell = tableView.dequeueReusableCell(withIdentifier: "toMediaCell") as! ChatMediaCell
                toMediaCell.viewMain.backgroundColor = .systemCyan.withAlphaComponent(0.2)
                toMediaCell.img.image = UIImage(named: chatData.imgUser)
                toMediaCell.imgUser.image = UIImage(named: chatData.media)
                toMediaCell.lblName.text = chatData.username
                toMediaCell.lblDate.text = chatData.date
                return toMediaCell
            }
        }
    }
}


class ChatCell: UITableViewCell {
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    override func awakeFromNib() {
        self.viewMain.layer.cornerRadius = 10
        self.imgView.layer.cornerRadius = self.imgView.frame.size.height / 2
    }
}

class ChatMediaCell: UITableViewCell {
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    override func awakeFromNib() {
        self.viewMain.layer.cornerRadius = 10
        self.imgUser.layer.cornerRadius = self.imgUser.frame.size.height / 2
//        self.img.layer.cornerRadius = 8
    }
}


struct ChatModel {
    var imgUser = String()
    var media = String()
    var username = String()
    var msg = String()
    var date = String()
    var isLoggedInUser: Bool!
    var type = Int()
}


class ReplyTableViewCell: UITableViewCell {
    // Add necessary UI elements for the reply, such as labels, image views, etc.
    // Customize the appearance of the cell based on your requirements.
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Perform any additional configuration for the cell
        
        // Example: Customize the cell's appearance
        backgroundColor = .white
        
        // Example: Add a label to display the reply text
        let replyLabel = UILabel()
        replyLabel.translatesAutoresizingMaskIntoConstraints = false
        replyLabel.numberOfLines = 0
        contentView.addSubview(replyLabel)
        
        // Example: Set up constraints for the reply label
        NSLayoutConstraint.activate([
            replyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            replyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            replyLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            replyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
