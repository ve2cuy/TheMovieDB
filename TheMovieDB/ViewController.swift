//
//  ViewController.swift
//  TheMovieDB
//
//  Created by Alain on 17-06-20.
//  Copyright © 2017 Alain. All rights reserved.
//
// https://safari-extensions.apple.com/details/?id=com.litejs.json-lite-YVKYWJZ9CZ
// https://digitalleaves.com/blog/2016/02/flawless-uicollectionviews-and-uitableviews/

/*
 <key>NSAppTransportSecurity</key>
 <dict>
 <key>NSAllowsArbitraryLoads</key>
 <true/>
 </dict>
 */


import UIKit


class ViewController: UIViewController {
    @IBOutlet var viewIndicateur: UIView!
    @IBOutlet weak var indicateur: UIActivityIndicatorView!
    
    @IBOutlet weak var CVFilms: UICollectionView!
    
    @IBOutlet weak var UIpageCourante: UILabel!
    var actInd = UIActivityIndicatorView()
    var page = 1
    let tmbdAPI = "http://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&api_key=830e7344baa3fd207cfd45739496509d&page="
    
    var films: StructureJSONTheMovieDB!
    
    override func viewDidLoad() { super.viewDidLoad()
        
        indicateur.activityIndicatorViewStyle = .whiteLarge
        view.addSubview(viewIndicateur)
        obtenirDonnéesJSON()
        
    } // viewDidLoad
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Attention: Manque de mémoire ...")
        // Dispose of any resources that can be recreated.
    } // didReceiveMemoryWarning
    
    //#######################################################################
    //MARK:- Mes méthodes
    func obtenirDonnéesJSON(){
        
        if let _données = NSData(contentsOf: URL(string: "\(tmbdAPI)\(page)")!) as Data? {
            // print(String(data: _données, encoding: .utf8))
            let unDécodeur = JSONDecoder()
            let _films = try!unDécodeur.decode(StructureJSONTheMovieDB.self, from: _données)
            
            if page == 1 {  // première lecture de données
                films = _films // Initialiser le tableau de films à partir des données reçues
            } else
            {
              films.results += _films.results  // Ajouter les nouvelles données au tableau des résultats
            } // if page == 1
            
            UIpageCourante.text = "Page: \(page)/\(films.total_pages), nb items: \(films.results.count)"
            
            page += 1
            
            for (index, film) in films.results.enumerated() {
                let i = index + 1
                let titre = film.title ?? "Titre non disponible"
                // let pochette = film.poster_path ?? "Pochette non disponible"
                let backPochette = film.backdrop_path ?? "### backdrop_path non disponible ###"
                print("film \(i) - \(titre), cote: \(film.vote_average ?? 0), backPochette: \(backPochette)")
            } // for in films.results
            
        } // if let
        
    } // obtenirDonnéesJSON
    
} // ViewController

//MARK:- Les extensions
extension ViewController: UITableViewDataSource, UICollectionViewDataSource {
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return films.results.count + 1   // Note: +1 nous permet d'avoir un point de repère pour charger d'autres données
    }
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print("---> Rendu de la cellule numéro \(indexPath.item)")
        
        let cellule = collectionView.dequeueReusableCell(withReuseIdentifier: "modeleA", for: indexPath) as! CelluleFilm
        
        guard indexPath.item != films.results.count else {
            viewIndicateur.isHidden = false
            print("Charger des nouvelles données ...")
            obtenirDonnéesJSON()
            collectionView.reloadData()
            let when = DispatchTime.now() + 0.25 // maintenant + 2 sec
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.viewIndicateur.isHidden = true
            }
            return cellule
        } // guard
        
        let itemCourant = films.results[indexPath.row]
        // Renseigner le nom du suiveux
        cellule.titre.text = "\(indexPath.item) - \(itemCourant.title ?? "Titre non disponible")"
        
        // Renseigner l'avatar du suiveux
        let fichierAffiche = itemCourant.poster_path ?? ""
        let URLFichierImage = "https://image.tmdb.org/t/p/w150/\(fichierAffiche)" // w500
        
        // Préparer et lancer la requête
        //cellule.avatarImage.image = UIImage(named: Globales.LOADING_IMAGE)
        obtenirImage(urlStr: URLFichierImage, uneimage: cellule.affiche)
        
        return cellule
        
    }
    
    /*
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.item)
        if indexPath.item == films.results.count{
            // loadMoreData()
        }
    }
    */
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.results.count
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellule = UITableViewCell()
        cellule.textLabel?.text = films.results[indexPath.row].title
        return cellule
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let celluleSélectionnée = sender as! UICollectionViewCell
        let destination = segue.destination as! DetailsFilm
        destination._titre = "yo"
        let indiceFilm = CVFilms.indexPath(for: celluleSélectionnée)!.row
        destination.details = films.results[indiceFilm]
    }
    
} // extension ViewControlle

