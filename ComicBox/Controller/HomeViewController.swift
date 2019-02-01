//
//  HomeViewController.swift
//  ComicBox
//
//  Created by Joshua Okoro on 1/31/19.
//  Copyright © 2019 Joshua Okoro. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ProgressHUD

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    //MARK: - Recent Release UI Elements
    @IBOutlet weak var recentReleaseDate: UILabel!
    @IBOutlet weak var recentReleaseTitle: UILabel!
    @IBOutlet weak var recentReleaseDescription: UILabel!
    @IBOutlet weak var recentReleaseBookmark: UIImageView!
    
    
    
    @IBOutlet weak var comicShelfTable: UITableView!
    
    //MARK: - Bookmark UI Elements
    @IBOutlet weak var newBookmarkDate: UILabel!
    @IBOutlet weak var newBookmarkTitle: UILabel!
    @IBOutlet weak var newBookmarkDescription: UILabel!
    
    
    //MARK: - Other Constants And Variable
    var randomComicID1: Int = 0
    var randomComicID2: Int = 0
    var lastComicID: Int = 2105
    private var comicShelf = [String]()
    private var allComics = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProgressHUD.show("Updating")
        getRecentRelease()
        
    }
    
    
    //MARK: - View All Bookmarks Button Pressed
    @IBAction func viewAllBookmarks(_ sender: UIButton) {
    }
    
    
    //MARK: - Network To Get Recent Release
    func getRecentRelease() {
        Alamofire.request("https://xkcd.com/info.0.json").validate().responseJSON { (response) in
            switch response.result {
            case .success:
                ProgressHUD.showSuccess("Got New Release!")
                let resultInJSON = JSON(response.result.value!)
                self.updateWithRecentRelease(resultInJSON)
                
            case .failure(let error):
                ProgressHUD.showError("Unable To Get New Release\n😞")
                self.handleErrors(error)
            }
        }
    }
    
    //MARK: - Unwrap with JSON and Update Recent Release View
    func updateWithRecentRelease(_ result: JSON) {
        let year = result["year"].string!
        let month = result["month"].string!
        let day = result["day"].string!
        
        recentReleaseTitle.text = result["safe_title"].string
        recentReleaseDate.text = "\(month)-\(day)-\(year)"
        recentReleaseDescription.text = result["alt"].string
        
        lastComicID = result["num"].int!
        randomComicID1 = Int.random(in: 1 ... lastComicID)
        randomComicID2 = Int.random(in: 1 ... lastComicID)
        
        getComics(comicID1: randomComicID1, comicID2: randomComicID2)
        getAllComics()

    }
    
    
    
    //MARK: - Network To Get Comics
    func getComics(comicID1: Int, comicID2: Int) {
        
        // Get First Comic and Add To Array
        Alamofire.request("https://xkcd.com/\(comicID1)/info.0.json").validate().responseJSON { (response) in
            switch response.result {
            case .success:
                let result1 = JSON(response.result.value!)
                self.updateComicShelfArray(result1["safe_title"].string!)
            case .failure(let error):
                self.handleErrors(error)
            }
        }
        
        // Get Second Comic and Add To Array
        Alamofire.request("https://xkcd.com/\(comicID2)/info.0.json").validate().responseJSON { (response) in
            switch response.result {
            case .success:
                let result2 = JSON(response.result.value!)
                self.updateComicShelfArray(result2["safe_title"].string!)
            case .failure(let error):
                self.handleErrors(error)
            }
        }
        
    }
    
    //MARK: - Update Array
    func updateComicShelfArray(_ title: String) {
        comicShelf.append(title)
        
        // Needs to be refractored because it refreshes twice
        comicShelfTable.reloadData()
    }
    
    func updateComicsLarge(_ title: String) {
        allComics.append(title)
    }
    
    
    
    //MARK: - Dislay Error Message
    func handleErrors(_ error: Error) {
        print(error)
    }
    
    
    //MARK: - Display Content to Comic Shelf View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comicShelf.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "HomeComicShelfCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        cell.textLabel?.text = comicShelf[indexPath.row]
        return cell
    }
    
    // Get all Comics
    func getAllComics() {
        for index in 1 ... lastComicID {
            Alamofire.request("https://xkcd.com/\(index)/info.0.json").validate().responseJSON { (response) in
                switch response.result {
                case .success:
                    let result = JSON(response.result.value!)
                    self.updateComicsLarge(result["safe_title"].string!)
                case .failure(let error):
                    self.handleErrors(error)
                }
            }
        }
    }
    
    //MARK: - PROTOCOL AND SEGUE TO COMIC SHELF
    @IBAction func viewAllComics(_ sender: UIButton) {
        performSegue(withIdentifier: "ToComicShelf", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToComicShelf" {
            let comicView = segue.destination as! ComicShelfViewController
            comicView.allComics = allComics
        }
    }
    
    //End of HomeViewController
}
