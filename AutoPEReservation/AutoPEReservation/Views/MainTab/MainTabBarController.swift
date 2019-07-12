import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoginManger.shared.checkLoginState { isLoggedIn in
            if !isLoggedIn {
                let loginViewController = LoginViewController()
                self.present(loginViewController, animated: true, completion: nil)
            }
        }
    }
}
