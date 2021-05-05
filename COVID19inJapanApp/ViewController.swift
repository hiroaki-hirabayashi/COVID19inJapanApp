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
        setUpGradation()
        setUpContent()
        
       
    }
    
    func setUpGradation() {
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
        
        /*
         contentViewの全heighが340
         画面中央に配置している為、view.frame.size.height / 2 + ~
         画面中央(view.frame.size.height / 2) + contentViewの半分の高さ170よりも20下にいく190、70下にいく240として、
         常にcontentViewの下にボタンが配置されるようにする
         */
        let height = view.frame.size.height / 2
        setUpButton("健康管理", size: labelSize, y: height + 190, color: colors.blue, parentView: view)
        setUpButton("県別状況", size: labelSize, y: height + 240, color: colors.blue, parentView: view)
       
    }
    // ラベル、文字
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
    
    func setUpButton(_ title: String, size: CGSize, y: CGFloat, color: UIColor, parentView: UIView) {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.frame.size = size
        // 中心X座標
        button.center.x = view.center.x
        // 文字列に特殊な加工 今回は文字同士の間隔
        let attributedTitle = NSAttributedString(string: title, attributes: [NSAttributedString.Key.kern : 8.0])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.frame.origin.y = y
        button.setTitleColor(color, for: .normal)
        parentView.addSubview(button)
        
        setUpImageButton("chat1", x: view.frame.size.width - 50).addTarget(self, action: #selector(chatAction), for: .touchDown)
        setUpImageButton("reload", x: 10).addTarget(self, action: #selector(reloadAction), for: .touchDown)
    }
    // チャットボタン returnで呼び出し元にButtonを返す
    func setUpImageButton(_ name: String, x: CGFloat) -> UIButton {
        let button = UIButton(type: .system)
        // UIImageインスタンス、ボタン状態
        button.setImage(UIImage(named: name), for: .normal)
        button.frame.size = CGSize(width: 30, height: 30)
        // ボタンのX,Y座標
        button.frame.origin = CGPoint(x: x, y: 25)
        button.tintColor = .white
        view.addSubview(button)
        return button
    }
    
    @objc func chatAction() {
        print("chatタップした")
    }
    
    @objc func reloadAction() {
        print("reloadタップした")

        loadView()
        viewDidLoad()
    }


}

