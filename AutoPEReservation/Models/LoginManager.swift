import UIKit

final class LoginManger {
    private init() {}
    static let shared = LoginManger()

    internal func checkLoginState() -> Bool {
        guard let cnsAccount = getSavedCNSAccount(),
            let cnsPassword = getSavedCNSPassword() else {
                return false
        }
        return SFCWellnessClient.shared.checkIsValidLoginInfo(LoginInfo(cnsAccount: cnsAccount, cnsPassword: cnsPassword))
    }
    internal func attemptLogin(withLoginInfo loginInfo: LoginInfo, completion: (() -> Void)?, onError: (() -> Void)?) {
        if SFCWellnessClient.shared.checkIsValidLoginInfo(loginInfo) {
            self.saveLoginInfo(loginInfo)
            completion?() ?? {}()
        } else {
            onError?() ?? {}()
        }
    }
    private func saveLoginInfo(_ loginInfo: LoginInfo) {
        UserDefaults.standard.set(loginInfo.cnsAccount, forKey: Config.shared.CNS_ACCOUNT_USER_DEFAULTS_KEY)
        UserDefaults.standard.set(loginInfo.cnsPassword, forKey: Config.shared.CNS_PASSWORD_USER_DEFAULTS_KEY)
    }
    internal func action(completion: (_ loginInfo: LoginInfo) -> Void) {
        if let cnsAccount = getSavedCNSAccount(),
            let cnsPassword = getSavedCNSPassword() {
            completion(LoginInfo(cnsAccount: cnsAccount, cnsPassword: cnsPassword))
        }
    }
    private func getSavedCNSAccount() -> String? {
        return UserDefaults.standard.object(forKey: Config.shared.CNS_ACCOUNT_USER_DEFAULTS_KEY) as? String
    }
    private func getSavedCNSPassword() -> String? {
        return UserDefaults.standard.object(forKey: Config.shared.CNS_PASSWORD_USER_DEFAULTS_KEY) as? String
    }
}

struct LoginInfo {
    internal let cnsAccount: String
    internal let cnsPassword: String
}
