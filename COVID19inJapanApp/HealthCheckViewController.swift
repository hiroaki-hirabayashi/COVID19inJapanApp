//
//  HealthCheckViewController.swift
//  COVID19inJapanApp
//
//  Created by 平林 宏淳 on 2021/05/10.
//

import UIKit

class HealthCheckViewController: UIViewController {

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
