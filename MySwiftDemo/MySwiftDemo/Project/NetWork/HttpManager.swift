//
//  HttpManager.swift
//  TSWeChat
//
//  Created by Hilen on 11/3/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

import Alamofire

//typealias ResponseSuccess<T: JsonModelProtocol> = (T) -> Void
typealias ResponseSuccess = (_ result : Any) -> Void
typealias ResponseFail = (_ errorMessage : String) -> Void

class HttpManager: NSObject {
    
    static let shared: HttpManager  = HttpManager()
    
    //禁止别的地方初始化本类
    fileprivate override init() {
        super.init()
    }
    
    public func request(_ method: HTTPMethod = .get, path: String!,
                        params: [String: Any]?,addHeader:[String:String?]? = nil,isNeedSign:Bool = false,
                        success: @escaping ResponseSuccess,
                        failure: @escaping ResponseFail) {
        var headers:HTTPHeaders = HTTPHeaders(["Content-Type":"application/json"])
        //请求头添加的参数
        if let addHeader = addHeader {
            for k in addHeader.keys {
                if let v = addHeader[k] {
                    if let v = v {
                        headers.add(name: k, value: v)
                    }
                }
            }
        }
        //addHeader lat lon
        headers = addCoords(headers)
        //签名
        if isNeedSign {
            headers = sign(headers, params: params)
        }
        var parameterEncoding :ParameterEncoding = JSONEncoding.default
        if method == .get || method == .delete {
            parameterEncoding = URLEncoding(arrayEncoding: .noBrackets,boolEncoding: .literal)
        }
        
        //正式的调用AF发出网络请求
        executeRequest(method, path: path, headers: headers, params: params, parameterEncoding: parameterEncoding, success: success, failure: failure)
    }
    
    //正式的调用AF
    public func executeRequest(_ method: HTTPMethod = .get, path: String!,
                               headers: HTTPHeaders? = nil,
                               params: [String: Any]?,parameterEncoding:ParameterEncoding,
                               success: @escaping ResponseSuccess,
                               failure: @escaping ResponseFail) {
        
        let url: String = path// path.hasPrefix("http") ? path : (DOMAIN_API_URL + path)
        printLog("url=\(url) params=\(String(describing: params))")
        
        SessionManager.share.sessionManager.request(url, method: method, parameters: params, encoding: parameterEncoding,headers: headers).validate({ request, response, data in
            if response.statusCode != StatusCode.noLogin.rawValue {
                return .success(())
            } else {
                return .failure(AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: StatusCode.noLogin.rawValue)))
            }
        }).responseString(encoding: .utf8) {[weak self] response in
                        
            switch response.response?.statusCode {
            case StatusCode.success.rawValue :
                switch response.result {
                case .success(let js):
                    printLog("success get list")
                    success(js)
                case .failure(let err):
                    print("怎么会执行到这里的?\(err.localizedDescription)")
                    break
                }
            case StatusCode.exToken.rawValue:
                self?.exTokenAction()
            case StatusCode.noAuth.rawValue:
                self?.noAuth()
            default:
                if let data = response.data,let msg = String(data: data, encoding: .utf8) {
                    failure(msg)
                    printLog(msg)
                }
            }
        }
        
        
        //        AF.request(url,
        //                   method: method,
        //                   parameters: params, encoder: URLEncodedFormParameterEncoder.default, headers: headers)
        //            .responseString { (response :AFDataResponse<String>) in
        ////                printLog(response.response?.statusCode)
        //                switch response.result {
        //                case .success(let successValue):
        //                    //服务器有响应
        //                    printLog(successValue)
        //                    if let jsonModel: T = T.deserialize(from: successValue) {
        //                        //json能解析成功
        ////                        if jsonModel as? BaseResponse {
        ////                            //是我们的类型，检查是否被踢出
        ////                            jsonModel.isKick()
        ////                        }
        //                        success(jsonModel)
        //                    } else {
        //                        //json解析失败
        //                        failure("json解析失败")
        //                    }
        //                case .failure(let errorValue):
        //                    //服务器未响应
        //                    printLog(errorValue)
        //                    failure("服务器未响应")
        //                }
        //            }
    }
    
    private func sign(_ headers:HTTPHeaders,params:Parameters?) -> HTTPHeaders {
        var headers = headers
        if let user = ZMAppSet.loginModel {
            let secret = user.secret
            let timestamp = Int(Date().timeIntervalSince1970)
            let randomString = String.randomString(24)
            let data = params != nil ? try? JSONSerialization.data(withJSONObject: params!, options: JSONSerialization.WritingOptions.fragmentsAllowed) : nil
            let bodyStr = data == nil ? "" : String(data: data!, encoding: .utf8)
            
            let s = ("\(secret)_" + "\(timestamp)_" + "\(randomString)_" + bodyStr!)
            //            print(s)
            let sign = s.md5
            headers.add(name: "TimeStamp", value: String(timestamp))
            headers.add(name: "Nonstr", value: randomString)
            headers.add(name: "Sign", value: sign)
            headers.add(name: "SignEnabled", value: "1")
        }
        return headers
    }
    private func addCoords(_ head:HTTPHeaders) -> HTTPHeaders {
        var head = head
        if let lon = ZMAppSet.locationInfo.lon,let lat = ZMAppSet.locationInfo.lat,let arr = ZMAppSet.locationInfo.locationRegions,let area = arr.last?.c {
            head.add(name: "GeoLongitude", value: String(lon))
            head.add(name: "GeoLatitude", value: String(lat))
            head.add(name: "GeoAreaCode", value: area)
        }
        return head
    }
    
    
    func exTokenAction() {
        ZMAppSet.clearWhenLoginOut()
    }
    func noAuth() {
        if ZMAppSet.hasRole() == false {
            ZMAppSet.showChooseRoleVC( isNeedAlert: true)
        }else {
            HUD.showError("没有操作权限")
        }
    }
}

//extension HttpManager {
//
//    private func md5params(dict: [String : String]) -> String! {
//
//        let keyArray = dict.keys.sorted()
//        var signString: String = String()
//
//        for key: String in keyArray {
//            signString.append(dict[key]!)
//        }
//        return signString.md5
//    }
//
//}


//extension String {
//    var md5:String {
//        let utf8 = cString(using: .utf8)
//        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
//        CC_MD5(utf8, CC_LONG(utf8!.count - 1), &digest)
//        return digest.reduce("") { $0 + String(format:"%02x", $1) }
//    }
//}
