import UIKit
import Kanna

final class SFCWellnessClient {
    private init() {}
    static let shared = SFCWellnessClient()
    
    private let loggedInKeywordPhrase = "loginしました．"
    
    internal func checkValidAccount(withCNSAcount cnsAccount: String, cnsPassword: String) -> Bool {
        do {
            let data = try Data(contentsOf: Config.shared.createLoginURL(withCNSAcount: cnsAccount, cnsPassword: cnsPassword))
            if let htmlNSString = NSString(data: data, encoding: String.Encoding.japaneseEUC.rawValue),
                let doc = try? HTML(html: htmlNSString as String, encoding: .utf8),
                let firstParagraph = doc.css("p").first,
                let paragraphText = firstParagraph.content,
                paragraphText.contains(self.loggedInKeywordPhrase) {
                return true
            }
        } catch {
            fatalError("Failed to fetch")
        }
        return false
    }
    
    private func createRequestHTTPBody(withCNSAcount cnsAccount: String, cnsPassword: String) -> Data {
        return "login=\(cnsAccount)&password=\(cnsPassword)&submit=login&page=top&mode=login&semester=20190&lang=ja&limit=9999".data(using: .utf8)!
    }
    internal func getAttendenceCount(withCNSAcount cnsAccount: String, cnsPassword: String) -> Int {
        // TODO: 出席した回数を取って来るコード
        return 0
    }
    
    internal func getAbsentCount(withCNSAcount cnsAccount: String, cnsPassword: String) -> Int {
        // TODO: 欠席した回数を取って来るコード
        return 0
    }
    
    internal func getRegisteredPEClass(withCNSAcount cnsAccount: String, cnsPassword: String) -> [PEClass] {
        // TODO: 予約したクラスを取ってくるコード
        return []
     }
    
//     internal func getSyllabus(withCNSAcount cnsAccount: String, cnsPassword: String, id: String) -> Syllabus {
//        // TODO: シラバスを取って来るコード
//     }
//     internal func registerClass(withCNSAcount cnsAccount: String, cnsPassword: String, id: String, completion: (() -> Void)?) {
//        // TODO: クラスを予約
//     }
}
