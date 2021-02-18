//
//  MovieList.swift
//  MovieAssignment
//
//  Created by Ankur on 18/02/21.
//

import Foundation

class listOfMovies
{
    var id : String?
    var rank: String?
    var title: String?
    var fullTitle: String?
    var year: String?
    var image: String?
    var crew: String?
    var imDbRating: String?
    var imDbRatingCount: String?
    
    convenience init(_ attibutes:[AnyHashable:Any])
    {
        self.init()
        self.id = attibutes["id"] as? String ?? ""
        self.rank = attibutes["rank"] as? String ?? ""
        self.title = attibutes["title"] as? String ?? ""
        self.fullTitle = attibutes["fullTitle"] as? String ?? ""
        self.year = attibutes["year"] as? String ?? ""
        self.image = attibutes["image"] as? String ?? ""
        self.crew = attibutes["crew"] as? String ?? ""
        self.imDbRating = attibutes["imDbRating"] as? String ?? ""
        self.imDbRatingCount = attibutes["imDbRatingCount"] as? String ?? ""
    }
}
