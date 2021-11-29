
import UIKit
import CoreData

enum TicketType: Int {
    case oneTime = 1
    case day = 2
    case month = 3
    
    
    var color: UIColor {
        switch self {
        case.oneTime:
            return .blue
        case .day:
            return .green
        case .month:
            return .purple
        }
    }
    
    var title: String {
        switch self {
        case .oneTime:
            return "One - way Ticket"
        case .day:
            return "Round Trip Ticket"
        case .month:
            return "Monthly Ticket"
        }
    }
}

class AdminHomeCell: UITableViewCell {

    //MARK: - Outlets, Actions
    @IBOutlet weak var departureLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ticketTypeLabel: UILabel!
    
    @IBOutlet weak var bookingTotalStackView: UIStackView!
    @IBOutlet weak var bookingTotalLabel: UILabel!
    
    @IBOutlet weak var buyView: UIView! {
        didSet {
            self.buyView.isHidden = AppManager.shared.isAdmin
        }
    }
    @IBOutlet weak var numberticketTxt: UITextField!

    
    @IBAction func buyTicket(_ sender: Any) {
        if let quantity = Int(self.numberticketTxt.text ?? "") {
            self.didBuyTicket?(quantity)
        }
    }
    
    
    //MARK: - Variables
    var didBuyTicket: ((Int) -> Void)?
    
    //MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(model: TrainInfoModel) {
        self.departureLabel.text = model.departure
        self.destinationLabel.text = model.destination
        self.startTimeLabel.text = model.time
        self.priceLabel.text = model.price ?? "0" + " VND"
        self.contentView.backgroundColor = model.type?.color
    }
    
    func fillDataFormDB(model: NSManagedObject) {
        // parser data from NSManagedObject
        if let departure = model.value(forKey: "departure") as? String {
            self.departureLabel.text = departure
        }
        
        if let destination = model.value(forKey: "destination") as? String {
            self.destinationLabel.text = destination
        }
        
        if let startTime = model.value(forKey: "startTime") as? String {
            self.startTimeLabel.text = startTime
        }
        
        if let price = model.value(forKey: "price") as? String {
            self.priceLabel.text = price
        }
        
        if let type = model.value(forKey: "ticketType") as? Int {
            let ticketType = TicketType(rawValue: type)
            self.ticketTypeLabel.text = ticketType?.title
        }
        
        if let total = model.value(forKey: "bookingTotal") as? Int, AppManager.shared.isAdmin {
            self.bookingTotalLabel.text = String(total)
        } else {
            self.bookingTotalStackView.isHidden = true
        }
        
    }
    
}
