//
//  HomeViewController.swift
//  ComicBox
//
//  Created by Joshua Okoro on 1/31/19.
//  Copyright © 2019 Joshua Okoro. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - Recent Release UI Elements
    @IBOutlet weak var recentReleaseDate: UILabel!
    @IBOutlet weak var recentReleaseTitle: UILabel!
    @IBOutlet weak var recentReleaseDescription: UILabel!
    @IBOutlet weak var recentReleaseBookmark: UIImageView!
    
    //MARK: - Bookmark UI Elements
    @IBOutlet weak var newBookmarkDate: UILabel!
    @IBOutlet weak var newBookmarkTitle: UILabel!
    @IBOutlet weak var newBookmarkDescription: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    //MARK: - View All Comics Button Pressed
    @IBAction func viewAllComics(_ sender: UIButton) {
    }
    
    //MARK: - View All Bookmarks Button Pressed
    @IBAction func viewAllBookmarks(_ sender: UIButton) {
    }
    
    
    //MARK: - Network To Get Content
    
    
    //MARK: - Unwrap with JSON
    
    
    //MARK: - Display Content To Recent Release View
    
    
    //MARK: - Display Content to Comic Shelf View
    

}
