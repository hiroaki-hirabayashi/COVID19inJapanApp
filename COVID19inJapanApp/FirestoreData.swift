//
//  FirestoreData.swift
//  COVID19inJapanApp
//
//  Created by 平林 宏淳 on 2021/07/26.
//

import Foundation
import MessageKit

// Firestoreから受け取ったデータを格納する構造体
//? オプショナルでnilを許容する
//日付、名前、メッセージ、UU
struct FirestoreData {
    var date: Date?
    var senderId: String?
    var text: String?
    var userName: String?
}

//MessageKitのプロトコル 送信者のIDと名前の構造体
struct Sender: SenderType {
    var senderId: String
    var displayName: String
}
//MessageKitのプロトコル
struct Message: MessageType {
    //送信するものがテキストなのか画像なのか動画なのか表すenum
    var kind: MessageKind
    //Senderプロトコルをメッセージ処理の際に代入する
    var sender: SenderType
    //メッセージの固有ID
    var messageId: String
    //日付情報
    var sentDate: Date
    
    //Message構造体に値を代入する(ユーザーから投げられてくる画像、動画、位置情報メッセージ等をMessageKitのプロトコルに渡す)
    private init(kind: MessageKind, sender: Sender, messageId: String, date: Date) {
        self.kind = kind
        self.sender = sender
        self.messageId = messageId
        self.sentDate = date
    }
    
    //MessageKindがTextの時(String型のメッセージを送信する時) private initを呼ぶ
    init(text: String, sender: Sender, messageId: String, date: Date) {
        self.init(kind: .text(text), sender: sender, messageId: messageId, date: date)
    }
    
    //MessageKindがNSAttributedString型の時(Stringより複雑な装飾)
    init(attributedText: NSAttributedString, sender: Sender, messageId: String, date: Date) {
        self.init(kind: .attributedText(attributedText), sender: sender, messageId: messageId, date: date)
    }
}
