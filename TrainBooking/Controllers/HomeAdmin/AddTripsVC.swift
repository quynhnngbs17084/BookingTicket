

import UIKit
import CoreData

class AddTripsVC: UIViewController {
    
    //MARK: - Outlets, Action
    @IBOutlet weak var departureTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var ticketTypeTextField: UITextField!
    
    @IBOutlet weak var ticketOfType: UIStackView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBAction func touchSaveInfo(_ sender: Any) {
        LoadingActivity.shared.showLoadding {_ in
            self.save()
        }
    }
    
    @IBAction func dayTicketButton(_ sender: Any) {
        self.ticketTypeTextField.text = "Round Trip Ticket"
        self.ticketType = 2
    }
    @IBAction func monthTicketButton(_ sender: Any) {
        self.ticketTypeTextField.text = "Monthly Ticket"
        self.ticketType = 3
    }
    @IBAction func onewayTicketButton(_ sender: Any) {
        self.ticketTypeTextField.text = "One - way Ticket"
        self.ticketType = 1
    }
    
    @IBAction func ticketTypeAction(_ sender: Any) {
        ticketOfType.isHidden = false
    }
    @IBAction func ticketTypeActionEnd(_ sender: Any) {
        ticketOfType.isHidden = true
    }
    
    //MARK: Variables
    var ticketType: Int? = 1
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Add Route"
        saveButton.layer.cornerRadius = 20
        saveButton.layer.borderWidth = 1
        
        Utilities.styleFilledButton(saveButton)
        
    }
    
    //save train trip information
    func save() {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "TripInfo",
                                       in: managedContext)!
        
        let trip = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
        
        // 3
        guard let departure = self.departureTextField.text, !departure.isEmpty else { return }
        trip.setValue(departure, forKeyPath: "departure")
        
        guard let destination = self.destinationTextField.text, !destination.isEmpty else { return }
        trip.setValue(destination, forKey: "destination")
        
        trip.setValue(self.datePicker.date.fullTimeString, forKey: "startTime")
        
        guard let price = self.priceTextField.text, !price.isEmpty else { return }
        trip.setValue(price, forKey: "price")
        
        guard let ticketType = self.ticketType else { return }
        trip.setValue(ticketType, forKey: "ticketType")
        
        var tripID = AppManager.shared.lastTripID
        trip.setValue(tripID, forKey: "tripID")
        AppManager.shared.lastTripID += 1
        
//        var tripID = AppManager.shared.lastTripID
//        trip.setValue(tripID, forkey: "tripID")
//        tripID += 1
        
        // 4
        do {
            try managedContext.save()
            // clear current input
            self.showAlert()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Successfully added route", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.departureTextField.text = nil
            self.destinationTextField.text = nil
            self.priceTextField.text = nil
            self.ticketTypeTextField.text = nil
        }
        alert.addAction(okAction)
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
}
