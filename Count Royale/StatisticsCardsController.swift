//
//  StatisticsCardsController.swift
//  Count Royale
//
//  Created by Nacho Martinez on 25/4/17.
//  Copyright © 2017 Nacho Martinez. All rights reserved.
//

import UIKit

class StatisticsCardsController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var typesCardCollectionView: UICollectionView!
    
    private let arrTypesCards: [String] = ["Common", "Specials", "Epic", "Legendaries"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "backgroundCountRoyalex3.jpg"))

        self.typesCardCollectionView.delegate = self
        self.typesCardCollectionView.dataSource = self
        
        let screenSize: CGSize = typesCardCollectionView.frame.size
        let widthScreen: CGFloat = screenSize.width
        let heightScreen: CGFloat = screenSize.height
        
        let layout = typesCardCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsetsMake(heightScreen / 5, widthScreen / 5, 70, widthScreen / 5)
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (widthScreen - 20)/3, height: 100)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    lazy var didCollectionViewCellSelect: ((Int) -> Void)? = { (collectionViewCellSelected) in
        self.performSegue(withIdentifier: "showCardInDetail", sender: collectionViewCellSelected)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        let destination = segue.destination
        
        if let collectionViewCellSelected = sender as? CardsCollectionViewCell {
            let indexOfCellSelected = self.typesCardCollectionView.indexPath(for: collectionViewCellSelected)
            
            (destination as! StatisticsController).arrToDownloadAllPhotos = arrTypesCards[(indexOfCellSelected?.row)!]
            (destination as! StatisticsController).navigationItem.title = "Select card"
        }
    }
 

    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 140)
    }
    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = typesCardCollectionView.dequeueReusableCell(withReuseIdentifier: "TypeCardViewCell", for: indexPath) as! CardsCollectionViewCell
    
        // Configure the cell
        cell.imgCardView.image = UIImage(named: arrTypesCards[indexPath.row])
        cell.imgCardView.contentMode = .scaleToFill
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected: ")
        _ = collectionView.cellForItem(at: indexPath) as! CardsCollectionViewCell
        print(indexPath.row)
    }

}
