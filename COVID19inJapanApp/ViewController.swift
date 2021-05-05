//
//  ViewController.swift
//  COVID19inJapanApp
//
//  Created by 平林 宏淳 on 2021/05/04.
//

import UIKit

class ViewController: UIViewController {
    
    let colors = Colors()

    override func viewDidLoad() {
        super.viewDidLoad()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height / 2 )
        // グラデーション色設定
        gradientLayer.colors = [colors.bluePurple.cgColor, colors.blue.cgColor]
        // 方向の始点
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        // 方向の終点
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        // レイヤーCAGradientLayerに乗せるのでaddSubViewではない
        view.layer.insertSublayer(gradientLayer, at: 0)
        /*
         CG = CoreGraphics UIColorとは別の色の型
         UIColor → CGColor型へ
         */
        
    }


}

