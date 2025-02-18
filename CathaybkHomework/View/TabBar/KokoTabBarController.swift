//
//  TabBarController.swift
//  CathaybkHomework
//
//  Created by YUNJU on 2025/2/18.
//

import UIKit

class KokoTabBarController : UITabBarController {
    
    override func viewDidLoad() {
        setupTabBarParam()
        setupDivider()
        setupViewController()
        setupInsets()
    }
    
}

extension KokoTabBarController {
    
    /** 初始設定 TabBar */
    func setupTabBarParam() {
        tabBar.tintColor = UIColor(named: "tabSelectedColor")
    }
    
    /** 添加水平線 */
    func setupDivider() {
        let borderView = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 1))
        borderView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1) // 設定線條顏色
        borderView.autoresizingMask = .flexibleWidth // 適應螢幕寬度
        tabBar.addSubview(borderView)
    }
    
    /** 設定各個 View */
    func setupViewController() {
        
        // 錢錢
        let moneyVC = MoneyPageViewController()
        moneyVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icTabbarProductsOff"), tag: 0)
        
        // 朋友
        let friendVC = FriendPageViewController()
        friendVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icTabbarFriendsOn"), tag: 1)
        
        // KOKO
        let kokoVC = UIViewController()
        kokoVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icTabbarHomeOff"), tag: 2)
        
        // 記帳
        let trackVC = TrackSpendingPageViewController()
        trackVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icTabbarManageOff"), tag: 3)
        // 設定
        let setting = SettingPageViewController()
        setting.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icTabbarSettingOff"), tag: 4)
        
        viewControllers = [
            UINavigationController(rootViewController: moneyVC),
            UINavigationController(rootViewController: friendVC),
            UINavigationController(rootViewController: kokoVC),
            UINavigationController(rootViewController: trackVC),
            UINavigationController(rootViewController: setting),
        ]
    }
    
    /** 調整 Insets */
    func setupInsets() {
        if let items = self.tabBar.items {
            for (index, item) in items.enumerated() {
                // 區分 koko view 的 insets
                let top = (index == 2) ? -22.0 : 5.0
                let bottom = (index == 2) ? -15.0 : 0.0
                
                item.imageInsets = UIEdgeInsets(
                    top: top,
                    left: 0,
                    bottom: bottom,
                    right: 0
                )
            }
        }
    }
}
