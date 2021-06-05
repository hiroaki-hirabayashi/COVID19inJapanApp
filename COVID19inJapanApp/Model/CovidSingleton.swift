//
//  CovidSingleton.swift
//  COVID19inJapanApp
//
//  Created by 平林 宏淳 on 2021/05/13.
//

import Foundation

class CovidSingleton {
    // クラスが初期化されるのを防ぐ シングルトン
    // AppDelegeteファイルへ→
    private init() {}
    static let shared = CovidSingleton()
    var prefecture: [CovidInfo.Prefecture] = []
    
}
