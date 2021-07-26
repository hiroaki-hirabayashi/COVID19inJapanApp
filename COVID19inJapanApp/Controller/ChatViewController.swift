//
//  ChatViewController.swift
//  COVID19inJapanApp
//
//  Created by 平林 宏淳 on 2021/06/14.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import FirebaseFirestore

class ChatViewController: MessagesViewController, /*MessagesDataSource*/ MessageCellDelegate, MessagesLayoutDelegate, MessagesDisplayDelegate {
    
    private let colors = Colors()
    private var userId = ""
    //FirestoreDate型の空の配列
    private var firestoreData: [FirestoreData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Firestore.firestore().collection("Message").document().setData([
            "date" : Date(),
            "senderId" : "testId",
            "text" : "testText",
            "userName" : "testName"
        ])
        //Messageコレクションのドキュメントを全取得 データがdocument, エラーがerrorに
        Firestore.firestore().collection("Message").getDocuments { (document, error) in
            //エラーが空ではない時(つまりエラーがある時)エラー分を出力 #line → 問題がある行を出力する
            if error != nil {
                print("ChatViewController: Line(\(#line)): error:\(error)")
            } else {
                if let document = document {
                    for i in 0 ..< document.count {
                        print((document.documents[i].get("date") as! Timestamp).dateValue())
                        print(document.documents[i].get("senderId") as! String)
                        print(document.documents[i].get("text") as! String)
                        print(document.documents[i].get("userName") as! String)
                        
                        var storeData = FirestoreData()
                        storeData.date = (document.documents[i].get("date") as! Timestamp).dateValue()
                        storeData.senderId = document.documents[i].get("senderId") as? String
                        storeData.text = document.documents[i].get("text") as? String
                        storeData.userName = document.documents[i].get("userName") as? String
                        self.firestoreData.append(storeData)
                        print(self.firestoreData)
                    }
                }
            }
        }

        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.contentInset.top = 70
    
        // ヘッダーの枠組み
        let uiView = UIView()
        uiView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 70)
        view.addSubview(uiView)
        // ヘッダーのタイトル
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = colors.white
        label.text = "Docter"
        label.frame = CGRect(x: 0, y: 20, width: 100, height: 40)
        label.center.x = view.center.x
        label.textAlignment = .center
        uiView.addSubview(label)
        // ヘッダー部分戻るボタン
        let backButton = UIButton(type: .system)
        backButton.frame = CGRect(x: 10, y: 30, width: 20, height: 20)
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.tintColor = colors.white
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        uiView.addSubview(backButton)
        // ヘッダー部分グラデーション
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 70)
        gradientLayer.colors = [colors.bluePurple.cgColor, colors.blue.cgColor,]
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 1)
        uiView.layer.insertSublayer(gradientLayer, at: 0)
        
        // if letで取得できた時にuserIdに代入する
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            userId = uuid
            print("ここ!!!!!!!!!!!!!!!!uuId\(userId)")
        }
        
        
        
    }
    
    @objc func backButtonAction() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
//    func currentSender() -> SenderType {
//        <#code#>
//    }
//
//    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
//        <#code#>
//    }
//
//    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
//        <#code#>
//    }
//

}

extension ChatViewController: InputBarAccessoryViewDelegate {
    
}
