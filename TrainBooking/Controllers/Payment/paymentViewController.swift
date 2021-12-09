
import UIKit
import CoreData

class paymentViewController: UIViewController {
    
    @IBOutlet weak var departure: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var schedule: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var ticketType: UILabel!
    @IBOutlet weak var total: UILabel!
    
    @IBOutlet weak var OKbutton: UIButton!
    
    var quantityTickets: Int!
    var ticketInfo: NSManagedObject!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Booking Ticket"
        self.layoutOKbutton()
        self.fillData()
        
        Utilities.styleFilledButton(OKbutton)
    }
    
    @IBAction func touchOKButton(_ sender: Any) {
        LoadingActivity.shared.showLoadding {_ in
            let alert = UIAlertController(title: "Booking Successfully", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                //save customer's ticket information
                self.save()
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(okAction)
            self.navigationController?.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    func layoutOKbutton() {
        OKbutton.layer.borderWidth = 1
        OKbutton.layer.cornerRadius = 20
        
    }
    
    //show data from DB
    func fillData() {
        if let departure = ticketInfo.value(forKey: "departure") as? String {
            self.departure.text = departure
        }
        
        if let destination = ticketInfo.value(forKey: "destination") as? String {
            self.destination.text = destination
        }
        
        if let startTime = ticketInfo.value(forKey: "startTime") as? String {
            self.schedule.text = startTime
        }
        
        self.quantity.text = String(quantityTickets)
        
        if let price = ticketInfo.value(forKey: "price") as? String {
            self.total.text = String(describing: (Int(price) ?? 0) * self.quantityTickets)
        }
        
        if let type = ticketInfo.value(forKey: "ticketType") as? Int {
            let ticketType = TicketType(rawValue: type)
            self.ticketType.text = ticketType?.title
        }
    }
    
    //save customer's ticket information
    func save() {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext =
            appDelegate.persistentContainer.viewContext

        let entity =
            NSEntityDescription.entity(forEntityName: "MyTicketInfo",
                                       in: managedContext)!
        
        let ticket = NSManagedObject(entity: entity,
                                   insertInto: managedContext)

        guard let departure = self.departure.text, !departure.isEmpty else { return }
        ticket.setValue(departure, forKeyPath: "departure")
        
        guard let destination = self.destination.text, !destination.isEmpty else { return }
        ticket.setValue(destination, forKey: "destination")
        
        guard let schedule = self.schedule.text, !schedule.isEmpty else { return }
        ticket.setValue(self.schedule.text, forKey: "startTime")
        
        guard let quantity = Int(self.quantity.text ?? "") else { return }
        ticket.setValue(quantity, forKey: "quantity")
        
        guard let ticketType = self.ticketInfo.value(forKey: "ticketType") else {return}
        ticket.setValue(ticketType, forKey: "ticketType")
        
        guard let total = Int(self.total.text ?? "") else { return }
        ticket.setValue(total, forKey: "bookingTotal")
        
        let currentUserID = AppManager.shared.userInfo?.value(forKey: "userID") as! Int
        ticket.setValue(currentUserID, forKey: "purchaseUserID")

        do {
            try managedContext.save()
            self.updateTotalTrip(tripID: self.ticketInfo.value(forKey: "tripID") as! Int, quantity: self.quantityTickets)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func updateTotalTrip(tripID: Int, quantity: Int) {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
          appDelegate.persistentContainer.viewContext

        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "TripInfo")

        do {
          let trips = try managedContext.fetch(fetchRequest)
            if let trip = (trips.filter { $0.value(forKey: "tripID") as! Int == tripID}).first {
                let oldValue = trip.value(forKey: "bookingTotal") as! Int
                trip.setValue(oldValue + quantity, forKey: "bookingTotal")
                
                do {
                    try managedContext.save()
                }  catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
          
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
