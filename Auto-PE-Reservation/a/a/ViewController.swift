//
//  ViewController.swift
//  a
//
//  Created by 北林治朗 on 2019/06/21.
//  Copyright © 2019 JiroKitabayashi. All rights reserved.
//

import UIKit
import Kanna

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var textField: UITextField!
    
    var pickerView: UIPickerView = UIPickerView()
    let sfs_pass:String = UserDefaults.standard.string(forKey: "userPassword")!
    let sfs_id:String = UserDefaults.standard.string(forKey: "userId")!
    var list:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, 0, 35))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ViewController.done))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(ViewController.cancel))
        toolbar.setItems([cancelItem, doneItem], animated: true)
        
        self.textField.inputView = pickerView
        self.textField.inputAccessoryView = toolbar
        
        getAsync(pass: sfs_pass, id: sfs_id) { html in
            self.list = self.getAcceptableClassList(html: html)
//            print(html)
        }
        
        pickerView.reloadAllComponents()
    }
//体育システムにログインしトップページのhtmlとレスポンスデータを返す
    func getAsync(pass:String,id:String,completionBlock: @escaping (_ html:String) -> Void){
        let url = URL(string: "https://wellness.sfc.keio.ac.jp/index.php")
        var request = URLRequest(url: url!)
        // POSTを指定
        request.httpMethod = "POST"
        // POSTするデータをBodyとして設定
        request.httpBody = "login=\(id)&password=\(pass)&submit=login&page=top&mode=login&semester=20190&lang=ja&limit=9999".data(using: .utf8)
        //クロージャ
        let session = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            if error == nil, let data = data, let response = response as? HTTPURLResponse {
                // HTTPヘッダの取得
                print("Content-Type: \(response.allHeaderFields["Content-Type"])")
                // HTTPステータスコード
                print("statusCode: \(response.statusCode)")
                
                let html: String = NSString(data: data, encoding: String.Encoding.japaneseEUC.rawValue)! as String
                completionBlock(html);
            }
        }.resume()
    }
    
//    受けれられる授業名(英語)が入った配列を返す
    func getAcceptableClassList(html: String) -> [String] {
        var acceptableClasslist:[String] = []
        if let doc = try? HTML(html: html, encoding: .utf8) {
            
            var i:Int = 1
            for link in doc.css("td") {
                if i % 8 == 3{
                    print(link.text!)
                     acceptableClasslist.append(link.text!)
                }
                i+=1
            }
        }
        return  acceptableClasslist
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return list[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.textField.text = list[row]
    }
    
    @objc func cancel() {
        self.textField.text = ""
        self.textField.endEditing(true)
    }
    
    @objc func done() {
        self.textField.endEditing(true)
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}



