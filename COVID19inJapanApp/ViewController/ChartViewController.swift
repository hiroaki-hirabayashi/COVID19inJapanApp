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
    // チャート表示
//    private var chartView: HorizontalBarChartView?
    private var segment = UISegmentedControl()
    private var pattern = "cases"
    private let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
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
        displayDataSetUiVeiw()
        displayDataSetChartView()
        
            
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
        nextButton.setTitleColor(colors.blue, for: .normal)
        nextButton.titleLabel?.font = .systemFont(ofSize: 20)
        nextButton.addTarget(self, action: #selector(goCircle), for: .touchUpInside)
        navigationItem.titleView = nextButton
//        view.addSubview(nextButton)
    
//        let backButton = UIButton(type: .system)
//        backButton.frame = CGRect(x: 10, y: 30, width: 20, height: 20)
//        backButton.setImage(UIImage(named: ""), for: .normal)
//        backButton.tintColor = colors.white
//        backButton.titleLabel?.font = .systemFont(ofSize: 20)
//        backButton.addTarget(self, action: #selector(), for: .touchUpInside)
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
        searchBar.delegate = self
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
    
    func displayDataSetChartView() {
        let chartView = HorizontalBarChartView(frame: CGRect(x: 0, y: 150, width: view.frame.size.width, height: 300))
        // yAxisDuration 横方向 アニメーション1秒かけてグラフ生成 easingOption アニメーションの種類
        chartView.animate(yAxisDuration: 1.0, easingOption: .easeInCubic)
        // x軸ラベル数
        chartView.xAxis.labelCount = 10
        // x軸ラベル色
        chartView.xAxis.labelTextColor = colors.bluePurple
        // x軸のグリッド線除去
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.delegate = self
        // ダブルタップでズーム不可
        chartView.doubleTapToZoomEnabled = false
        // 2本指 ピンチアクションズーム不可
        chartView.pinchZoomEnabled = false
        // y軸ラベル色
        chartView.leftAxis.labelTextColor = colors.bluePurple
        // チャート説明、チャート名 表示しない
        chartView.legend.enabled = false
        // 右側の軸の表示をしないようにする
        chartView.rightAxis.enabled = false
        
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
        
        // 縦軸の都道府県名
        var names: [String] = []
        // 10回回してnamesに都道府県名を追加する
        for i in 0 ... 9 {
            names += ["\(self.prefectureArray[i].name_ja)"]
        }
        // chartViewのx軸の値にデータを代入
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: names)
        
        var entries: [BarChartDataEntry] = []
        
        for i in 0 ... 9 {
            if pattern == "cases" {
                segment.selectedSegmentIndex = 0
                entries += [BarChartDataEntry(x: Double(i), y: Double(self.prefectureArray[i].cases))]
            } else if pattern == "pcr" {
                segment.selectedSegmentIndex = 1
                entries += [BarChartDataEntry(x: Double(i), y: Double(self.prefectureArray[i].pcr))]
            } else if pattern == "deaths" {
                segment.selectedSegmentIndex = 2
                entries += [BarChartDataEntry(x: Double(i), y: Double(self.prefectureArray[i].deaths))]
            }
            
        }
        
        let set = BarChartDataSet(entries: entries, label: "県別状況データ")
        // 棒グラフの色
        set.colors = [colors.blue]
        // 棒グラフの頭に表示される値の色 今回は表示されない
        set.valueTextColor = colors.bluePurple
        // 棒グラフのデータをタップ時の色
        set.highlightColor = colors.white
        // chartViewのdataプロパティに整形したデータを代入
        chartView.data = BarChartData(dataSet: set)
        view.addSubview(chartView)
    }
    

        
    
    @objc func goCircle() {
        let storyboard = UIStoryboard(name: "CircleChartView", bundle: nil)
        let CircleChartViewController = storyboard.instantiateViewController(withIdentifier: "goCircleChartView") as! CircleChartViewController
        self.navigationController?.pushViewController(CircleChartViewController, animated: true)
    }
    // どの選択を選んだのかpatternに代入
    // 画面再構築
    @objc func segmentSwitchAction(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
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
extension ChartViewController: UISearchBarDelegate {
    
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
extension ChartViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if let dataSet = chartView.data?.dataSets[highlight.dataSetIndex] {
            let index = dataSet.entryIndex(entry: entry)
            prefecturs.text = "\(prefectureArray[index].name_ja)"
            pcrCount.text = "\(prefectureArray[index].pcr)"
            casesCount.text = "\(prefectureArray[index].cases)"
            deathsCount.text = "\(prefectureArray[index].deaths)"
        }
    }
    
}

