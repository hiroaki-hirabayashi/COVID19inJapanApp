//
//  WebAPI.swift
//  COVID19inJapanApp
//
//  Created by 平林 宏淳 on 2021/05/06.
//

import Foundation
import UIKit

struct Covid19API {
    // static インスタンス化しなくても外部から呼び出せる。()不要 インスタンス化はメモリ消費する メモリ節約になる?
    // @escapingをつけるとcompletionのデータを関数外でも保持出来るようになる。逆にコレをつけないとデータが破棄される
    static func getTotal(completion: @escaping (CovidInfo.Total) -> Void) {
        let url = URL(string: "https://covid19-japan-web-api.now.sh/api//v1/total")
        let request = URLRequest(url: url!)
        // リクエストして返っててきたdata, response, errorを()内で受け取り、inから先で処理をする
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            // errorが!= nil nil(何もない)じゃない時、エラーが有る場合の条件式
            if error != nil {
                print("error:\(error?.localizedDescription)")
            }
            // オプショナルの値が存在する時(nilじゃない時)のみ定数に代入する
            if let data = data {
                // 受け取ったデータを使いやすいデータ形式に変換(decode)する。クロージャ内のdataをCovidInfoのTotal型に変換
                let result = try! JSONDecoder().decode(CovidInfo.Total.self, from: data)
                // 受け取ったデータを引数(completion)に渡し、呼び出し元の引数(CovidInfo.Total)で使用する
                completion(result)
            }
        }.resume()
    }
}
