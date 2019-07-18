import UIKit

class Config {
    private init() {}
    static let shared = Config()
    
    let CNS_ACCOUNT_USER_DEFAULTS_KEY = "CNS_ACCOUNT"
    let CNS_PASSWORD_USER_DEFAULTS_KEY = "CNS_PASSWORD"
    let WELLNESS_BASE_URL = URL(string: "https://wellness.sfc.keio.ac.jp/index.php")!
}
