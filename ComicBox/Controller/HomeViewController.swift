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
        ProgressHUD.show("Updating")
        getRecentRelease()
    }
    
    //MARK: - View All Comics Button Pressed
    @IBAction func viewAllComics(_ sender: UIButton) {
    }
    
    //MARK: - View All Bookmarks Button Pressed
    @IBAction func viewAllBookmarks(_ sender: UIButton) {
    }
    
    
    //MARK: - Network To Get Content
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
    }
    
    //MARK: - Display Content To Recent Release View
    
    func handleErrors(_ error: Error) {
        print(error)
    }
    
    
    //MARK: - Display Content to Comic Shelf View
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeComicShelfCell", for: indexPath)
//        return cell
//    }
    

}
