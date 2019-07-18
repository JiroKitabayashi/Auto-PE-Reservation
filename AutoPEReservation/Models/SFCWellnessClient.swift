import UIKit
import Kanna

final class SFCWellnessClient {
    private init() {}
    static let shared = SFCWellnessClient()
    
    private let loggedInKeywordPhrase = "loginしました．"
    
    internal func checkIsValidLoginInfo(_ loginInfo: LoginInfo) -> Bool {
        do {
            let data = try Data(contentsOf: Config.shared.createLoginURL(withCNSAcount: loginInfo.cnsAccount, cnsPassword: loginInfo.cnsPassword))
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
    internal func getAttendenceCount(withLoginInfo loginInfo: LoginInfo) -> Int {
        // TODO: 出席した回数を取って来るコード
        return 0
    }
    
    internal func getAbsenceCount(withLoginInfo loginInfo: LoginInfo) -> Int {
        // TODO: 欠席した回数を取って来るコード
        return 0
    }
    
    internal func getRegisteredPEClass(withLoginInfo loginInfo: LoginInfo) -> [PEClass] {
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
