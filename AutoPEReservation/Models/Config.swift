import UIKit

class Config {
    private init() {}
    static let shared = Config()
    
    let CNS_ACCOUNT_USER_DEFAULTS_KEY = "CNS_ACCOUNT"
    let CNS_PASSWORD_USER_DEFAULTS_KEY = "CNS_PASSWORD"
    let WELLNESS_BASE_URL = URL(string: "https://wellness.sfc.keio.ac.jp/index.php")!
    
    func createLoginURL(withCNSAcount cnsAccount: String, cnsPassword: String) -> URL {
        return URL(string: "\(Config.shared.WELLNESS_BASE_URL)/login=\(cnsAccount)&password=\(cnsPassword)&submit=login&page=top&mode=login&semester=20190&lang=ja&limit=9999")!
    }
}
