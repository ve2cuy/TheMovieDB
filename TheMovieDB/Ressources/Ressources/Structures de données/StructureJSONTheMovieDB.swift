//
//  StructureJSONTheMovieDB.swift
//  TheMovieDB
//
//  Created by Alain on 17-06-20.
//  Copyright © 2017 Alain. All rights reserved.
//

import Foundation

struct StructureJSONTheMovieDB: Codable {
    var page:               Int             //
    let total_results:      Int
    let total_pages:        Int
    var results:            [résultats]
} // StructureJSONTheMovieDB


struct résultats: Codable {
    //let vote_count:         Int?
    //let id:                 Int?
    //let video:              Bool?
    let vote_average:       Float?
    let title:              String?
    //let popularity:         Double?
    let poster_path:        String?
    //let original_language:  String?
    //let original_title:     String?
    // let genre_ids:          [Int]?
    let backdrop_path:      String?
    //let adult:              Bool?
    //let overview:           String?
    //let release_date:       String?
    
} // résultats
