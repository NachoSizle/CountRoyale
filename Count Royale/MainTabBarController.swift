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
        let deckTabBarItem: UITabBarItem = mainTabBar.items![0]
        let statisticsTabBarItem: UITabBarItem = mainTabBar.items![1]
        
        statisticsTabBarItem.setFAIcon(icon: .FABarChart)
        deckTabBarItem.setFAIcon(icon: .FAUsers)
        
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
            print("Init session successfully")
        })
    }

}

extension UIView {
    func setBorderForColor(color: UIColor, width: Float, radius: Float) {
        self.layer.cornerRadius = CGFloat(radius)
        self.layer.masksToBounds = true
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = CGFloat(width)
    }
    
    func startLoading(title: String) {
        let w = frame.size.width
        let h = frame.size.height
        let loadingView = LoadingView(frame: CGRect(x: 150, y: 150, width: w/2 - 75, height: h/2 - 75))
        loadingView.title = title
        
        addSubview(loadingView)
        isUserInteractionEnabled = false
    }
    
    func stopLoading() {
        for v in subviews {
            if v.isMember(of: LoadingView.self) {
                v.removeFromSuperview()
            }
        }
        
        isUserInteractionEnabled = true
    }
    
}


