//
//  ViewController.swift
//  COVID19inJapanApp
//
//  Created by 平林 宏淳 on 2021/05/04.
//

import Foundation
import UIKit

final class TopViewController: UIViewController {
    
    private let colors = Colors()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpGradation()
        setUpContent()
    }
    
    private func setUpGradation() {
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
    
    private func setUpContent() {
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
        setUpButton("健康管理", size: labelSize, y: height + 190, color: colors.blue, parentView: view).addTarget(self, action: #selector(goHealthCheck), for: .touchDown)
        setUpButton("県別状況", size: labelSize, y: height + 240, color: colors.blue, parentView: view).addTarget(self, action: #selector(goChart), for: .touchDown)
        
        let imageView = UIImageView()
        let image = UIImage(named: "virus")
        imageView.image = image
        // UIviewインスタンスの位置、サイズ設定 最初は画面外に配置する
        imageView.frame = CGRect(x: view.frame.size.width, y: -65, width: 50, height: 50)
        contentView.addSubview(imageView)
        // withDuration→animation時間 delay→タイムラグ時間 options→アニメーションスタイル animations→変化させたい値を表現する領域
        UIView.animate(withDuration: 1.5, delay: 0.5, options: [.curveEaseIn], animations: {
            // 上記の内容で画面幅-100の位置に移動
            imageView.frame = CGRect(x: self.view.frame.size.width - 100, y: -65, width: 50, height: 50)
            // サイズ、位置変化 画像を−90度回転させる
            imageView.transform = CGAffineTransform(rotationAngle: -90)
        }, completion: nil)
        
        setUpAPI(parentView: contentView)
        
        //        setUpAPILabel(discharge, size: labelSize, centerX: rightX, y: 260, font: labelFont, color: labelColor, parentView)
        
    }
    
    // 表示する項目のラベル、文字
    private func setUpLabel(_ text: String, size: CGSize, centerX: CGFloat, y: CGFloat, font: UIFont, color: UIColor, _ parentView: UIView) {
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
    
    // データを表示するためのラベルを配置する
    private func setUpAPILabel(_ label: UILabel, size: CGSize, centerX: CGFloat, y: CGFloat, font: UIFont, color: UIColor, _ parentView: UIView) {
        label.frame.size = size
        label.center.x = centerX
        label.frame.origin.y = y
        label.font = font
        label.textColor = color
        parentView.addSubview(label)
    }
    
    private func setUpAPI(parentView: UIView) {
        let pcr = UILabel()
        let positive = UILabel()
        let hospitalize = UILabel()
        let severe = UILabel()
        let death = UILabel()
        let discharge = UILabel()
        // サイズ、x座標(横)、font, color
        let size = CGSize(width: 200, height: 40)
        let leftX = view.frame.size.width * 0.38
        let rightX = view.frame.size.width * 0.85
        let font = UIFont.systemFont(ofSize: 35, weight: .heavy)
        let color = colors.blue
        // PCR
        setUpAPILabel(pcr, size: size, centerX: leftX - 20, y: 60, font: font, color: color, parentView)
        // 感染者数
        setUpAPILabel(positive, size: size, centerX: rightX, y: 60
                      , font: font, color: color, parentView)
        // 入院者数
        setUpAPILabel(hospitalize, size: size, centerX: leftX, y: 160, font: font, color: color, parentView)
        // 重傷者数
        setUpAPILabel(severe, size: size, centerX: rightX, y: 160, font: font, color: color, parentView)
        // 死者数
        setUpAPILabel(death, size: size, centerX: leftX, y: 260, font: font, color: color, parentView)
        // 退院者数
        setUpAPILabel(discharge, size: size, centerX: rightX, y: 260, font: font, color: color, parentView)
        
        /*
         APIリクエストを呼び出す ↓受け取ったデータを格納する
         クロージャの中は自動的にメインスレッドではなくなってしまうため、DispatchQueue.main.async{}でメインスレッドにしてあげる
         resultでCovidInfo.Total型のデータを受け取っているので、Entityファイルに定義した通りにCovidInfo.Total.変数としてアクセス出来る
         */
        Covid19API.getTotal { (result: CovidInfo.Total) -> Void in DispatchQueue.main.async {
            pcr.text = "\(result.pcr)"
            positive.text = "\(result.positive)"
            hospitalize.text = "\(result.hospitalize)"
            severe.text = "\(result.severe)"
            death.text = "\(result.death)"
            discharge.text = "\(result.discharge)"
        }
        
        }
    }
    
    private func setUpButton(_ title: String, size: CGSize, y: CGFloat, color: UIColor, parentView: UIView) -> UIButton {
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
        
        return button
    }
    
    // チャットボタン returnで呼び出し元にButtonを返す
    private func setUpImageButton(_ name: String, x: CGFloat) -> UIButton {
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
        let storyboard = UIStoryboard(name: "ChatView", bundle: nil)
        let chatViewController = storyboard.instantiateViewController(withIdentifier: "goHealthCheck") as! ChatViewController
        self.navigationController?.pushViewController(chatViewController, animated: true)

    }
    
    @objc func reloadAction() {
        print("reloadタップした")
        
        loadView()
        viewDidLoad()
    }
    
    @objc func goHealthCheck() {
        let storyboard = UIStoryboard(name: "HealthCheck", bundle: nil)
        let healthCheckViewController = storyboard.instantiateViewController(withIdentifier: "goHealthCheck") as! HealthCheckViewController
        self.navigationController?.pushViewController(healthCheckViewController, animated: true)
    }
    
    @objc func goChart() {
        let storyboard = UIStoryboard(name: "ChartView", bundle: nil)
        let chartViewController = storyboard.instantiateViewController(withIdentifier: "goChart") as! ChartViewController
        self.navigationController?.pushViewController(chartViewController, animated: true)
    }
    
    
}
