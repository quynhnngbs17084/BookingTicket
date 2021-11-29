
import UIKit
import CoreData

class UserHomeViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var userHomeTable: UITableView!
    @IBOutlet weak var departureTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var searchButton: UIButton!
    
    //MARK: - Variables
    var tripList: [NSManagedObject] = []
    var filterData: [NSManagedObject] = []
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Metro Sai Gon"
        
        userHomeTable.register(UINib(nibName: "AdminHomeCell", bundle: nil), forCellReuseIdentifier: "AdminHomeCell")
        userHomeTable.dataSource = self
        
        self.fetchDataFormDB()
        
        Utilities.styleFilledButton(searchButton)
    }
    
    @IBAction func touchSearchButton(_ sender: Any) {
        //lọc dữ liệu theo điều kiện customer đưa ra
        LoadingActivity.shared.showLoadding {_ in
            self.filterData = self.tripList.filter { ($0.value(forKey: "departure") as! String).withoutDiaracting().contains((self.departureTextField.text ?? "").withoutDiaracting()) || ($0.value(forKey: "destination") as! String).withoutDiaracting().contains((self.destinationTextField.text ?? "").withoutDiaracting()) || (Date($0.value(forKey: "startTime") as? String ?? Date().fullTimeString))?.day == self.datePicker.date.day }
            self.userHomeTable.reloadData()
        }
        
        //let dateString = d
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
            NSFetchRequest<NSManagedObject>(entityName: "TripInfo")
        
        //3
        do {
            tripList = try managedContext.fetch(fetchRequest)
            self.filterData = self.tripList
            self.userHomeTable.reloadData()
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
}
//MARK: - UITableViewDataSource
extension UserHomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = userHomeTable.dequeueReusableCell(withIdentifier: "AdminHomeCell", for: indexPath) as! AdminHomeCell
        cell.fillDataFormDB(model: self.filterData[indexPath.row])
        
        cell.didBuyTicket = {[weak self] quantity in //Closure
            // go to payment screen
            if quantity > 0 {
                let paymentVC = paymentViewController()
                paymentVC.quantityTickets = quantity
                paymentVC.ticketInfo = self?.tripList[indexPath.row]
                self?.navigationController?.pushViewController(paymentVC, animated: true)
                cell.numberticketTxt.text = nil
                self?.view.endEditing(true)
            } else {
                let alert = UIAlertController(title: "Invalid quantity", message: "", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    return
                }
                alert.addAction(okAction)
                self?.navigationController?.present(alert, animated: true, completion: nil)
            }
            
        }
        
        return cell
    }
    
    
}

extension String {
    func withoutDiaracting() -> String {
        return self.folding(options: .diacriticInsensitive, locale: .current)
    }
}
	
