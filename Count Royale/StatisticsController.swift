//
//  StatisticsController.swift
//  Count Royale
//
//  Created by Nacho Martinez on 18/4/17.
//  Copyright © 2017 Nacho Martinez. All rights reserved.
//

import UIKit
import Firebase

class StatisticsController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var cardCollectionView: UICollectionView!
    
    let nameCards: [String] = ["Arqueras", "Barbaros", "BarbarosDeElite", "Bombardero", "Caballero", "Canion", "Descarga", "Duendes", "DuendesConLanza", "Esbirros", "EspiritusDeFuego", "EspirituDeHielo", "Esqueletos", "Flechas", "GiganteNoble", "HordaDeEsbirros", "Mortero", "PandillaDeDuendes", "TorreTesla"]
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Select a card"
        lbl.font = UIFont(name: lbl.font.fontName, size: 30)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.cardCollectionView.delegate = self
        self.cardCollectionView.dataSource = self
        
        view.addSubview(self.titleLabel)
        
        setTitleLabelInView()
        
        let layout = cardCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsetsMake(100, 15, 70, 15);
        layout.minimumInteritemSpacing = 5; // this number could be anything <=5. Need it here because the default is 10.
        let widthScreen: CGFloat = cardCollectionView.frame.size.width
        layout.itemSize = CGSize(width: (widthScreen - 20)/3, height: 100) // 20 is 2*5 for the 2 edges plus 2*5 for the spaces between the cells
    }
    
    func setTitleLabelInView(){
        
        let widthScreen: CGFloat = (cardCollectionView.frame.size.width)/2
        let widthLblTitle: CGFloat = (titleLabel.frame.size.width)/2
        
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: widthScreen - widthLblTitle).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 25).isActive = true
        
        titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.nameCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cardCollectionView.dequeueReusableCell(withReuseIdentifier: "CardViewCell", for: indexPath) as! CardsCollectionViewCell
        
        let index = indexPath.row
        
        let storageRef = FIRStorage.storage().reference()

        
        if ((FIRAuth.auth()?.currentUser?.uid) != nil) {
            
            let ref = storageRef.child("Cards").child("Common").child(self.nameCards[index] + ".png")
                
                ref.downloadURL(completion: { (url, error) in
                    
                    if error != nil {
                        print(error!.localizedDescription)
                        return
                    }
                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                        
                        if error != nil {
                            print(error!)
                            return
                        }
                        
                        guard let imageData = UIImage(data: data!) else { return }
                        
                        print(imageData)
                        
                        DispatchQueue.main.async {
                            cell.imgCardView.image = imageData
                        }
                    }).resume()
            })
            
        } else {
            print("Does not permission")
        }
        
        cell.imgCardView.contentMode = .scaleAspectFit
        
        return cell
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}


