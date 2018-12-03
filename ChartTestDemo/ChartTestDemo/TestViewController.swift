//
//  TestViewController.swift
//  ChartTestDemo
//
//  Created by 刘新 on 2018/5/8.
//  Copyright © 2018年 Liuxin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TestViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource {

    let testTableView :UITableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height), style: .plain)
    let refreshControl :UIRefreshControl = UIRefreshControl(frame: CGRect(x: 0, y: -UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        NetworkTools.requestData(.post, URLString: "https://httpbin.org/post", parameters: ["name": "JackieQu"]) { (resultData) in
            let testJson = JSON(resultData)
            print(testJson)
            print("____________\(testJson["url"])")
        }
        
//        NetworkTools.requestData(.post, URLString: "http://httpbin.org/post", parameters: ["name": "JackieQu"]) { (result) in
//            print("--------------\(result)")
//
//        }
        let headers: HTTPHeaders = ["Accept": "application/json"]
        CD_Alamofire.cd_request("https://httpbin.org/post", method: .post, parameters: ["id" : "32"], encoding: URLEncoding.default, headers: headers) { (isOK, data, error) in
            //print("===============\(data as Any)")
        }
        
        // Do any additional setup after loading the view.
        
        let studname = {
            print("Swift 闭包示例")
        }
        studname()
        
        let divide = { (val1: Int, val2: Int) -> Int in
            return val1/val2
        }
        let result = divide(20 , 2)
        print(result)
        
        let names = ["A","AA","SS","KK","YY","LL","YN","DU","LO"]
        
        func backwards(s1: String, s2: String) -> Bool{
            return s1 > s2
        }
        
        let reversed = names.sorted(by: backwards)
        
        print(reversed)
        
        testTableView.delegate = self
        testTableView.dataSource = self
        testTableView.tableFooterView = UIView()
        self.view.addSubview(testTableView)
        
        //refreshControl.attributedTitle = NSAttributedString(string: "加载中...")
        refreshControl.tintColor = UIColor.lightGray
        refreshControl.addTarget(self, action: #selector(refreshData), for: UIControl.Event.valueChanged)
        self.testTableView.addSubview(refreshControl)
    }

    @objc func refreshData() {
        
        //self.refreshControl.beginRefreshing()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            DispatchQueue.main.async(execute: {
                self.refreshControl.endRefreshing()
            })
        }
    }
    @IBAction func ddddd(_ sender: Any) {
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cellID")
        cell.textLabel?.text = String(indexPath.row)
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
