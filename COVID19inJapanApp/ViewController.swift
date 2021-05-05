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
        seyUpGradation()
        setUpContent()
       
    }
    
    func seyUpGradation() {
        // 画面上部
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
    
    func setUpContent() {
        // 画面中央部
        let contentView = UIView()
        // size
        contentView.frame.size = CGSize(width: view.frame.size.width, height: 340)
        // 中心配置
        contentView.center = CGPoint(x: view.center.x, y: view.center.y)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 30
        // 影の方向 width右 height下
        contentView.layer.shadowOffset = CGSize(width: 2, height: 2)
        // 影の色 CGcolor型に
        contentView.layer.shadowColor = UIColor.gray.cgColor
        // 影の透明度
        contentView.layer.shadowOpacity = 0.5
        view.addSubview(contentView)
        // 画面下部の色
        view.backgroundColor = .systemGray6
    }


}

