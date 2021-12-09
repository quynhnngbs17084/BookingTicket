

import UIKit
import CoreData

class HomeViewController: UIViewController {

    @IBOutlet weak var listTable: UITableView!
    
    var tripList: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Metro Sai Gon"
        self.setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
        self.fetchDataFormDB()
    }
    
    func fetchDataFormDB() {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "TripInfo")
        
        do {
          tripList = try managedContext.fetch(fetchRequest)
          self.listTable.reloadData()
          
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    
    func setupTableView() {
        listTable.register(UINib(nibName: "AdminHomeCell", bundle: nil), forCellReuseIdentifier: "AdminHomeCell")
        listTable.dataSource = self
        listTable.delegate = self
        
        listTable.estimatedRowHeight = 100
        listTable.rowHeight = UITableView.automaticDimension
    }
    
    func deleteTrip(row: Int) {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let route = self.tripList[row]
        managedContext.delete(route)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            
            print("Could not save. \(error), \(error.userInfo)")
        }
    }


    @IBAction func AddTrips(_ sender: Any) {
        self.navigationController?.pushViewController(AddTripsVC(), animated: true)
    }
}

//MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tripList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTable.dequeueReusableCell(withIdentifier: "AdminHomeCell", for: indexPath) as! AdminHomeCell
        cell.fillDataFormDB(model: self.tripList[indexPath.row])
        return cell

    }
    
    
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // show alert to confirm
            let alert = UIAlertController(title: "Delete route", message: "Are you sure delete this route?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .destructive) { (action) in
                self.deleteTrip(row: indexPath.row)
                self.tripList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
}
