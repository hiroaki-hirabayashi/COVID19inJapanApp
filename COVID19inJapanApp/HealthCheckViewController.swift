//
//  HealthCheckViewController.swift
//  COVID19inJapanApp
//
//  Created by 平林 宏淳 on 2021/05/10.
//

import UIKit
import FSCalendar

final class HealthCheckViewController: UIViewController {
    
    private let colors = Colors()
    let scrollView = UIScrollView()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpScrollView()
        setUpCalendar()


        
        
        
        let checkLabel = UILabel()
        checkLabel.text = "健康チェック"
        checkLabel.textColor = colors.white
        checkLabel.backgroundColor = colors.blue
        checkLabel.frame = CGRect(x: 0, y: 340, width: view.frame.size.width, height: 21)
        checkLabel.textAlignment = .center
        // checkLabelの中心を画面の中心に合わせる
        checkLabel.center.x = view.center.x
        scrollView.addSubview(checkLabel)
        
        let uiView1 = healthCheckView(y: 380)
        scrollView.addSubview(uiView1)
        healthCheckImage(parentView: uiView1, imageName: "check1")
        healthCheckLabel(parentView: uiView1, text: "37.5度以上の熱がある")
        healthCheckSwitch(parentView: uiView1, action: #selector(switchAction))
        let uiView2 = healthCheckView(y: 465)
        scrollView.addSubview(uiView2)
        healthCheckImage(parentView: uiView2, imageName: "check2")
        healthCheckLabel(parentView: uiView2, text: "喉の痛みがある")
        healthCheckSwitch(parentView: uiView2, action: #selector(switchAction))
        let uiView3 = healthCheckView(y: 550)
        scrollView.addSubview(uiView3)
        healthCheckImage(parentView: uiView3, imageName: "check3")
        healthCheckLabel(parentView: uiView3, text: "匂いを感じない")
        healthCheckSwitch(parentView: uiView3, action: #selector(switchAction))
        let uiView4 = healthCheckView(y: 635)
        scrollView.addSubview(uiView4)
        healthCheckImage(parentView: uiView4, imageName: "check4")
        healthCheckLabel(parentView: uiView4, text: "味が薄く感じる")
        healthCheckSwitch(parentView: uiView4, action: #selector(switchAction))
        let uiView5 = healthCheckView(y: 720)
        scrollView.addSubview(uiView5)
        healthCheckImage(parentView: uiView5, imageName: "check5")
        healthCheckLabel(parentView: uiView5, text: "だるさがひどい")
        healthCheckSwitch(parentView: uiView5, action: #selector(switchAction))
       
    }
   
    func setUpScrollView() {
        // scrollViewの位置とサイズ(画面上のどの範囲をscrollViewにするか)
        // スクロールする量ではない
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        // スクロールする量
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: 1000)
        view.addSubview(scrollView)

    }
    
    func setUpCalendar() {
        view.backgroundColor = .systemGroupedBackground
        
        let calendar = FSCalendar()
        calendar.frame = CGRect(x: 20, y: 10, width: view.frame.size.width - 40, height: 300)
        
        calendar.appearance.headerDateFormat = "YYYY年MM月"
        calendar.calendarWeekdayView.weekdayLabels[0].text = "日"
        calendar.calendarWeekdayView.weekdayLabels[1].text = "月"
        calendar.calendarWeekdayView.weekdayLabels[2].text = "火"
        calendar.calendarWeekdayView.weekdayLabels[3].text = "水"
        calendar.calendarWeekdayView.weekdayLabels[4].text = "木"
        calendar.calendarWeekdayView.weekdayLabels[5].text = "金"
        calendar.calendarWeekdayView.weekdayLabels[6].text = "土"
        scrollView.addSubview(calendar)

    }
    
    private func healthCheckView(y: CGFloat) -> UIView {
        let uiView = UIView()
        uiView.frame = CGRect(x: 20, y: y, width: view.frame.size.width - 40, height: 70)
        uiView.backgroundColor = .white
        uiView.layer.cornerRadius = 20
        // 影の色はcgColor型
        uiView.layer.shadowColor = UIColor.black.cgColor
        // 影の透明度
        uiView.layer.shadowOpacity = 0.3
        // 影のぼかしの強さ
        uiView.layer.shadowRadius = 4
        // 影の位置
        uiView.layer.shadowOffset = CGSize(width: 0, height: 2)
        return uiView
        
    }
    
    private func healthCheckLabel(parentView: UIView, text: String) {
        let label = UILabel()
        label.text = text
        label.frame = CGRect(x: 60, y: 15, width: 200, height: 40)
        parentView.addSubview(label)
    }
    
    private func healthCheckImage(parentView: UIView, imageName: String) {
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        imageView.frame = CGRect(x: 10, y: 12, width: 40, height: 40)
        parentView.addSubview(imageView)
        
    }
    // Selector型で呼び出す関数には@objc
    @objc func switchAction(sender: UISwitch) {
        if sender.isOn {
            print("ON")
        }  else {
            print("OFF")
        }
    }
    
    private func healthCheckSwitch(parentView: UIView, action: Selector) {
        let uiSwitch = UISwitch()
        uiSwitch.frame = CGRect(x: parentView.frame.size.width - 60, y: 20, width: 50, height: 30)
        uiSwitch.addTarget(self, action: action, for: .valueChanged)
        parentView.addSubview(uiSwitch)
        
    }

    
}
