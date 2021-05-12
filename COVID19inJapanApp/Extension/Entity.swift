//
//  Entity.swift
//  COVID19inJapanApp
//
//  Created by 平林 宏淳 on 2021/05/06.
//

import Foundation

struct CovidInfo: Codable {
    
    struct Total: Codable {
        var pcr: Int
        var positive: Int
        var hospitalize: Int
        var severe: Int
        var death: Int
        var discharge: Int
    }
}
