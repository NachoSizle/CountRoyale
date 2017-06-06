//
//  DesksController.swift
//  Count Royale
//
//  Created by Nacho Martinez on 18/4/17.
//  Copyright © 2017 Nacho Martinez. All rights reserved.
//

import UIKit
import Firebase

class DecksController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var btnRandomDeck: UIButton!
    @IBOutlet var cardDeckCollectionView: UICollectionView!
    
    @IBAction func getRandomDeck(_ sender: UIButton) {
        getRandomDeckToShow()
    }
    @IBOutlet var lblMyDecks: UILabel!
    @IBOutlet var imgFace: UIImageView!
    @IBOutlet var averageLbl: UILabel!
    @IBOutlet var numAverageLbl: UILabel!
    @IBOutlet var imgGota: UIImageView!
    
    let nameCommonCards: [String] = ["Arqueras", "Barbaros", "BarbarosDeElite", "Bombardero", "Caballero", "Canion", "Descarga", "Duendes", "DuendesConLanza", "Esbirros", "EspiritusDeFuego", "EspirituDeHielo", "Esqueletos", "Flechas", "GiganteNoble", "HordaDeEsbirros", "Mortero", "PandillaDeDuendes", "TorreTesla"]
    
    let nameSpecialCards: [String] = ["ArieteDeBatalla", "BolaDeFuego", "ChozaDeBarbaros", "ChozaDeDuendes", "Cohete", "Curacion", "Gigante", "GolemDeHielo", "Horno", "Lanzadardos", "Lapida", "Mago", "MegaEsbirro", "MiniPekka", "Montapuercos", "Mosquetera", "RecolectorDeElixir", "TorreBombardera", "TorreInfernal", "TrioDeMosqueteras", "Valquiria"]
    
    let nameEpicCards: [String] = ["Ballesta", "BarrilDeDuendes", "BebeDragon", "Bruja", "Clon", "EjercitoDeEsqueletos", "Espejo", "EsqueletoGigante", "Furia", "Globo", "Golem", "Guardias", "Hielo", "Lanzarrocas", "PEKKA", "PrincipeOscuro", "Principe", "Rayo", "Tornado", "Veneno", "Verdugo"]
    
    let nameLegendaryCards: [String] = ["Bandida", "BrujaNocturna", "Cementerio", "Chispitas", "DragonInfernal", "Tronco", "Leniador", "MagoDeHielo", "MagoElectrico", "Minero", "Princesa", "SabuesoDeLava"]
    
    var arrImagesDownloaded: [UIImage] = []
    var arrNamesImages: [Int] = []
    var countCardsLoaded: Int = 0
    var numAverage: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "backgroundCountRoyalex3.jpg"))
        self.cardDeckCollectionView.backgroundColor = UIColor.clear
        
        self.cardDeckCollectionView.delegate = self
        self.cardDeckCollectionView.dataSource = self
        btnRandomDeck.layer.cornerRadius = 20
        btnRandomDeck.setBorderForColor(color: .gray, width: 3.0, radius: 20)
        lblMyDecks.layer.cornerRadius = 20
        
        imgFace.isHidden = true
        averageLbl.isHidden = true
        numAverageLbl.isHidden = true
        imgGota.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getRandomDeckToShow(){
        print("LOAD")
        
        view.startLoading(title: "Loading")
        
        self.countCardsLoaded = 0
        self.numAverage = 0
        
        self.btnRandomDeck.isEnabled = false
        self.arrNamesImages.removeAll()
        self.arrImagesDownloaded.removeAll()
        
        let arrImagesToDownload = [nameCommonCards, nameSpecialCards, nameEpicCards, nameLegendaryCards]
        var numOfCard: Int = 0
        
        for index in 0...3 {
            for indexNumCard in 0...1 {
                let randomNum:UInt32 = arc4random_uniform(UInt32(arrImagesToDownload[index].count))
                var someInt:Int = Int(randomNum)
                
                if someInt != 0 {
                    someInt -= 1
                }
                
                if someInt < arrImagesToDownload[index].count {
                    someInt += indexNumCard
                } else if someInt > 0{
                    someInt -= indexNumCard
                }
                
                print(someInt)
                
                if numOfCard == 0{
                   arrNamesImages.append(someInt)
                } else {
                    if arrNamesImages.contains(someInt) {
                        someInt = Int(arc4random_uniform(UInt32(arrImagesToDownload[index].count)))
                        if someInt != 0 {
                            someInt -= 1
                        }
                        
                        if someInt < arrImagesToDownload[index].count {
                            someInt += indexNumCard
                        } else if someInt > 0{
                            someInt -= indexNumCard
                        }
                        arrNamesImages.append(someInt)
                    }
                }
                
                
                let nameOfCardToDownload: String = arrImagesToDownload[index][someInt]
                print(nameOfCardToDownload)
                
                var nameOfTypeCard:String = ""
                
                switch index {
                    case 0:
                        nameOfTypeCard = "Common"
                    case 1:
                        nameOfTypeCard = "Specials"
                    case 2:
                        nameOfTypeCard = "Epic"
                    case 3:
                        nameOfTypeCard = "Legendaries"
                    default:
                        nameOfTypeCard = "Common"
                }
                
                let databaseRef = FIRDatabase.database().reference()
                
                let storageRef = FIRStorage.storage().reference()
                
                if ((FIRAuth.auth()?.currentUser?.uid) != nil) {
                    
                    let ref = storageRef.child("Cards").child(nameOfTypeCard).child(nameOfCardToDownload + ".png")
                    let refDatabase = databaseRef.child("Cards").child(nameOfCardToDownload)
                    
                    refDatabase.observeSingleEvent(of: .value, with: { (snapshot) in
                        // Get user value
                        let value = snapshot.value as? NSDictionary
                        let elixirNum = value?["elixirNum"] as! Int
                        
                        self.numAverage += elixirNum
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                    
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
                            
                            DispatchQueue.main.sync {
                                numOfCard += 1
                                self.arrImagesDownloaded.append(imageData)
                                if numOfCard == 8 {
                                    self.btnRandomDeck.isEnabled = true
                                    self.cardDeckCollectionView.reloadData()
                                }
                            }
                        }).resume()
                    })
                    
                } else {
                    print("Does not permission")
                }
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = cardDeckCollectionView.dequeueReusableCell(withReuseIdentifier: "CardDeckViewCell", for: indexPath) as! CardsCollectionViewCell
        
        if arrImagesDownloaded.count == 0 {
            cell.imgCardView.image = #imageLiteral(resourceName: "MysteryCard.png")
        } else {
            cell.imgCardView.image = arrImagesDownloaded[indexPath.row]
            self.countCardsLoaded += 1
            if (self.countCardsLoaded == self.arrNamesImages.count){
                self.view.stopLoading()
                imgFace.isHidden = false
                averageLbl.isHidden = false
                let intToDouble = Double(self.numAverage)*10
                let doubleAux = round(intToDouble/8)/10
                numAverageLbl.text = String(doubleAux)
                numAverageLbl.isHidden = false
                imgGota.isHidden = false
                self.countCardsLoaded = 0
            }
        }
        
        cell.imgCardView.contentMode = .scaleAspectFit
        
        
        
        return cell
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
