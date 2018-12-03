//
//  NetworkTools.swift
//  ChartTestDemo
//
//  Created by 刘新 on 2018/7/5.
//  Copyright © 2018年 Liuxin. All rights reserved.
//

import UIKit
import Alamofire

enum MethodType {
    case get
    case post
}

class NetworkTools: NSObject {

    class func requestData(_ type : MethodType, URLString : String, parameters : [String : Any]? = nil, finishedCallback :  @escaping (_ result : Any) -> ()) {
        
        // 1.获取类型
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        
        // 2.发送网络请求
        let headers: HTTPHeaders = ["Accept": "application/json"]
        Alamofire.request(URLString, method: method, parameters: parameters ,encoding: URLEncoding.default , headers: headers).responseJSON { (response) in
            
            // 3.获取结果
            guard let result = response.result.value else {
                print(response.result.error!)
                return
            }
            
            // 4.将结果回调出去
            finishedCallback(result)
        }
    }
}
