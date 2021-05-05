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
        
        // 表示するラベルの設定
        let labelFont = UIFont.systemFont(ofSize: 15, weight: .heavy)
        let labelSize = CGSize(width: 150, height: 50)
        let labelColor = colors.bluePurple
        let leftX = view.frame.size.width * 0.33
        let rightX = view.frame.size.width * 0.80
        setUpLabel("COVID19 in Japan", size: CGSize(width: 300, height: 35), centerX: view.center.x - 20, y: -60, font: .systemFont(ofSize: 25, weight: .heavy), color: .white, contentView)
        setUpLabel("PCR数", size: labelSize, centerX: leftX, y: 20, font: labelFont, color: labelColor, contentView)
        setUpLabel("感染者数", size: labelSize, centerX: rightX, y: 20, font: labelFont, color: labelColor, contentView)
        setUpLabel("入院者数", size: labelSize, centerX: leftX, y: 120, font: labelFont, color: labelColor, contentView)
        setUpLabel("重傷者数", size: labelSize, centerX: rightX, y: 120, font: labelFont, color: labelColor, contentView)
        setUpLabel("死者数", size: labelSize, centerX: leftX, y: 220, font: labelFont, color: labelColor, contentView)
        setUpLabel("退院者数", size: labelSize, centerX: rightX, y: 220, font: labelFont, color: labelColor, contentView)
       
    }
    
    func setUpLabel(_ text: String, size: CGSize, centerX: CGFloat, y: CGFloat, font: UIFont, color: UIColor, _ parentView: UIView) {
        let label = UILabel()
        // 表示するテキスト
        label.text = text
        // テキストサイズ
        label.frame.size = size
        // 中心X座標
        label.center.x = centerX
        // 起点Y座標
        label.frame.origin.y = y
        // フォント
        label.font = font
        // 色
        label.textColor = color
        parentView.addSubview(label)
    }


}

