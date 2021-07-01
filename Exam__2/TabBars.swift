//
//  TabBars.swift
//  Exam__2
//
//  Created by Oybek Iskandarov on 5/6/21.
//

import UIKit

class TabBars: UITabBarController {
    
    let defaults = UserDefaults.standard
    var date : Profil_Data?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let home = HomeVC(nibName: "HomeVC", bundle: nil)
        home.tabBarItem.title = "Tasks"
        home.tabBarItem.image = UIImage(systemName: "home")
        
        
        let profil = Profil(nibName: "Profil", bundle: nil)
        profil.tabBarItem.title = "Tasks"
        profil.tabBarItem.image = UIImage(named: "icon")
        self.viewControllers = [home, profil]
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
    }
    
    
}
