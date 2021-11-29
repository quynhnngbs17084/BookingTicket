
import Foundation
import UIKit

enum MTabbarItem {
    case home
    case tickets
    case info
    
    var allValue: [UIViewController] {
        return [MTabbarItem.home.vc, MTabbarItem.tickets.vc, MTabbarItem.info.vc ]
    }
    
    var title : String {
        switch self {
        
        case .home:
            return "Home"
        case .tickets:
            return "Ticket"
        case .info:
            return "Profile"
        }
    }
    
    var item : UITabBarItem {
        switch self {
        
        case .home:
            return UITabBarItem(title: self.title, image: UIImage(named: "icons8-home-off")?.withRenderingMode(.alwaysTemplate), selectedImage: UIImage(named: "icons8-home-on")?.withRenderingMode(.alwaysTemplate))
        case .tickets:
            return UITabBarItem(title: self.title, image: UIImage(named: "icons8-ticket-off")?.withRenderingMode(.alwaysTemplate), selectedImage: UIImage(named: "icons8-ticket-on")?.withRenderingMode(.alwaysTemplate))
        case .info:
            return UITabBarItem(title: self.title, image: UIImage(named: "icons8-customer-off")?.withRenderingMode(.alwaysTemplate), selectedImage: UIImage(named: "icons8-customer-on")?.withRenderingMode(.alwaysTemplate))
        }
    }
    
    var vc : UIViewController {
        switch self {
        
        case .home:
            var viewController: UIViewController
            if AppManager.shared.isAdmin {
                viewController = HomeViewController()
            } else {
                viewController = UserHomeViewController()
            }
            viewController.view.backgroundColor = .yellow
            viewController.tabBarItem = self.item
            let nv = UINavigationController(rootViewController: viewController)
            return nv
        case .tickets:
            let viewController = ticketViewController()
            viewController.view.backgroundColor = .orange
            viewController.tabBarItem = self.item
            let nv = UINavigationController(rootViewController: viewController)
            return nv
        case .info:
            let viewController = profileViewController()
            viewController.view.backgroundColor = .cyan
            viewController.tabBarItem = self.item
            let nv = UINavigationController(rootViewController: viewController)
            return nv
        }
    }
    
}
