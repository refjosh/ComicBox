//
//  HomeViewController.swift
//  ComicBox
//
//  Created by Joshua Okoro on 1/31/19.
//  Copyright © 2019 Joshua Okoro. All rights reserved.
//

import UIKit
import CoreData
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
    var lastID: Int = 1
    var firstID: Int = 1
    private var comicShelf = [String]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var comics = [Comic]()
    
    var loadedID = [LatestComic]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProgressHUD.show("Updating")
        getRecentRelease()
        print(dataFilePath)
        
        loadLastestID()
//        if Int(loadedID) != lastID {
//            // Get All Comics
//            getAllComics()
//        }
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

        lastID = result["num"].int!
        
        let newComicID = LatestComic(context: context)
        newComicID.comicID = result["num"].int32!
//        save()
        
        

        randomComicID1 = Int.random(in: 1 ... lastID)
        randomComicID2 = Int.random(in: 1 ... lastID)
        // Get 2 Random Comis for Home Comic Shelf
        getComics(comicID1: randomComicID1, comicID2: randomComicID2)

    }
    
    //MARK: - Model Manupulation Methods
    func save() {
        do {
            try context.save()
        } catch  {
            print(error)
        }
    }
    
    func loadLastestID() {
        let request: NSFetchRequest<LatestComic> = LatestComic.fetchRequest()
        do {
            loadedID = try context.fetch(request)
        } catch  {
            print(error)
        }
        
    }
    
    
    
    //MARK: - Network To Get Comics
    func getComics(comicID1: Int, comicID2: Int) {
    // NEEDS TO BE REFRACTORED
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
    // Update Array for all comics
    func updateComicsLarge(title: String, transcript: String, comicID: Int32, image: URL) {
        let newComics = Comic(context: context)
        newComics.title = title
        newComics.transcript = transcript
        newComics.comicID = comicID
        newComics.image = image
        newComics.bookmarked = false
        newComics.favorite = false
        save()
        comics.append(newComics)
        print(comics)
    }
    
    
    
    //MARK: - Dislay Error Message
    func handleErrors(_ error: Error) {
        // NEEDS TO BE REFRACTORED
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
    
    //MARK: - Get All Comics
    func getAllComics() {
        for index in firstID ... lastID {
            Alamofire.request("https://xkcd.com/\(index)/info.0.json").validate().responseJSON { (response) in
                switch response.result {
                case .success:
                    let result = JSON(response.result.value!)
                    
                    let title: String = result["safe_title"].string!
                    let transcript: String = result["transcript"].string!
                    let comicID = result["num"].int32 ?? 0
                    let imageURL: URL = result["img"].url!
                    
                    self.updateComicsLarge(title: title, transcript: transcript, comicID: comicID, image: imageURL)
                    
                    
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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ToComicShelf" {
//            let comicView = segue.destination as! ComicShelfViewController
//            comicView.allComics = Comics
//        }
//    }
    
    //End of HomeViewController
}
