import UIKit

final class LoginManger {
    private init() {}
    static let shared = LoginManger()
    
    internal func checkLoginState(isLoggedInHandler: @escaping (Bool) -> Void) {
        guard let cnsAccount = getSavedCNSAccount(),
            let cnsPassword = getSavedCNSPassword() else {
                isLoggedInHandler(false)
                return
        }
        SFCWellnessClient.shared.checkValidAccount(withCNSAcount: cnsAccount, cnsPassword: cnsPassword) { isLoggedIn in
            isLoggedInHandler(isLoggedIn)
        }
    }
    internal func attemptLogin(withCNSAcount cnsAccount: String, cnsPassword: String, isValidHandler: @escaping (Bool) -> Void) {
        SFCWellnessClient.shared.checkValidAccount(withCNSAcount: cnsAccount, cnsPassword: cnsPassword) { [unowned self] isValid in
            if isValid {
                self.saveCNSAccountAndPassword(cnsAccount: cnsAccount, cnsPassword: cnsPassword)
            }
            isValidHandler(isValid)
        }
    }
    private func saveCNSAccountAndPassword(cnsAccount: String, cnsPassword: String) {
        UserDefaults.standard.set(cnsAccount, forKey: Config.shared.CNS_ACCOUNT_USER_DEFAULTS_KEY)
        UserDefaults.standard.set(cnsPassword, forKey: Config.shared.CNS_PASSWORD_USER_DEFAULTS_KEY)
    }
    private func getSavedCNSAccount() -> String? {
        return UserDefaults.standard.object(forKey: Config.shared.CNS_ACCOUNT_USER_DEFAULTS_KEY) as? String
    }
    private func getSavedCNSPassword() -> String? {
        return UserDefaults.standard.object(forKey: Config.shared.CNS_PASSWORD_USER_DEFAULTS_KEY) as? String
    }
}
