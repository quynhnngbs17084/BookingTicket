
import UIKit
import CoreData

class LoginViewController: UIViewController {
    
    //MARK: - Outlets, Actions

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBAction func touchRegisterButton(_ sender: Any) {
        let registerVC = RegisterViewController()
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @IBAction func phoneNumberTyping(_ sender: Any) {
        if let password = self.passwordTextField.text, password.isEmpty == false {
            self.loginButton.isEnabled = true
        }
    }
    
    @IBAction func passwordTyping(_ sender: Any) {
        if let phoneNumber = self.phoneNumberTextField.text, phoneNumber.isEmpty == false {
            self.loginButton.isEnabled = true
        }
    }
    
    @IBAction func touchLoginButton(_ sender: Any) {
        LoadingActivity.shared.show()
        if let regitedUser = (self.users.filter { ($0.value(forKey: "phoneNumber") as! String) == self.phoneNumberTextField.text ?? "" && ($0.value(forKey: "password") as! String) == self.passwordTextField.text ?? ""}).first {
            LoadingActivity.shared.hideAfter {
                if let window = UIApplication.shared.windows.first {
                    AppManager.shared.isAdmin = false
                    AppManager.shared.userInfo = regitedUser
                    window.rootViewController = TabBarViewController()
                }
            }
            
        } else if phoneNumberTextField.text == "admin" && passwordTextField.text == "admin123" {
            LoadingActivity.shared.hideAfter {
                if let window = UIApplication.shared.windows.first {
                    AppManager.shared.isAdmin = true
                    window.rootViewController = TabBarViewController()
                } else {
                    
                    return
                }
            }
            
        } else {
            // show alert invalid
            LoadingActivity.shared.hide()
        }
    }
    
    @IBAction func forgotPasswordButton(_ sender: Any) {
    }
    
    var users: [NSManagedObject] = []
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        titleLabel.text = ""
        var charIndex = 0.0
        let titleText = "METRO SG"
        for letter in titleText {
            print("-")
            print(0.1 * charIndex)
            print(letter)
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) {(timer) in
                self.titleLabel.text?.append(letter)
            }
            charIndex += 1
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.fetchDataFormDB()
    }
    
    func fetchDataFormDB() {
        //1
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "UserInfo")
        
        //3
        do {
            users = try managedContext.fetch(fetchRequest)
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
    func setupUI() {
        self.loginButton.isEnabled = false
        Utilities.styleFilledButton(loginButton)
        Utilities.styleHollowButton(registerButton)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
