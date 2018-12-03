//
//  AlamofireNetWorkRequest.swift
//  ChartTestDemo
//
//  Created by 刘新 on 2018/7/4.
//  Copyright © 2018年 Liuxin. All rights reserved.
//

import UIKit
import Alamofire


class AlamofireNetWorkRequest: NSObject {

    
    
   
    
    public func netWorkRequestForResponseJSON(urlStr :String){
        
        NetworkTools.requestData(.post, URLString: "http://httpbin.org/post", parameters: ["name": "JackieQu"]) { (result) in
            print(result)
        }
        
        Alamofire.request("https://httpbin.org/get").responseJSON { response in
            print(response.request as Any)// 原始的URL请求
            print(response.response as Any)// HTTP URL响应
            print(response.data as Any)// 服务器返回的数据
            print(response.result as Any) // 响应序列化结果，在这个闭包里，存储的是JSON数据
            
            if let Json = response.result.value{
                print("JSON:\(Json)")
            }
        }
    }
    
    public func netWorkRequestForResponseData(urlStr :String){
        Alamofire.request("https://httpbin.org/get").responseData { response in
            debugPrint("All Response Info: \(response)")
            
            if response.result.isSuccess {
                if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)")
                }
            }
        }
        
        Alamofire.request("https://httpbin.org/get" , method: .get)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json","text/html","text/json","text/plain","text/javascript","text/xml","image/*"])
            .responseData { response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                case .failure(let error):
                    print(error)
                }
        }
        
        //使用URL编码参数的GET请求
        let parameters: Parameters = ["foo": "bar"]
        
        // 下面这三种写法是等价的
        Alamofire.request("https://httpbin.org/get", parameters: parameters) // encoding 默认是`URLEncoding.default`
        Alamofire.request("https://httpbin.org/get", parameters: parameters, encoding: URLEncoding.default)
        Alamofire.request("https://httpbin.org/get", parameters: parameters, encoding: URLEncoding(destination: .methodDependent))
        
        
        //使用URL编码参数的POST请求
        let parametersTow: Parameters = [
            "foo": "bar",
            "baz": ["a", 1],
            "qux": [
                "x": 1,
                "y": 2,
                "z": 3
            ]
        ]
        
        // 下面这三种写法是等价的
        Alamofire.request("https://httpbin.org/post", method: .post, parameters: parametersTow)
        Alamofire.request("https://httpbin.org/post", method: .post, parameters: parametersTow, encoding: URLEncoding.default)
        Alamofire.request("https://httpbin.org/post", method: .post, parameters: parametersTow, encoding: URLEncoding.httpBody)
        
        
        //使用JSON编码参数的POST请求
        let parametersThree: Parameters = [
            "foo": [1,2,3],
            "bar": [
                "baz": "qux"
            ]
        ]
        
        // 下面这两种写法是等价的
        Alamofire.request("https://httpbin.org/post", method: .post, parameters: parametersThree, encoding: JSONEncoding.default)
        Alamofire.request("https://httpbin.org/post", method: .post, parameters: parametersThree, encoding: JSONEncoding(options: []))

        //可以直接在请求方法添加自定义HTTP请求头，这有利于我们在请求中添加请求头
        let headers: HTTPHeaders = [
            "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
            "Accept": "application/json"
        ]
        
        Alamofire.request("https://httpbin.org/headers", headers: headers).responseJSON { response in
            debugPrint(response)
        }
        
        
    }
}
