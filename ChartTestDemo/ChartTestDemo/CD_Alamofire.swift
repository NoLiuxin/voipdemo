//
//  CD_Alamofire.swift
//  ChartTestDemo
//
//  Created by 刘新 on 2018/7/5.
//  Copyright © 2018年 Liuxin. All rights reserved.
//

import Foundation
import Alamofire

enum CD_UploadParamType {
    case tData
    case tFileURL
}
struct CD_UploadParam {
    ///Data数据流
    var fileData = Data()
    ///文件的FileURL
    var fileURL:URL?
    ///服务器对应的参数名称
    var serverName = ""
    ///文件的名称(上传到服务器后，服务器保存的文件名)
    var filename = ""
    ///文件的MIME类型(image/png,image/jpg,application/octet-stream/video/mp4等)
    var mimeType = "image/png"
    ///文件类型
    var type:CD_UploadParamType = .tData
}

//error = CD_ErrorType.noData.stringValue
//block?(isOk,"",cd_returnNSError(error))
enum CD_ErrorType:Int {
    case noData      = 10000000
    case nsurlErrorUnknown = -1
}

class CD_Alamofire {
    open static let shared: CD_Alamofire = CD_Alamofire()
    fileprivate let _manager = SessionManager.default
    
    let CD_NetStatusNotifyName = "CD_NetworkReachabilityStatus"
    ///取消上传
    var cd_uploadCancel = false
    ///当前网络状态
    var cd_netStatusNow :CD_NetworkReachabilityStatus = .tNnknown {
        didSet{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:CD_NetStatusNotifyName), object: cd_netStatusNow, userInfo: [:])
        }
    }
    fileprivate var openNetStatus:Bool = false
}

//MARK:--- 请求，上传，下载 ----------
/// 网络请求回调闭包 success:是否成功 result:数据 progress:请求进度 error:错误信息
typealias cd_netComBlock = (_ success: Bool, _ result: Any?, _ error: String?) -> Void
typealias cd_netProgressBlock = (_ progress:Progress?) -> Void


extension CD_Alamofire {
    ///请求
    class func cd_request(
        _ url: String,
        method: HTTPMethod = .get,
        parameters:[String:String] = [:],
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil,
        block: cd_netComBlock? = nil) {
        guard !url.isEmpty else {
            block?(false,"","空地址")
            return
        }
        CD_Alamofire.shared._manager.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON { response in
            CD_Alamofire.disposeResponse(response, block:block)
        }
    }
    ///上传
    class func cd_upload(
        _ url:String,
        param:[String:String] = [:],
        uploadParams:[CD_UploadParam],
        headers: HTTPHeaders? = nil,
        progressBlock: cd_netProgressBlock? = nil,
        block: cd_netComBlock? = nil) {
        guard !url.isEmpty else {
            block?(false,"","空地址")
            return
        }
        CD_Alamofire.shared.cd_uploadCancel = false
        CD_Alamofire.shared._manager.upload(multipartFormData: { (formData) in
            for item in uploadParams {
                switch (item.type) {
                case .tData:
                    formData.append(item.fileData, withName: item.serverName, fileName: item.filename, mimeType: item.mimeType)
                case .tFileURL:
                    if let fileUrl = item.fileURL {
                        formData.append(fileUrl, withName: item.serverName, fileName: item.filename, mimeType: item.mimeType)
                    }
                }
            }
            for item in param {
                let dat:Data = item.value.data(using: String.Encoding.utf8) ?? Data()
                formData.append(dat, withName: item.key)
            }
        }, to: url, headers:headers, encodingCompletion: { (encodingResult) in
            switch encodingResult {
            case .success(let uploads, _, _):
                if CD_Alamofire.shared.cd_uploadCancel {
                    uploads.cancel()
                }
                uploads.uploadProgress(closure: { (progress) in
                    progressBlock?(progress)
                }).responseJSON { response in
                    CD_Alamofire.disposeResponse(response, block:block)
                }
            case .failure( _):
                block?(false,"","error")
            }
        })
    }
    ///下载
    class func cd_downLoad(
        _ url:String,
        param:[String:Any],
        progressBlock: cd_netProgressBlock? = nil,
        block: cd_netComBlock? = nil) {
        
    }
    ///数据处理
    fileprivate class func disposeResponse(_ response:DataResponse<Any>, block:cd_netComBlock? = nil) {
        var error = ""
        var isOk = false
        switch response.result {
        case .success(let json):
            if (response.result.value != nil) {
                isOk = true
                error = ""
            } else{
                isOk = false
                error = "CD_ErrorType.noData.stringValue"
            }
            block?(isOk,json,error)
        case .failure( _):
            isOk = false
            block?(isOk,"","cd_returnNSError(error)")
        }
    }
}
//MARK:--- 网络监测 建议在 AppDelegate 中开启，响应存在不及时----------
fileprivate let CD_NetworkManager = NetworkReachabilityManager(host: "www.baidu.com")
extension CD_Alamofire {
    public enum CD_NetworkReachabilityStatus {
        case tNotReachable
        case tNnknown
        case tEthernetOrWiFi
        case tWWAN
    }
    ///开启网络监测
    class func cd_OpenNetStatus() {
        // 变量不符合条件判断时，执行下面代码
        guard !CD_Alamofire.shared.openNetStatus else {
            CD_Alamofire.shared.cd_netStatusNow = CD_Alamofire.shared.cd_netStatusNow
            return
        }
        CD_Alamofire.shared.openNetStatus = true
        //首次进入有网络会响应，但没网络不响应
        CD_NetworkManager!.listener = { status in
            switch status {
            case .notReachable:
                CD_Alamofire.shared.cd_netStatusNow = .tNotReachable
            case .unknown:
                CD_Alamofire.shared.cd_netStatusNow = .tNnknown
            case .reachable(.ethernetOrWiFi):
                CD_Alamofire.shared.cd_netStatusNow = .tEthernetOrWiFi
            case .reachable(.wwan):
                CD_Alamofire.shared.cd_netStatusNow = .tWWAN
            }
        }
        CD_NetworkManager!.startListening()
    }
}

//MARK:--- SSL认证 （[来自航歌](http://www.hangge.com/blog/cache/detail_991.html)）-----------------------------
extension CD_Alamofire {
    //存储认证相关信息
    struct CD_IdentityAndTrust {
        var identityRef:SecIdentity
        var trust:SecTrust
        var certArray:AnyObject
    }
    
    func cd_SSL(_ hosts:[String], p12:(name:String, pwd:String)) {
        let selfSignedHosts = hosts//["192.168.1.112", "www.hangge.com"]
        _manager.delegate.sessionDidReceiveChallenge = { session, challenge in
            //认证服务器（这里不使用服务器证书认证，只需地址是我们定义的几个地址即可信任）
            if challenge.protectionSpace.authenticationMethod
                == NSURLAuthenticationMethodServerTrust
                && selfSignedHosts.contains(challenge.protectionSpace.host)
            {
                print("服务器认证！")
                let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
                return (.useCredential, credential)
            }
                //认证客户端证书
            else if challenge.protectionSpace.authenticationMethod
                == NSURLAuthenticationMethodClientCertificate
            {
                print("客户端证书认证！")
                //获取客户端证书相关信息
                let identityAndTrust:CD_IdentityAndTrust = self.extractIdentity(p12);
                let urlCredential:URLCredential = URLCredential(
                    identity: identityAndTrust.identityRef,
                    certificates: identityAndTrust.certArray as? [AnyObject],
                    persistence: URLCredential.Persistence.forSession);
                
                return (.useCredential, urlCredential);
            }
                // 其它情况（不接受认证）
            else
            {
                print("其它情况（不接受认证）")
                return (.cancelAuthenticationChallenge, nil)
            }
        }
    }
    //MARK:--- 双向认证 -----------------------------
    func cd_SSL(_ cerName:String ,p12:(name:String, pwd:String)) {
        
        _manager.delegate.sessionDidReceiveChallenge = { (session, challenge) in
            //认证服务器证书
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust
            {
                print("服务端证书认证！")
                let serverTrust:SecTrust = challenge.protectionSpace.serverTrust!
                let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0)!
                let remoteCertificateData
                    = CFBridgingRetain(SecCertificateCopyData(certificate))!
                //证书目录
                let cerPath = Bundle.main.path(forResource: cerName, ofType: "cer")!
                let cerUrl = URL(fileURLWithPath:cerPath)
                let localCertificateData = try! Data(contentsOf: cerUrl)
                if (remoteCertificateData.isEqual(localCertificateData) == true) {
                    let credential = URLCredential(trust: serverTrust)
                    challenge.sender?.use(credential, for: challenge)
                    return (URLSession.AuthChallengeDisposition.useCredential,
                            URLCredential(trust: challenge.protectionSpace.serverTrust!))
                }else {
                    return (.cancelAuthenticationChallenge, nil)
                }
            }
                //认证客户端证书
            else if challenge.protectionSpace.authenticationMethod
                == NSURLAuthenticationMethodClientCertificate
            {
                print("客户端证书认证！")
                //获取客户端证书相关信息
                let identityAndTrust:CD_IdentityAndTrust = self.extractIdentity(p12);
                
                let urlCredential:URLCredential = URLCredential(
                    identity: identityAndTrust.identityRef,
                    certificates: identityAndTrust.certArray as? [AnyObject],
                    persistence: URLCredential.Persistence.forSession);
                
                return (.useCredential, urlCredential);
            }
                // 其它情况（不接受认证）
            else
            {
                print("其它情况（不接受认证）")
                return (.cancelAuthenticationChallenge, nil)
            }
        }
    }
    //MARK:--- 获取客户端证书相关信息 -----------------------------
    fileprivate func extractIdentity(_ p12:(name:String, pwd:String)) -> CD_IdentityAndTrust {
        
        var identityAndTrust:CD_IdentityAndTrust!
        var securityError:OSStatus = errSecSuccess
        //客户端证书 p12 文件目录
        let path: String = Bundle.main.path(forResource: p12.name, ofType: "p12")!
        let PKCS12Data = NSData(contentsOfFile:path)!
        let key : NSString = kSecImportExportPassphrase as NSString
        let options : NSDictionary = [key : p12.pwd] //客户端证书密码
        //create variable for holding security information
        //var privateKeyRef: SecKeyRef? = nil
        var items : CFArray?
        securityError = SecPKCS12Import(PKCS12Data, options, &items)
        if securityError == errSecSuccess {
            let certItems:CFArray = (items as CFArray?)!;
            let certItemsArray:Array = certItems as Array
            let dict:AnyObject? = certItemsArray.first;
            if let certEntry:Dictionary = dict as? Dictionary<String, AnyObject> {
                // grab the identity
                let identityPointer:AnyObject? = certEntry["identity"];
                let secIdentityRef:SecIdentity = (identityPointer as! SecIdentity?)!
                //print("\(identityPointer)  :::: \(secIdentityRef)")
                // grab the trust
                let trustPointer:AnyObject? = certEntry["trust"]
                let trustRef:SecTrust = trustPointer as! SecTrust
                //print("\(trustPointer)  :::: \(trustRef)")
                // grab the cert
                let chainPointer:AnyObject? = certEntry["chain"]
                identityAndTrust = CD_IdentityAndTrust(identityRef: secIdentityRef,
                                                       trust: trustRef, certArray:  chainPointer!)
            }
        }
        return identityAndTrust;
    }
}





