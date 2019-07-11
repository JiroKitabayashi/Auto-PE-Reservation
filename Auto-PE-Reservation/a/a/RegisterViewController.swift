import UIKit
import Kanna

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    var statusCode: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        //画面遷移
        
        
        let userId = userNameTextField.text as String?
        let userPassword = userPasswordTextField.text as String?

        
        // 空白確認
        if(userId == "" || userPassword == ""){
            //アラートメッセージ
            displayMyAlertMessage(userMessage: "全てのフォームに入力してください。")
            return
        }
        
        //有効なSFS_ID/PASSなのか確認
        let data = getHttpData(id: userId!, pass: userPassword!)
        if (passAndIdIsValid(data: data)){
    
        }else{
            displayMyAlertMessage(userMessage: "パスワードまたはIDが間違っています。")
            return
        }
        
        // データ登録
        UserDefaults.standard.set(userId, forKey:"userId")
        UserDefaults.standard.set(userPassword, forKey:"userPassword")
        //UserDefaults.standard.synchronize();
        
        // メッセージアラートなど
        let myAlert = UIAlertController(title:"Alert", message: "どうも、登録完了!!", preferredStyle:  UIAlertController.Style.alert)
        let okAction = UIAlertAction(title:"OK", style: UIAlertAction.Style.default){
            //画面遷移
            action in self.dismiss(animated: true, completion:nil)
            
            self.performSegue(withIdentifier: "RegisterViewToMain", sender: nil)
        }
        myAlert.addAction(okAction)
        self.present(myAlert, animated:true,completion:nil)
        
        
        
    }
    
    func displayMyAlertMessage(userMessage: String){
        
        let myAlert = UIAlertController(title:"Alert", message: userMessage, preferredStyle:  UIAlertController.Style.alert)
        let okAction = UIAlertAction(title:"OK", style: UIAlertAction.Style.default, handler:nil)
        myAlert.addAction(okAction);
        self.present(myAlert,animated:true, completion:nil)
        
    }
    
    func getHttpData(id:String,pass:String)->Data{
        let baseUrl:URL = URL(string: "https://wellness.sfc.keio.ac.jp/index.php")!
        let req = NSMutableURLRequest(url: baseUrl)
        
        let postText = "login=\(id)&password=\(pass)&submit=login&page=top&mode=login&semester=20190&lang=ja&limit=9999"
        let postData = postText.data(using: String.Encoding.utf8)
        
        req.httpMethod = "POST"
        req.httpBody = postData
        
        let myHttpSession = HttpClientImpl()
        let (data, response, error) = myHttpSession.execute(request: req as URLRequest)
        
        if response != nil {
            print("http response:\(response!)")
        }
        
        if error != nil{
            print(error!)
        }
        
        if data != nil{
            
        }
        return data! as Data
    }
    
    func passAndIdIsValid(data: Data) -> Bool {
        let html: String = NSString(data: data, encoding: String.Encoding.japaneseEUC.rawValue)! as String
        var isLogind: Bool = false
        if let doc = try? HTML(html: html, encoding: .utf8) {
            for content in doc.css("p") {
                print(content.text!)
                if(content.text!.contains("loginしました．")){
                    isLogind = true
                    return isLogind
                }else{
                    isLogind = false
                    print("passまたはidが不正")
                }
            }
        }
        return  isLogind
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

//httpリクエストを同期処理で扱うためのクラス
public class HttpClientImpl {
    
//    初期化処理
    private let session: URLSession
    
    public init(config: URLSessionConfiguration? = nil) {
        self.session = config.map { URLSession(configuration: $0) } ?? URLSession.shared
    }
    
    public func execute(request: URLRequest) -> (NSData?, URLResponse?, NSError?) {
        var d: NSData? = nil
        var r: URLResponse? = nil
        var e: NSError? = nil
        let semaphore = DispatchSemaphore(value: 0)
        session
            .dataTask(with: request) { (data, response, error) -> Void in
                d = data as NSData?
                r = response
                e = error as NSError?
                semaphore.signal()
            }
            .resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return (d, r, e)
    }
}

