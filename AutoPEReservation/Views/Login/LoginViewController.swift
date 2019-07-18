import UIKit
import Kanna

class LoginViewController: UIViewController {
    
    @IBOutlet weak var cnsAccountTextField: UITextField!
    @IBOutlet weak var cnsPasswordTextField: UITextField!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cnsAccountTextField.becomeFirstResponder()
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        guard let cnsAccount = cnsAccountTextField.text as String?,
            let cnsPassword = cnsPasswordTextField.text as String?,
            !cnsAccount.isEmpty,
            !cnsPassword.isEmpty else {
                displayDefaultAlert(title: "エラー", message: "パスワードまたはIDが間違っています。")
                return
            }
        
        LoginManger.shared.attemptLogin(withLoginInfo: LoginInfo(cnsAccount: cnsAccount, cnsPassword: cnsPassword), completion: {
            let registeredAlertController = UIAlertController(title: "どうも、登録完了!!", message: nil, preferredStyle: .alert)
            registeredAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { [unowned self] _ in
                // 画面遷移
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(registeredAlertController, animated: true, completion: nil)
        }, onError: {
            self.displayDefaultAlert(title: "エラー", message: "パスワードまたはIDが間違っています。")
        })
    }
    private func displayDefaultAlert(title: String?, message: String?){
        let defaultAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        defaultAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(defaultAlertController,animated:true, completion:nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}



