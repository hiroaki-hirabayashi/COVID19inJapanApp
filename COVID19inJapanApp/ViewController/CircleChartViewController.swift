//
//  ChartViewController.swift
//  COVID19inJapanApp
//
//  Created by 平林 宏淳 on 2021/05/13.
//

import UIKit
import Charts

final class CircleChartViewController: UIViewController {

    private let colors = Colors()
    private let uiView = UIView()
    // 都道府県
    private var prefecturs = UILabel()
    // PCR
    private var pcr = UILabel()
    private var pcrCount = UILabel()
    // 感染者
    private var cases = UILabel()
    private var casesCount = UILabel()
    // 死者数
    private var deaths = UILabel()
    private var deathsCount = UILabel()
    // 各都道府県データ
    private var prefectureArray: [CovidInfo.Prefecture] = []

    private var segment = UISegmentedControl()
    private var pattern = "cases"
    private let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        gradientLayer()
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
        displayDataSetUiVeiw()
        displayDataSetChartView()
        prefectureArrayDataSort()

            
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
    

    private func setaUpSegementControl() {
        segment = UISegmentedControl(items: ["感染者", "PCR数", "死者数"])
        segment.frame = CGRect(x: 10, y: 70, width: view.frame.size.width - 20, height: 20)
        segment.selectedSegmentTintColor = colors.blue
        segment.selectedSegmentIndex = 0
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: colors.bluePurple], for: .normal)
        segment.addTarget(self, action: #selector(segmentSwitchAction), for: .valueChanged)
        view.addSubview(segment)
    }
    
    private func setUpSearchBar() {
//        searchBar.delegate = self
        searchBar.frame = CGRect(x: 10, y: 100, width: view.frame.size.width - 20, height: 20)
        searchBar.placeholder = "都道県を入力"
        searchBar.showsCancelButton = true
        searchBar.tintColor = colors.blue
        view.addSubview(searchBar)
    }
    
    private func setUpUIView() {
        uiView.frame = CGRect(x: 10, y: 480, width: view.frame.size.width - 20, height: 167)
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
        //  ✗ → let label = UILabel()
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
    
    private func displayDataSetUiVeiw() {
        for i in 0 ..< CovidSingleton.shared.prefecture.count {
            if CovidSingleton.shared.prefecture[i].name_ja == "東京" {
                prefecturs.text = CovidSingleton.shared.prefecture[i].name_ja
                pcrCount.text = "\(CovidSingleton.shared.prefecture[i].pcr)"
                casesCount.text = "\(CovidSingleton.shared.prefecture[i].cases)"
                deathsCount.text = "\(CovidSingleton.shared.prefecture[i].deaths)"
            }
        }
    }
    
    private func prefectureArrayDataSort() {
        prefectureArray = CovidSingleton.shared.prefecture
        // グラフのソート処理
        prefectureArray.sort(by: {
            a,b -> Bool in
            // pcrの値をソート
            if pattern == "pcr" {
                return a.pcr > b.pcr
                //deathsをソート
            } else if pattern == "deaths" {
                return a.deaths > b.deaths
                // それ以外はcasesをソート
            } else {
                return a.cases > b.cases
            }
        })


    }
    
    func displayDataSetChartView() {
        
        // 円グラフ表示 5回回す
        var entries: [PieChartDataEntry] = []
        
//        for i in 0 ... 4 {
//            if pattern == "cases" {
//                segment.selectedSegmentIndex = 0
//                entries += [PieChartDataEntry(value: Double(prefectureArray[i].cases), label: prefectureArray[i].name_ja)]
//            } else if pattern == "pcr" {
//                segment.selectedSegmentIndex = 1
//                entries += [PieChartDataEntry(value: Double(prefectureArray[i].pcr), label: prefectureArray[i].name_ja)]
//            } else if pattern == "deaths" {
//                segment.selectedSegmentIndex = 2
//                entries += [PieChartDataEntry(value: Double(prefectureArray[i].deaths), label: prefectureArray[i].name_ja)]
//            }
//
        
        
        
        
        if pattern == "cases" {
            for i in 0 ... 4 {
                segment.selectedSegmentIndex = 0
//                entries += [PieChartDataEntry(value: Double(prefectureArray[i].cases), label: prefectureArray[i].name_ja)]
            }
        } else if pattern == "pcr" {
            for i in 0 ... 4 {
                segment.selectedSegmentIndex = 1
                entries += [PieChartDataEntry(value: Double(prefectureArray[i].pcr), label: prefectureArray[i].name_ja)]
            }
        } else if pattern == "deaths" {
            for i in 0 ... 4 {
                segment.selectedSegmentIndex = 2
                entries += [PieChartDataEntry(value: Double(prefectureArray[i].deaths), label: prefectureArray[i].name_ja)]
        }
        }
            
        
        let circleView = PieChartView(frame: CGRect(x: 0, y: 150, width: view.frame.size.width, height: 300))
        circleView.centerText = "Top5"
        // アニメーション 反映時間 種類
        circleView.animate(xAxisDuration: 2, easingOption: .easeOutExpo)
        // 上記のentrysをPieChartDataSetに渡す
        let dataSet = PieChartDataSet(entries: entries)
        // グラフの色
        dataSet.colors = [
            colors.blue,
            colors.blueGreen,
            colors.yellowGreen,
            colors.yellowOrange,
            colors.redOrange]
        // 数字テキストの色
        dataSet.valueTextColor = colors.white
        // 都道府県名
        dataSet.entryLabelColor = colors.white
            // 上記までをcircleView.dataに渡す
            circleView.data = PieChartData(dataSet: dataSet)
            // 円グラフのタイトル非表示
            circleView.legend.enabled = false
            view.addSubview(circleView)
        
        
        
    }
    
    // どの選択を選んだのかpatternに代入
    // 画面再構築
    
    @objc func segmentSwitchAction(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
            case 0:
                pattern = "cases"
            case 1:
                pattern = "pcr"
            case 2:
                pattern = "deaths"
            default:
                break
        }
        loadView()
        viewDidLoad()
        
    }
    
     

}


//MARK: UISearchBarDelegate
    extension CircleChartViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 編集モード終了 、検索したら自動でキーボードが閉じる
        view.endEditing(true)
        // 検索した都道府県がprefectureArrayが存在する時のindexを取得
        // 配列の要素 $0が検索バーに入力されたテキスト(searchBar.text)と等しい(==)とき
        if let index = prefectureArray.firstIndex(where: { $0.name_ja == searchBar.text }) {
            prefecturs.text = "\(prefectureArray[index].name_ja)"
            pcrCount.text = "\(prefectureArray[index].pcr)"
            casesCount.text = "\(prefectureArray[index].cases)"
            deathsCount.text = "\(prefectureArray[index].deaths)"
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        // キャンセルボタンでSearchBarを空にする
        searchBar.text = ""
    }
    
   
}
// 棒グラフをタップするとUIViewに反映させる
//MARK: ChartViewDelegate
extension CircleChartViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if let dataSet = chartView.data?.dataSets[highlight.dataSetIndex] {
            let index = dataSet.entryIndex(entry: entry)
            prefecturs.text = "\(prefectureArray[index].name_ja)"
            pcrCount.text = "\(prefectureArray[index].pcr)"
            cases.text = "\(prefectureArray[index].cases)"
            deaths.text = "\(prefectureArray[index].deaths)"
        }
    }
    
}

