//
//  TestMoyaAPI.swift
//  ChartTestDemo
//
//  Created by 刘新 on 2018/8/21.
//  Copyright © 2018年 Liuxin. All rights reserved.
//

import UIKit
import Foundation
import Moya

private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

public enum TestMoyaEnum {
    case testReqOne(testStr :String)
    case testReqTow(channel :String , testId :Int , userId :Int)
    case testReqThree(reqDic :Dictionary<String,String>)
    case testReqFour(reqArray :[String])
    case testReqFive
}

extension TestMoyaEnum : TargetType{
    public var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    public var path: String {
        switch self {
        case .testReqOne(testStr: _):
            return "/zen"
        case .testReqTow(channel :let name, testId: _, userId: _):
            return "/users/\(name.urlEscaped)"
        case .testReqThree( _):
            return "/zen"
        case .testReqFour( _):
            return "/zen"
        case .testReqFive:
            return "/zen"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var sampleData: Data {
        switch self {
        case .testReqOne:
            return "Half measures are as bad as nothing at all.".data(using: String.Encoding.utf8)!
        case .testReqTow(channel :let name, testId: _, userId: _):
            return "{\"login\": \"\(name)\", \"id\": 100}".data(using: String.Encoding.utf8)!
        case .testReqThree( _):
            return "Half measures are as bad as nothing at all.".data(using: String.Encoding.utf8)!
        case .testReqFour( _):
            return "Half measures are as bad as nothing at all.".data(using: String.Encoding.utf8)!
        case .testReqFive:
            return "Half measures are as bad as nothing at all.".data(using: String.Encoding.utf8)!
        }
    }
    
    public var task: Task {
        switch self {
        case .testReqTow:
        return .requestParameters(parameters: ["sort": "pushed"], encoding: URLEncoding.default)
        default:
        return .requestPlain
    }
    }
    
    public var headers: [String : String]? {
        return nil
    }
    
    
}
