
import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initTabBar()
        
    }

    func initTabBar() {
        if AppManager.shared.isAdmin {
            self.viewControllers = [MTabbarItem.home.vc, MTabbarItem.info.vc]
        } else {
            self.viewControllers = [MTabbarItem.home.vc, MTabbarItem.tickets.vc, MTabbarItem.info.vc]
        }
        
    }
}
