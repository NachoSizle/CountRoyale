//
//  StatisticsCardsDetailViewController.swift
//  Count Royale
//
//  Created by Nacho Martinez on 11/5/17.
//  Copyright © 2017 Nacho Martinez. All rights reserved.
//

import UIKit
import Firebase

class StatisticsCardsDetailViewController: UIViewController {
    
    @IBOutlet var imgViewCardDetail: UIImageView!
    @IBOutlet var btnShowMoreInfo: UIButton!
    @IBAction func goToMoreInfo(_ sender: UIButton) {
        goToRepo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "backgroundCountRoyalex3.jpg"))
        btnShowMoreInfo.layer.cornerRadius = 20
        btnShowMoreInfo.setBorderForColor(color: .gray, width: 3.0, radius: 20)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fillViewToComponents(imgToFill: UIImage) {
        self.imgViewCardDetail = UIImageView()
        self.imgViewCardDetail?.image = imgToFill
        self.imgViewCardDetail.contentMode = .scaleAspectFill
    }
    
    func goToRepo(){
        let urlRepo = URL(string: "http://clashroyale.wikia.com/wiki")
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(urlRepo!)
        } else {
            // Fallback on earlier versions
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
