
import UIKit
import CoreData

class profileViewController: UIViewController {

    //MARK: - Outlets, Actions
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var nametxt: UITextField!
    @IBOutlet weak var addresstxt: UITextField!
    @IBOutlet weak var emailtxt: UITextField!
    @IBOutlet weak var phoneNumbertxt: UITextField!
    
    @IBAction func touchLogoutButton(_ sender: Any) {
        if let window = UIApplication.shared.windows.first {
            AppManager.shared.isAdmin = false
            window.rootViewController = UINavigationController(rootViewController: LoginViewController())
        }
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Profile"
        
        self.autolayoutImageView()
        self.autolayoutButton()
        if AppManager.shared.isAdmin {
            //Default Admin's info
            self.nametxt.text = "ADMIN"
            self.addresstxt.text = "TP HCM"
            self.emailtxt.text = "QUYNH@gmail.com"
            self.phoneNumbertxt.text = "0707491367"
        } else {
            if let userInfo = AppManager.shared.userInfo {
                self.fillDataFormDB(model: userInfo)
            } else {
                self.fetchDataFormDB()
            }
        }
        
        Utilities.styleFilledButton(logoutButton)
        
    }

    func autolayoutImageView() {
        userImageView.layer.masksToBounds = true
        userImageView.layer.borderWidth = 1
        userImageView.layer.cornerRadius = 60
        
    }
    
    func autolayoutButton() {
        logoutButton.layer.masksToBounds = true
        //userImageView.layer.borderWidth = 1
        logoutButton.layer.cornerRadius = 20
        
    }
    
    func fetchDataFormDB() {
        var users = [NSManagedObject]()
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
            if let user = users.last {
                self.fillDataFormDB(model: user)
            }
          
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func fillDataFormDB(model: NSManagedObject) {
        // parser data from NSManagedObject
        if let name = model.value(forKey: "name") as? String {
            self.nametxt.text = name
        }
        
        if let address = model.value(forKey: "address") as? String {
            self.addresstxt.text = address
        }
        
        if let email = model.value(forKey: "email") as? String {
            self.emailtxt.text = email
        }
        
        if let phoneNumber = model.value(forKey: "phoneNumber") as? String {
            self.phoneNumbertxt.text = phoneNumber
        }
        
        
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
