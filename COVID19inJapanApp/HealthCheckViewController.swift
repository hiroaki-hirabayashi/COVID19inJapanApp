//
//  HealthCheckViewController.swift
//  COVID19inJapanApp
//
//  Created by 平林 宏淳 on 2021/05/10.
//

import UIKit
import FSCalendar

class HealthCheckViewController: UIViewController {
    
    let colors = Colors()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGroupedBackground
        let scrollView = UIScrollView()
        // scrollViewの位置とサイズ(画面上のどの範囲をscrollViewにするか)
        // スクロールする量ではない
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        // スクロールする量
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: 1000)
        view.addSubview(scrollView)
        
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
        
        
        let checkLabel = UILabel()
        checkLabel.text = "健康チェック"
        checkLabel.textColor = colors.white
        checkLabel.backgroundColor = colors.blue
        checkLabel.frame = CGRect(x: 0, y: 340, width: view.frame.size.width, height: 21)
        checkLabel.textAlignment = .center
        // checkLabelの中心を画面の中心に合わせる
        checkLabel.center.x = view.center.x
        scrollView.addSubview(checkLabel)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
