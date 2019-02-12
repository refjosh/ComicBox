//
//  ComicShelfViewController.swift
//  ComicBox
//
//  Created by Joshua Okoro on 1/31/19.
//  Copyright © 2019 Joshua Okoro. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ProgressHUD


//protocol ClearToLand {
//    func dataReceived(data: Int)
//}

class ComicShelfViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
//    var delegate: ClearToLand?
    
    var startingID: Int = 1
    var endingID: Int = 0
    var comic = [Comics]()

    @IBOutlet weak var comicShelfTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Comic Shelf"
        if comic.count < 1 {
            DispatchQueue.main.async {
                self.getAllComics()
            }
        }
        
        comicShelfTable.separatorStyle = .none
    }
    
    //MARK: - Get All Comics
    func getAllComics() {
        for index in startingID ... endingID {
            Alamofire.request("https://xkcd.com/\(index)/info.0.json").validate().responseJSON { (response) in
                switch response.result {
                case .success:
                    let result = JSON(response.result.value!)
                    
                    let title: String = result["safe_title"].string!
                    let transcript: String = result["alt"].string!
                    let comicID = result["num"].int ?? 0
                    let imageURL: URL = result["img"].url!
                    self.updateComicsLarge(title: title, transcript: transcript, comicID: comicID, image: imageURL)
                    
                case .failure(let error):
                    ProgressHUD.showError("The \(index) Comic can't be found")
                    print(error)
                }
            }
        }
    }
    
    // Update Array for all comics
    func updateComicsLarge(title: String, transcript: String, comicID: Int, image: URL) {
        let newComic = Comics(title: title, transcript: transcript, id: comicID, imageURL: image)
        newComic.bookmarked = false
        newComic.favorite = false
        comic.append(newComic)
        if comic.count == 100 {
            comicShelfTable.reloadData()
        } else if comic.count == 1000 {
            comicShelfTable.reloadData()
        } else if comic.count == 1500 {
            comicShelfTable.reloadData()
        }
        else if comic.count <= endingID - 2 {
            comicShelfTable.reloadData()
        }
    }
    
    //MARK: - Display Content From Array In TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "ComicShelfCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
//        let newHold = allComics.shuffled()
        
        cell.textLabel?.text = comic[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ToReadView", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Send ComicID through Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ViewController
        
        if let indexPath = comicShelfTable.indexPathForSelectedRow {
            destinationVC.comicID = comic[indexPath.row].comicID
            destinationVC.endingID = endingID
        }
    }

}
