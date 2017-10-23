//
//  helperFn.swift
//  TheMovieDB
//
//  Created by Alain on 17-06-20.
//  Copyright © 2017 Alain. All rights reserved.
//

import Foundation
import UIKit

/// **********************************************
func obtenirImage(urlStr:String, uneimage: UIImageView){
    // Préparer et lancer la requête
    let request = URLRequest(url: URL(string:urlStr)! /*as! URL*/)
    let session = URLSession.shared
    
    let task = session.dataTask(with: request,
                                completionHandler: {data, response, error -> Void in
                                    
                                    if (error == nil) {
                                        DispatchQueue.main.async ( execute:
                                            {
                                                if let _data = data {
                                                    uneimage.image = UIImage(data: _data)
                                                } else
                                                {
                                                   /// uneimage.image = UIImage(named: Globales.NA_IMAGE)
                                                }
                                        }
                                        )  // DispatchQueue.main.async()
                                        
                                    } else { // erreur d'URL
                                       /// uneimage.image = UIImage(named: Globales.NA_IMAGE)
                                    }
    })
    task.resume()  // Reprendre le traitement de la session pour qu'elle puisse se terminer.
} // obtenirImage
