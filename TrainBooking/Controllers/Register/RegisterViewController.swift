
import UIKit
import CoreData

class RegisterViewController: UIViewController {

    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBAction func touchBackButton(_ sender: Any) {
        
        if let vcs = self.navigationController?.viewControllers.count, vcs > 1  {
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func fullnameTyping(_ sender: Any) {
        self.registerButton.isEnabled = self.checkInput()
    }
    
    @IBAction func addressTyping(_ sender: Any) {
        self.registerButton.isEnabled = self.checkInput()
    }
    
    @IBAction func emailTyping(_ sender: Any) {
        self.registerButton.isEnabled = self.checkInput()
    }
    
    @IBAction func phoneNumberTyping(_ sender: Any) {
        self.registerButton.isEnabled = self.checkInput()
    }
    
    @IBAction func passwordTyping(_ sender: Any) {
        self.registerButton.isEnabled = self.checkInput()
    }
    
    @IBAction func touchRegisterButton(_ sender: Any) {
        
        LoadingActivity.shared.show()
        self.save()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        Utilities.styleFilledButton(registerButton)
    }

    func setupUI() {
        self.registerButton.isEnabled = false
    }
    
    func checkInput() -> Bool {
        
        guard let fullname = self.fullnameTextField.text, !fullname.isEmpty else {
            //!fullname.isEmpty ~ fullname.isEmpty == false
            return false
        }
        
        guard let address = self.addressTextField.text, !address.isEmpty else {
            return false
        }
        
        guard let email = self.emailTextField.text, !email.isEmpty else {
            return false
        }
        
        guard let phoneNumber = self.phoneNumberTextField.text, !phoneNumber.isEmpty else {
            return false
        }
        
        guard let password = self.passwordTextField.text, !password.isEmpty else {
            return false
        }
        
        return true
    }

    func save() {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext =
            appDelegate.persistentContainer.viewContext

        let entity =
            NSEntityDescription.entity(forEntityName: "UserInfo",
                                       in: managedContext)!
        
        let user = NSManagedObject(entity: entity,
                                   insertInto: managedContext)

        guard let name = self.fullnameTextField.text, !name.isEmpty else { return }
        user.setValue(name, forKeyPath: "name")
        
        guard let address = self.addressTextField.text, !address.isEmpty else { return }
        user.setValue(address, forKey: "address")
        
        guard let email = self.emailTextField.text, !email.isEmpty else { return }
        user.setValue(email, forKey: "email")
        
        guard let phoneNumber = self.phoneNumberTextField.text, !phoneNumber.isEmpty else { return }
        user.setValue(phoneNumber, forKey: "phoneNumber")
        
        guard let password = self.passwordTextField.text, !password.isEmpty else { return }
        user.setValue(password, forKey: "password")
        
        user.setValue(AppManager.shared.userID, forKey: "userID")
        AppManager.shared.userID += 1

        do {
            try managedContext.save()
            LoadingActivity.shared.hideAfter {
                let alert = UIAlertController(title: "Register Successful", message: "Login please!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(okAction)
                self.navigationController?.present(alert, animated: true, completion: nil)
            }
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

}
