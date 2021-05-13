//
//  ChartViewController.swift
//  COVID19inJapanApp
//
//  Created by 平林 宏淳 on 2021/05/08.
//

import UIKit

final class ChartViewController: UIViewController {

    private let colors = Colors()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 60)
        gradientLayer.colors = [colors.bluePurple.cgColor,
                                colors.blue.cgColor,]
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 1)
        // レイヤー(CAGradientLayer)を載せる
        view.layer.insertSublayer(gradientLayer, at: 0)
//
//        let backButton = UIButton(type: .system)
//        backButton.frame = CGRect(x: 10, y: 30, width: 20, height: 20)
//        backButton.setImage(UIImage(named: ""), for: .normal)
//        backButton.tintColor = colors.white
//        backButton.titleLabel?.font = .systemFont(ofSize: 20)
//        backButton.addTarget(self, action: #selector(), for: .touchUpInside)
//
        let nextButton = UIButton(type: .system)
        nextButton.frame = CGRect(x: view.frame.size.width - 105, y: 25, width: 100, height: 30)
        nextButton.setTitle("円グラフ", for: .normal)
        nextButton.setTitleColor(colors.white, for: .normal)
        nextButton.titleLabel?.font = .systemFont(ofSize: 20)
        nextButton.addTarget(self, action: #selector(goCircle), for: .touchUpInside)
        view.addSubview(nextButton)
        
        let segment = UISegmentedControl(items: ["感染者数", "PCR数", "死者数"])
        segment.frame = CGRect(x: 10, y: 70, width: view.frame.size.width - 20, height: 20)
        segment.selectedSegmentTintColor = colors.blue
        segment.selectedSegmentIndex = 0
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: colors.bluePurple], for: .normal)
        segment.addTarget(self, action: #selector(segmentSwitchAction), for: .valueChanged)
        view.addSubview(segment)
        
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.frame = CGRect(x: 10, y: 100, width: view.frame.size.width - 20, height: 20)
        searchBar.placeholder = "都道県を入力"
        searchBar.showsCancelButton = true
        searchBar.tintColor = colors.blue
        view.addSubview(searchBar)
        
        view.backgroundColor = .systemGroupedBackground
        
    }
    
    @objc func goCircle() {
        print("goCircle")
    }
    
    @objc func segmentSwitchAction(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0:
                print("感染者数")
            case 1:
                print("PCR数")
            case 2:
                print("死者数")
            default:
                break
        }
    }
}

//MARK: UISearchBarDelegate
extension ChartViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("検索ボタン")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("キャンセルボタン")
    }
}
