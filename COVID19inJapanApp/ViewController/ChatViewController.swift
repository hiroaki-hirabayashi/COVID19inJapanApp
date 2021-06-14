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

    override func viewDidLoad() {
        super.viewDidLoad()

        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.contentInset.top = 70
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
