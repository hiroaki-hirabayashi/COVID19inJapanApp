//
//  ChartViewController.swift
//  COVID19inJapanApp
//
//  Created by 平林 宏淳 on 2021/05/08.
//

import UIKit
import Charts

final class ChartViewController: UIViewController {

    private let colors = Colors()
    private let uiView = UIView()
    
    // 都道府県
    var prefecturs = UILabel()
    // PCR
    var pcr = UILabel()
    var pcrCount = UILabel()
    // 感染者
    var cases = UILabel()
    var casesCount = UILabel()
    // 死者数
    var deaths = UILabel()
    var deathsCount = UILabel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradientLayer()
        setUpNextButton()
        setaUpSegementControl()
        setUpSearchBar()
        setUpUIView()
        // 真ん中に表示するものはx=1、左側はx=0.39、右側はx=1.61 3等分
        bottomLabel(uiView, prefecturs, 1, 10, text: "都道府県", size: 30, weight: .ultraLight, color: colors.black)
        bottomLabel(uiView, pcr, 0.39, 50, text: "PCR数", size: 15, weight: .bold, color: colors.bluePurple)
        bottomLabel(uiView, pcrCount, 0.39, 85, text: "0", size: 30, weight: .bold, color: colors.blue)
        bottomLabel(uiView, cases, 1, 50, text: "感染者数", size: 15, weight: .bold, color: colors.bluePurple)
        bottomLabel(uiView, casesCount, 1,  85, text: "0", size: 30, weight: .bold, color: colors.blue)
        bottomLabel(uiView, deaths, 1.61, 50, text: "死者数", size: 15, weight: .bold, color: colors.bluePurple)
        bottomLabel(uiView, deathsCount, 1.61, 85, text: "0", size: 30, weight: .bold, color: colors.blue)
        view.backgroundColor = .systemGroupedBackground
        
        for i in 0 ..< CovidSingleton.shared.prefecture.count {
            if CovidSingleton.shared.prefecture[i].name_ja == "東京" {
                prefecturs.text = CovidSingleton.shared.prefecture[i].name_ja
                pcrCount.text = "\(CovidSingleton.shared.prefecture[i].pcr)"
                casesCount.text = "\(CovidSingleton.shared.prefecture[i].cases)"
                deathsCount.text = "\(CovidSingleton.shared.prefecture[i].deaths)"
                
            }
        }

    }
    private func gradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 60)
        gradientLayer.colors = [colors.bluePurple.cgColor,
                                colors.blue.cgColor,]
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 1)
        // レイヤー(CAGradientLayer)を載せる
        view.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    private func setUpNextButton() {
        let nextButton = UIButton(type: .system)
        nextButton.frame = CGRect(x: view.frame.size.width - 105, y: 25, width: 100, height: 30)
        nextButton.setTitle("円グラフ", for: .normal)
        nextButton.setTitleColor(colors.white, for: .normal)
        nextButton.titleLabel?.font = .systemFont(ofSize: 20)
        nextButton.addTarget(self, action: #selector(goCircle), for: .touchUpInside)
        view.addSubview(nextButton)
    
//        let backButton = UIButton(type: .system)
//        backButton.frame = CGRect(x: 10, y: 30, width: 20, height: 20)
//        backButton.setImage(UIImage(named: ""), for: .normal)
//        backButton.tintColor = colors.white
//        backButton.titleLabel?.font = .systemFont(ofSize: 20)
//        backButton.addTarget(self, action: #selector(), for: .touchUpInside)
    }
    
    private func setaUpSegementControl() {
        let segment = UISegmentedControl(items: ["感染者数", "PCR数", "死者数"])
        segment.frame = CGRect(x: 10, y: 70, width: view.frame.size.width - 20, height: 20)
        segment.selectedSegmentTintColor = colors.blue
        segment.selectedSegmentIndex = 0
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: colors.bluePurple], for: .normal)
        segment.addTarget(self, action: #selector(segmentSwitchAction), for: .valueChanged)
        view.addSubview(segment)
    }
    
    private func setUpSearchBar() {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.frame = CGRect(x: 10, y: 100, width: view.frame.size.width - 20, height: 20)
        searchBar.placeholder = "都道県を入力"
        searchBar.showsCancelButton = true
        searchBar.tintColor = colors.blue
        view.addSubview(searchBar)
    }
    
    private func setUpUIView() {
        uiView.frame = CGRect(x: 10, y: 400, width: view.frame.size.width - 20, height: 167)
        uiView.backgroundColor = .white
        uiView.layer.cornerRadius = 10
        uiView.layer.shadowColor = colors.black.cgColor
        uiView.layer.shadowOffset = CGSize(width: 0, height: 2)
        uiView.layer.shadowOpacity = 0.4
        uiView.layer.shadowRadius = 10
        view.addSubview(uiView)
    }
    
    private func bottomLabel(_ parentView: UIView, _ label: UILabel, _ x: CGFloat, _ y: CGFloat, text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) {
        view.backgroundColor = .systemGroupedBackground
        // ここでラベルを生成すると参照出来ない
        //        let label = UILabel()
        label.text = text
        label.textColor = color
        label.textAlignment = .center
        // 文字数が多くなってしまいサイズオーバーした時、自動的にサイズを小さくする
        label.adjustsFontSizeToFitWidth = true
        label.font = .systemFont(ofSize: size, weight: weight)
        label.frame = CGRect(x: 0, y: y, width: parentView.frame.size.width / 3.5, height: 50)
        label.center.x = view.center.x * x - 10
        parentView.addSubview(label)
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
