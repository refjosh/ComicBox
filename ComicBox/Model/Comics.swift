//
//  Comics.swift
//  ComicBox
//
//  Created by Joshua Okoro on 2/11/19.
//  Copyright © 2019 Joshua Okoro. All rights reserved.
//

import Foundation

class Comics {
    var title: String
    var transcript: String
    var comicID: Int
    var image: URL
    var bookmarked = false
    var favorite = false
    
    init(title: String, transcript: String, id: Int, imageURL: URL) {
        self.title = title
        self.transcript = transcript
        self.comicID = id
        self.image = imageURL
    }
}
