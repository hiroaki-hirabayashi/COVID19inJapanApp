//
//  HealthCheckViewController.swift
//  COVID19inJapanApp
//
//  Created by 平林 宏淳 on 2021/05/10.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic

final class HealthCheckViewController: UIViewController {
    
    private let colors = Colors()
    private let scrollView = UIScrollView()
    private let calendar = FSCalendar()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpScrollView()
        setUpCalendar()
        setUpHealthCheck()
        setUpResultButton()
        calendar.delegate = self

        
    }
    
    private func setUpScrollView() {
        
        // scrollViewの位置とサイズ(画面上のどの範囲をscrollViewにするか)
        // スクロールする量ではない
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        // スクロールする量
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: 950)
        view.addSubview(scrollView)
        
    }
    
    private func setUpCalendar() {
        view.backgroundColor = .systemGroupedBackground

        calendar.frame = CGRect(x: 20, y: 10, width: view.frame.size.width - 40, height: 300)
        calendar.locale = Locale(identifier: "Ja")
        calendar.appearance.headerDateFormat = "yyyy年MM月dd日"
        calendar.appearance.headerTitleColor = colors.bluePurple
        calendar.appearance.weekdayTextColor = colors.bluePurple
        scrollView.addSubview(calendar)

        
    }
    
    private func setUpHealthCheck() {
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
    
    private func healthCheckSwitch(parentView: UIView, action: Selector) {
        let uiSwitch = UISwitch()
        uiSwitch.frame = CGRect(x: parentView.frame.size.width - 60, y: 20, width: 50, height: 30)
        uiSwitch.addTarget(self, action: action, for: .valueChanged)
        parentView.addSubview(uiSwitch)
        
    }
    
    private func setUpResultButton() {
        let resultButton = UIButton()
        resultButton.frame = CGRect(x: 0, y: 820, width: 200, height: 40)
        //resultButtonの中心をscrollViewの中心に
        resultButton.center.x = scrollView.center.x
        resultButton.titleLabel?.font = .systemFont(ofSize: 20)
        resultButton.layer.cornerRadius = 5
        resultButton.setTitle("診断完了", for: .normal)
        resultButton.setTitleColor(colors.white, for: .normal)
        resultButton.backgroundColor = colors.blue
        // touchUpInside ボタンの内側 touchUpOutside ボタン外側 どちらで離しても発火する
        resultButton.addTarget(self, action: #selector(resultButtonAction), for: [.touchUpInside, .touchUpOutside])
        scrollView.addSubview(resultButton)
        
    }
    
    // Selector型で呼び出す関数には@objc
    @objc func switchAction(sender: UISwitch) {
        if sender.isOn {
            print("ON")
        }  else {
            print("OFF")
        }
    }
    
    @objc func resultButtonAction() {
        print("診断完了")
    }
    
    
    
}

extension HealthCheckViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        return .clear
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
        // カレンダーの各日付==今日の日付
        if dateFormatter(day: date) == dateFormatter(day: Date()) {
            return colors.bluePurple
        }
        return .clear
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderRadiusFor date: Date) -> CGFloat {
        return 0.5
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        if judgeWeekday(date) == 1 {
            return UIColor(red: 150/255, green: 30/255, blue: 0/255, alpha: 0.9)
        } else if judgeWeekday(date) == 7 {
            return UIColor(red: 0/255, green: 30/255, blue: 155/255, alpha: 0.9)
        }
        
        if judgeHoliday(date) {
            return UIColor(red: 150/255, green: 30/255, blue: 0/255, alpha: 0.9)
        }
        
        return colors.black
    }
    
    // Date型の日付情報
    func dateFormatter(day: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        return formatter.string(from: day)
//         yyyy-MM-dd
    }
    // 曜日判定(日曜日:1 土曜日:7) gregorian グレゴリオ暦(西暦)
    func judgeWeekday(_ date: Date) -> Int {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.component(.weekday, from: date)
    }
    // 祝日かどうか判定
    func judgeHoliday(_ date: Date) -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let holiday = CalculateCalendarLogic()
        let judgeHoliday = holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
        return judgeHoliday
        
    }
    

    
}

