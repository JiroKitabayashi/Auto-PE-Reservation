import UIKit
import Kanna

final class SFCWellnessClient {
    private init() {}
    static let shared = SFCWellnessClient()
    
    private let loggedInKeywordPhrase = "loginしました．"
    
    internal func checkValidAccount(withCNSAcount cnsAccount: String, cnsPassword: String, isValidHandler: @escaping (Bool) -> Void) {
        let request = NSMutableURLRequest(url: Config.shared.WELLNESS_BASE_URL)
        request.httpMethod = "POST"
        request.httpBody = getRequestHTTPBody(withCNSAcount: cnsAccount, cnsPassword: cnsPassword)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { [unowned self] data, response, error in
            DispatchQueue.main.async {
                guard let data = data else {
                    isValidHandler(false)
                    return
                }
                //一つ目のpエレメントに"loginしました.　"のメッセージがあればログイン完了
                if let htmlNSString = NSString(data: data, encoding: String.Encoding.japaneseEUC.rawValue),
                    let doc = try? HTML(html: htmlNSString as String, encoding: .utf8),
                    let firstParagraph = doc.css("p").first,
                    let paragraphText = firstParagraph.content,
                    paragraphText.contains(self.loggedInKeywordPhrase) {
                    isValidHandler(true)
                    return
                }
                isValidHandler(false)
            }
        })
        task.resume()
    }
    
    private func getRequestHTTPBody(withCNSAcount cnsAccount: String, cnsPassword: String) -> Data {
        return "login=\(cnsAccount)&password=\(cnsPassword)&submit=login&page=top&mode=login&semester=20190&lang=ja&limit=9999".data(using: .utf8)!
    }
}
