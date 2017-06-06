//
//  StatisticsController.swift
//  Count Royale
//
//  Created by Nacho Martinez on 18/4/17.
//  Copyright © 2017 Nacho Martinez. All rights reserved.
//

import UIKit
import Firebase

class StatisticsController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIViewControllerPreviewingDelegate {
    
    @IBOutlet var cardCollectionView: UICollectionView!
    
    let nameCommonCards: [String] = ["Arqueras", "Barbaros", "BarbarosDeElite", "Bombardero", "Caballero", "Canion", "Descarga", "Duendes", "DuendesConLanza", "Esbirros", "EspiritusDeFuego", "EspirituDeHielo", "Esqueletos", "Flechas", "GiganteNoble", "HordaDeEsbirros", "Mortero", "PandillaDeDuendes", "TorreTesla"]
    
    let nameSpecialCards: [String] = ["ArieteDeBatalla", "BolaDeFuego", "ChozaDeBarbaros", "ChozaDeDuendes", "Cohete", "Curacion", "Gigante", "GolemDeHielo", "Horno", "Lanzadardos", "Lapida", "Mago", "MegaEsbirro", "MiniPekka", "Montapuercos", "Mosquetera", "RecolectorDeElixir", "TorreBombardera", "TorreInfernal", "TrioDeMosqueteras", "Valquiria"]
    
    let nameEpicCards: [String] = ["Ballesta", "BarrilDeDuendes", "BebeDragon", "Bruja", "Clon", "EjercitoDeEsqueletos", "Espejo", "EsqueletoGigante", "Furia", "Globo", "Golem", "Guardias", "Hielo", "Lanzarrocas", "P.E.K.K.A.", "PrincipeOscuro", "Principe", "Rayo", "Tornado", "Veneno", "Verdugo"]
    
    let nameLegendaryCards: [String] = ["Bandida", "BrujaNocturna", "Cementerio", "Chispitas", "DragonInfernal", "Tronco", "Leniador", "MagoDeHielo", "MagoElectrico", "Minero", "Princesa", "SabuesoDeLava"]
    
    var arrToDownloadAllPhotos: String = ""
    var arrToUse: [String] = []
    var imageDownloaded: UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

        print("Array to download all photos")
        print(arrToDownloadAllPhotos)
        
        switch arrToDownloadAllPhotos {
            case "Common":
                arrToUse = self.nameCommonCards
            case "Specials":
                arrToUse = self.nameSpecialCards
            case "Epic":
                arrToUse = self.nameEpicCards
            case "Legendaries":
                arrToUse = self.nameLegendaryCards
                self.cardCollectionView.isScrollEnabled = false
            default:
                arrToUse = self.nameCommonCards
        }
        
        
        print("Array to use")
        print(arrToUse)

        // Do any additional setup after loading the view.
        self.cardCollectionView.delegate = self
        self.cardCollectionView.dataSource = self
        
        let layout = cardCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let widthScreen: CGFloat = cardCollectionView.frame.size.width
        
        layout.sectionInset = UIEdgeInsetsMake(20, 15, 20, 0);
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (widthScreen - 20)/3, height: 100)
        
        if traitCollection.forceTouchCapability == UIForceTouchCapability.available {
            registerForPreviewing(with: self, sourceView: cardCollectionView)
        } else {
            print("Not compatible with 3dTouch")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrToUse.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cardCollectionView.dequeueReusableCell(withReuseIdentifier: "CardViewCell", for: indexPath) as! CardsCollectionViewCell
        
        let index = indexPath.row
        
        let storageRef = FIRStorage.storage().reference()
        
        
        if ((FIRAuth.auth()?.currentUser?.uid) != nil) {
            
            let ref = storageRef.child("Cards").child(arrToDownloadAllPhotos).child(arrToUse[index] + ".png")
                
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
    
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        let indexSelectedRow = self.cardCollectionView.indexPathForItem(at: location)?.row
        
        print(arrToUse[indexSelectedRow!])
        
        
        let peekController = UIViewController()
        
        let nameOfCard:String = arrToUse[indexSelectedRow!]
        let nameOfType:String = arrToDownloadAllPhotos
        
        print("Loading..")
        
        let storageRef = FIRStorage.storage().reference()
        
        if ((FIRAuth.auth()?.currentUser?.uid) != nil) {
            
            let ref = storageRef.child("Cards").child("Description").child(nameOfType).child(nameOfCard + ".png")
            
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
                        peekController.view.backgroundColor = UIColor(patternImage: imageData)
                    }
                    
                }).resume()
            })
            
        } else {
            print("Does not permission")
        }
        
        return peekController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        goToRepo()
    }
    
    func goToRepo(){
        let urlRepo = URL(string: "http://clashroyale.wikia.com/wiki/")
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(urlRepo!)
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        let destination = segue.destination
        
        (destination as! StatisticsCardsDetailViewController).view.startLoading(title: "Loading")
        
        if let collectionViewCellSelected = sender as? CardsCollectionViewCell {
            let indexOfCellSelected = self.cardCollectionView.indexPath(for: collectionViewCellSelected)
            let nameOfCard:String = self.arrToUse[(indexOfCellSelected?.row)!]
            let nameOfType:String = arrToDownloadAllPhotos
            
            let storageRef = FIRStorage.storage().reference()
            
            if ((FIRAuth.auth()?.currentUser?.uid) != nil) {
                
                let ref = storageRef.child("Cards").child("Description").child(nameOfType).child(nameOfCard + ".png")
                
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
                            (destination as! StatisticsCardsDetailViewController).imgViewCardDetail.image = imageData
                            (destination as! StatisticsCardsDetailViewController).imgViewCardDetail.contentMode = .scaleAspectFill
                            (destination as! StatisticsCardsDetailViewController).view.stopLoading()
                        }
                    }).resume()
                })
                
            } else {
                print("Does not permission")
            }
        }
    }
}


