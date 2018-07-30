//
//  ViewController.swift
//  weather-swift
//
//  Created by 刘欣 on 2018/3/15.
//  Copyright © 2018年 刘欣. All rights reserved.
//

import UIKit
import Alamofire
import HandyJSON

class Animal: HandyJSON {
    var temperature: String?
    var date: String?
    var weather: String?
    
    required init() {} // 如果定义是struct，连init()函数都不用声明；
}

class ViewController: UIViewController {

    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func btnClick(_ sender: UIButton) {
        let para=["location":"重庆","output":"json","ak":"GpqXc7v1ARtIOkgTxDWGoM60HBalGm99","mcode":"com.liuxin.weather-swift"];
        Alamofire.request("http://api.map.baidu.com/telematics/v3/weather", method: .get, parameters: para).responseJSON { (returnResult) in
            
            if let jsonStr :NSDictionary = returnResult.result.value as? NSDictionary {
                print("-------\(jsonStr)")
                let resultsArr = jsonStr["results"] as! NSArray;
                let resultsDic  = resultsArr[0] as! NSDictionary
                let weatherArr  = resultsDic["weather_data"] as! NSArray;
                let weatherDic = weatherArr[0] as! NSDictionary
                
                let jstr=self.getJSONStringFromDictionary(dictionary: weatherDic)
                
                let animal = JSONDeserializer<Animal>.deserializeFrom(json: jstr) as! Animal;
        
                self.textView.text="城市:重庆\n日期:\(animal.date!)\n温度:\(animal.temperature!)\n天气:\(animal.weather!)"
            }
        }
    }
    
    //JSONString转换为字典
    func getDictionaryFromJSONString(jsonString:String) ->NSDictionary{
        let jsonData:Data = jsonString.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
    }
    
    //字典转换为JSONString
    func getJSONStringFromDictionary(dictionary:NSDictionary) -> String {
        if (!JSONSerialization.isValidJSONObject(dictionary)) {
            print("无法解析出JSONString")
            return ""
        }
        let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData!
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
    }
}

