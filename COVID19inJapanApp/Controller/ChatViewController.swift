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

class ChatViewController: MessagesViewController, MessagesDataSource, MessageCellDelegate, MessagesLayoutDelegate, MessagesDisplayDelegate {
    
    private let colors = Colors()
    //端末の固有ID
    private var userId = ""
    //FirestoreDate型の空の配列
    private var firestoreData: [FirestoreData] = []
    //メッセージデータを保存するための変数 Message構造体型
    private var messages: [Message] = []
    
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

        messagesCollectionView.messagesDataSource = self
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
        
        // if letで取得できた時に端末の固有IDをuserIdに代入する
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            userId = uuid
            print("ここ!!!!!!!!!!!!!!!!uuId\(userId)")
        }
        
        
        
    }
    
    @objc func backButtonAction() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //下のfuncと2つで送信者が自分か自分以外かを判定する 自分
    func currentSender() -> SenderType {
        return Sender(senderId: userId, displayName: "MyName")
    }
    //自分以外
    func otherSender() -> SenderType {
        return Sender(senderId: "-1", displayName: "OtherName")
    }
    
    //メッセージ表示関数
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    //メッセージの数を返す
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }

    //forestoreData型からMessage型に変換する関数
    //forestoreDataのtext,date,senderIdを受け取る
    func createMessage(text: String, date: Date, _ senderId: String) -> Message {
        //String型 → NSAttributedString型に変換 引数attributesで装飾している(文字サイズ15、文字色を白)
        let attrubutedText = NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.white])
        //メッセージデータのsenderIdと端末の固有IDを代入しているuserIdが等しいか true false
        let sender = (senderId == userId) ? currentSender() : otherSender()
        //Messageインスタンスを生成 returnする
        return Message(attributedText: attrubutedText, sender: sender as! Sender, messageId: UUID().uuidString, date: date)
    }
    
    //func createMessageを使って変換する
    func getMessage() -> [Message] {
        var messageArray: [Message] = []
        //firestoreDataの数だけループ回す
        for i in 0 ..< firestoreData.count {
            //messageArrayにcreateMessageを使ってMessage型に変換したデータを格納していく
            messageArray.append(createMessage(text: firestoreData[i].text!, date: firestoreData[i].date!, firestoreData[i].senderId!))
        }
        //ループ処理が終わり、データが格納できたらmessageArrayをreturnする
        return messageArray
    }
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    
}
