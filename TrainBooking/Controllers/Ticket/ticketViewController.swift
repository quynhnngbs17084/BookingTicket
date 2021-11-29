
import UIKit
import CoreData

class ticketViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var ticketTable: UITableView!
    
    //MARK: - Variables
    var ticketList: [NSManagedObject] = []
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "My ticket"
        
        ticketTable.register(UINib(nibName: "ticketTableViewCell", bundle: nil), forCellReuseIdentifier: "ticketTableViewCell")
        ticketTable.dataSource = self
        
        
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
          NSFetchRequest<NSManagedObject>(entityName: "MyTicketInfo")
        
        //3
        do {
            let currentUserID = AppManager.shared.userInfo?.value(forKey: "userID") as! Int
            ticketList = try managedContext.fetch(fetchRequest).filter{ ($0.value(forKey: "purchaseUserID") as! Int) == currentUserID}
          self.ticketTable.reloadData()
          
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
}
//MARK: - UITableViewDataSource
extension ticketViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ticketList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = ticketTable.dequeueReusableCell(withIdentifier: "ticketTableViewCell", for: indexPath) as! ticketTableViewCell
        cell.fillData(data: self.ticketList[indexPath.row])
        
        return cell
        
    }
    
}
