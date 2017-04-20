//
//  ViewController.swift
//  Count Royale
//
//  Created by Nacho Martinez on 18/4/17.
//  Copyright © 2017 Nacho Martinez. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {

    @IBOutlet var mainTabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let deskTabBarItem: UITabBarItem = mainTabBar.items![0]
        let statisticsTabBarItem: UITabBarItem = mainTabBar.items![1]
        
        statisticsTabBarItem.setFAIcon(icon: .FABarChart)
        deskTabBarItem.setFAIcon(icon: .FAUsers)
        
        setCurrentUser()
        
        
    }
    
    func setCurrentUser(){
        FIRAuth.auth()?.signIn(withEmail: "test@gmail.com", password: "test1234", completion: { (user, error) in
            if error != nil {
                print(error!)
//                TODO crear modalAlert para informar del error al usuario
                return
            }
            
//            Successfully init sesion for this user
            print(user!)
        })
    }

}

