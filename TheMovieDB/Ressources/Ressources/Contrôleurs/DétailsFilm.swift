//
//  DétailsFilm.swift
//  TheMovieDB
//
//  Created by Alain on 17-06-20.
//  Copyright © 2017 Alain. All rights reserved.
//

import UIKit

class DetailsFilm: UIViewController, UIScrollViewDelegate {
    let nbScènesDétails = 3
    
    @IBOutlet var vPochette: UIView!
    @IBOutlet var vBackPochette: UIView!
    @IBOutlet weak var scrollDetail: UIScrollView!
    
    var _titre = ""
    var details: résultats!
    
    @IBOutlet weak var titre: UILabel!
    @IBOutlet weak var pochette: UIImageView!
    
    
    @IBAction func retourner(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titre.text = details.title
        let fichierAffiche = details.poster_path ?? ""
        let URLFichierImage = "https://image.tmdb.org/t/p/w500/\(fichierAffiche)" // w500
        
        // Préparer et lancer la requête
        //cellule.avatarImage.image = UIImage(named: Globales.LOADING_IMAGE)
        obtenirImage(urlStr: URLFichierImage, uneimage: pochette)
        
        // Do any additional setup after loading the view.
        
        scrollDetail.contentSize = CGSize(width:2000, height:400)
        // let uneTresGrandeScène =    UINib(nibName: "big", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        scrollDetail.addSubview(vBackPochette)
        // scrollDetail.addSubview(vPochette)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func chargerLesMagazines() {
        
        // Renseigner la largeur de la zone de contenu du scrollView en fn du nb de pages.
        let pagesScrollViewSize = scrollDetail.frame.size
        scrollDetail.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(nbScènesDétails), height: pagesScrollViewSize.height)
        
        for page in 0..<nbScènesDétails {
            
            // Placer les Views un à la suite de l'autre sur le plan des 'x'
            var frame:CGRect = scrollDetail!.bounds
            frame.origin.x = frame.size.width * CGFloat(page)  // la première page (0) sera à x = 0
            frame.origin.y = 0
            
            // Charger le 'xib' courant
            let nomNIB = "Détails\(page+1)"
            print("#\(nomNIB)")
            if let newPageView = UINib(nibName: nomNIB, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? UIView {
                newPageView.frame = frame;
                
                // Ajouter au scrollView
                scrollDetail!.addSubview(newPageView)
                
            }  // if newPageView
        } // for page
    } // chargerLesMagazines()
    
    
    // Méthode de délégation de UIScrollView
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        print("#scrollViewDidEndDecelerating")
        let positionPage = Int(scrollDetail.contentOffset.x / scrollDetail.frame.size.width)
        //TODO:
        ///indicateurDePages.currentPage = positionPage
        
    }  // scrollViewDidEndDecelerating
    
}
