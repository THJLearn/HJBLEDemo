//
//  Parameteter.swift
//  HJBLEDemo
//
//  Created by 赵优路 on 2020/4/24.
//  Copyright © 2020 thj. All rights reserved.
//

import Foundation
struct Parater {
    
    /// 字典 转换为 json
    static func covertDicToJson(dic: [String : Any]?) -> String? {
        guard let covertDic = dic else { return nil }
        if (!JSONSerialization.isValidJSONObject(covertDic)) {
            return nil
        }
        var jsonData: Data?
        do {
            jsonData = try JSONSerialization.data(withJSONObject: covertDic, options: .prettyPrinted)
        } catch {
            
            jsonData = nil
        }
        if jsonData == nil {
            return nil
        }
        return String(data: jsonData!, encoding: .utf8)
    }
    
    /// obj 转换为 json
    static func covertObjToJson(obj: Any?) -> String? {
        guard let covertObj = obj else { return nil }
        if (!JSONSerialization.isValidJSONObject(covertObj)) {
            return nil
        }
        var jsonData: Data?
        do {
            jsonData = try JSONSerialization.data(withJSONObject: covertObj, options: .prettyPrinted)
        } catch {
            
            jsonData = nil
        }
        if jsonData == nil {
            return nil
        }
        return String(data: jsonData!, encoding: .utf8)
    }
    
    /// jsondata转换为 dict
    static func covertDataJson(data: Data?) -> [String : Any]? {
        guard let jsonData = data else {
            return nil
        }
        var jsonObj: [String : Any]?
        do {
            jsonObj =  try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String : Any]
        } catch {
            
            return nil
        }
        return jsonObj
    }
    
    /// jsondata转换为 Array
    static func covertDataJsonToArray(data: Data?) -> [Any]? {
        guard let jsonData = data else {
            return nil
        }
        var jsonObj: [Any]?
        do {
            jsonObj =  try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [Any]
        } catch {
            
            return nil
        }
        return jsonObj
    }
    /// data 转 string
    static func covertDataToString(data: Data?) -> String? {
       guard let strData = data else {
           return nil
       }
       return String(data: strData, encoding: String.Encoding.utf8)
    }
    ///
    static func covertStringToData(str: String) -> Data? {
      return str.data(using: String.Encoding.utf8)
    }
    /// 字典 转换为 json
    static func covertDicToData(dic: [String : Any]?) -> Data? {
        guard let covertDic = dic else { return nil }
        if (!JSONSerialization.isValidJSONObject(covertDic)) {
            return nil
        }
        var jsonData: Data?
        do {
            jsonData = try JSONSerialization.data(withJSONObject: covertDic, options: .prettyPrinted)
        } catch {
            
            jsonData = nil
        }
        if jsonData == nil {
            return nil
        }
        return jsonData
    }
}
