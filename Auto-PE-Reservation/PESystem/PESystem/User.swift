//ユーザーのログインとユーザーデータを取得するメソッドを書く
//非同期処理

import UIKit

class User: NSObject {
    //体育システムのURL
    public let baseURL = "https://wellness.sfc.keio.ac.jp/index.php"
    
    private let session: URLSession
    
    //セッションの初期化
    public init(config: URLSessionConfiguration? = nil) {
        self.session = config.map { URLSession(configuration: $0) } ?? URLSession.shared
    }
    
    //
    //一番基本となるhttpリクエストの根幹部分
    //ここに様々なリクエストを引数として与える
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
    
    public func login(pass:String,id:String)->Bool{
        
    }

}
