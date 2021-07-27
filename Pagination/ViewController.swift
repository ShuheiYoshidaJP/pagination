//
//  ViewController.swift
//  Pagination
//
//  Created by 吉田周平 on 2021/07/28.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    //複製用のデータソース
    let list = (0..<31).map { "\($0)" }
    //table viewで参照するデータソース
    var dataSource: [String] = []
    //データリクエスト用のベージ番号
    var page = 0
    //プルリフレッシュ用
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //プルリフレッシュ用
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        //データリクエスト
        request()
    }
    //データリクエスト
    func request() {
        //複製用データをtable viewで参照するデータソースに追加する
        let addList = list.map { "\(page)-\($0)" }
        dataSource += addList
        //リロード
        tableView.reloadData()
        //次のリクエスト用にページ番号更新
        page += 1
    }
    
    @objc func refresh() {
        //ページ番号初期化
        page = 0
        //table viewで参照するデータソースの初期化
        dataSource = []
        //リクエスト
        request()
        //グルグル終了
        refreshControl.endRefreshing()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //現在の位置取得
        let currentOffsetY = scrollView.contentOffset.y
        //最下のcellの位置取得
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.height
        //最下のcellまでの距離取得
        let distanceToBottom = maximumOffset - currentOffsetY
        print("currentOffsetY:\(currentOffsetY)")
        print("maximumOffset:\(maximumOffset)")
        print("distanceToBottom:\(distanceToBottom)")
        if distanceToBottom < 150 {
            request()
        }
    }
}
