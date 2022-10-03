
import UIKit
import CoreText

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.backgroundColor = .white
        self.delegate = self
        setupTabBar()
        tabBarOrange()
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        let tabBarIndex = tabBarController.selectedIndex
        
        if tabBarIndex == 0 {
            tabBarOrange()
        } else if tabBarIndex == 1 {
            tabBarBlue()
        }
    }
    
    func tabBarOrange() {
        self.tabBar.tintColor = UIColor(red: 255/255, green: 129/255, blue: 75/255, alpha: 1)
    }
    
    func tabBarBlue() {
        self.tabBar.tintColor = UIColor(red: 75/255, green: 136/255, blue: 255/255, alpha: 1)
    }
    
    func setupTabBar() {
        
        let reviewsViewController = createNavController(vc: ReviewsViewController(), itemName: "Reviews", itemImage: "icon_review")
        
        let criticsViewController = createNavController(vc: CriticsViewController(), itemName: "Critics", itemImage: "icon_critic")
        
        viewControllers = [reviewsViewController, criticsViewController]
    }
    
    func createNavController(vc: UIViewController, itemName: String, itemImage: String) -> UINavigationController {
        
        let item = UITabBarItem(title: itemName, image: UIImage(named: itemImage), tag: 0)
        
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem = item
        
        return navController
    }
}
