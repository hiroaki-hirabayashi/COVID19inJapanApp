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
