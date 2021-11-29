
import Foundation


class TrainInfoModel {
    var departure: String?
    var destination: String?
    var time: String?
    var price: String?
    var type: TicketType?
    
    init(departure: String, destination: String, time: String, price: String, type: TicketType) {
        self.departure = departure
        self.destination = destination
        self.time = time
        self.type = type
        self.price = price
    }
}
