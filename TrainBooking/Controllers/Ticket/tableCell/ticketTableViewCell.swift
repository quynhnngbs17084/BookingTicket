
import UIKit
import CoreData

class ticketTableViewCell: UITableViewCell {

    @IBOutlet weak var ticketView: UIView!
    @IBOutlet weak var departureLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var scheduleLabel: UILabel!
    @IBOutlet weak var ticketTypeLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }

    func fillData(data: NSManagedObject) {
        if let from = data.value(forKey: "departure") as? String {
            self.departureLabel.text = from
        }
        
        if let to = data.value(forKey: "destination") as? String {
            self.destinationLabel.text = to
        }
        
        if let startTime = data.value(forKey: "startTime") as? String {
            self.scheduleLabel.text = startTime
        }
        
        if let quantity = data.value(forKey: "quantity") as? Int {
            self.quantityLabel.text = "\(quantity)"
        }
        
        if let type = data.value(forKey: "ticketType") as? Int {
            let ticketType = TicketType(rawValue: type)
            self.ticketTypeLabel.text = ticketType?.title
        }
        
        if let total = data.value(forKey: "bookingTotal") as? Int {
            self.totalLabel.text = "\(total)"
        }
        
    }
    
    func setupView() {
        ticketView.layer.borderWidth = 2
        ticketView.layer.borderColor = UIColor.black.cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
