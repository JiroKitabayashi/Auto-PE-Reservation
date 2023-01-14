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
                let attendanceInfoDiv = doc.css("p").first,
                let divText = attendanceInfoDiv.content,
                divText.contains(self.loggedInKeywordPhrase) {
                return true
            }
        } catch {
            fatalError("Failed to fetch")
        }
        return false
    }
    internal func getAttendenceCount(withLoginInfo loginInfo: LoginInfo) -> Int {
        // TODO: 出席した回数を取って来るコード
        do {
            let data = try Data(contentsOf: Config.shared.createLoginURL(withCNSAcount: loginInfo.cnsAccount, cnsPassword: loginInfo.cnsPassword))
            if let htmlNSString = NSString(data: data, encoding: String.Encoding.japaneseEUC.rawValue),
                let doc = try? HTML(html: htmlNSString as String, encoding: .utf8),
                let attendanceInfoDiv = doc.css("div#w3-center w3-margin w3-panel w3-border w3-round w3-pale-green w3-large w3-padding-small kanji-keep").first,
                let divText = attendanceInfoDiv.content,
                let attendanceString = divText.capture(pattern: "出席&nbsp;\\d+", group: 0),
                let attendanceCount = Int(attendanceString.capture(pattern: "\\d+", group: 0)!) {
                print(attendanceCount)
                return attendanceCount
            }
        } catch {
            fatalError("Failed to fetch")
        }
        return 0
    }
    
    internal func getAbsenceCount(withLoginInfo loginInfo: LoginInfo) -> Int {
        // TODO: 欠席した回数を取って来るコード
        do {
            let data = try Data(contentsOf: Config.shared.createLoginURL(withCNSAcount: loginInfo.cnsAccount, cnsPassword: loginInfo.cnsPassword))
            if let htmlNSString = NSString(data: data, encoding: String.Encoding.japaneseEUC.rawValue),
                let doc = try? HTML(html: htmlNSString as String, encoding: .utf8),
                let attendanceInfoDiv = doc.css("div#w3-center w3-margin w3-panel w3-border w3-round w3-pale-green w3-large w3-padding-small kanji-keep").first,
                let divText = attendanceInfoDiv.content,
                let attendanceString = divText.capture(pattern: "欠席&nbsp;\\d+", group: 0),
                let attendanceCount = Int(attendanceString.capture(pattern: "\\d+", group: 0)!) {
                return attendanceCount
            }
        } catch {
            fatalError("Failed to fetch")
        }
        return 0
    }
    
    internal func getRegisteredPEClass(withLoginInfo loginInfo: LoginInfo) -> [PEClass] {
        // TODO: 予約したクラスを取ってくるコード
        return []
     }
    
    private func getAttencanceInfo(withLoginInfo loginInfo: LoginInfo, keyword:String) -> Int {
        // TODO: 出席に関する情報をまとめて取ってきてkeywordによって取り出す値を変える
        ///   - keyword: 出席,欠席,予約のいずれか
        
        do {
            let data = try Data(contentsOf: Config.shared.createLoginURL(withCNSAcount: loginInfo.cnsAccount, cnsPassword: loginInfo.cnsPassword))
            if let htmlNSString = NSString(data: data, encoding: String.Encoding.japaneseEUC.rawValue),
                let doc = try? HTML(html: htmlNSString as String, encoding: .utf8),
                let attendanceInfoDiv = doc.css("div#w3-center w3-margin w3-panel w3-border w3-round w3-pale-green w3-large w3-padding-small kanji-keep").first,
                let divText = attendanceInfoDiv.content,
                let attendanceString = divText.capture(pattern: keyword+"&nbsp;\\d+", group: 0),
                let attendanceCount = Int(attendanceString.capture(pattern: "\\d+", group: 0)!) {
                return attendanceCount
            }
        } catch {
            fatalError("Failed to fetch")
        }
        return 0
    }
    
//     internal func getSyllabus(withCNSAcount cnsAccount: String, cnsPassword: String, id: String) -> Syllabus {
//        // TODO: シラバスを取って来るコード
//     }
//     internal func registerClass(withCNSAcount cnsAccount: String, cnsPassword: String, id: String, completion: (() -> Void)?) {
//        // TODO: クラスを予約
//     }
    
}

extension String {
    
    /// 正規表現でキャプチャした文字列を抽出する
    ///
    /// - Parameters:
    ///   - pattern: 正規表現
    ///   - group: 抽出するグループ番号(>=1)
    /// - Returns: 抽出した文字列
    func capture(pattern: String, group: Int) -> String? {
        let result = capture(pattern: pattern, group: [group])
        return result.isEmpty ? nil : result[0]
    }
    
    func capture(pattern: String, group: [Int]) -> [String] {
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return []
        }
        
        guard let matched = regex.firstMatch(in: self, range: NSRange(location: 0, length: self.count)) else {
            return []
        }
        
        return group.map { group -> String in
            return (self as NSString).substring(with: matched.range(at: group))
        }
    }
}

