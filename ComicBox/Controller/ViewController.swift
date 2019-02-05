//
//  ViewController.swift
//  ComicBox
//
//  Created by Joshua Okoro on 1/27/19.
//  Copyright © 2019 Joshua Okoro. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ProgressHUD



class ViewController: UIViewController {
    
    
    @IBOutlet weak var pageImage: UIImageView!
    @IBOutlet weak var pageDescription: UITextView!
    @IBOutlet weak var prevComicButton: UIButton!
    @IBOutlet weak var nextComicButton: UIButton!
    
    
    var comicID: Int = 0
    
    var comicNumber: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getContent(id: comicID)
    }
    
    //MARK: - Fetch Data
    func getContent(id: Int) {
        Alamofire.request("https://xkcd.com/\(id)/info.0.json").validate().responseJSON { (response) in
            switch response.result {
            case .success:
                let result = JSON(response.result.value!)
                self.updateWithContent(result)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    //MARK: - Update UI Elements with Content
    func updateWithContent(_ content: JSON) {
        
        comicNumber = content["num"].int!
        
        if comicNumber == 1 {
            prevComicButton.isEnabled = false
            nextComicButton.isEnabled = true
        } else if comicNumber == comicID {
            nextComicButton.isEnabled = false
            prevComicButton.isEnabled = true
        } else {
            nextComicButton.isEnabled = true
            prevComicButton.isEnabled = true
        }
        
        let imageURL = URL(string: content["img"].string!)
        downloadImage(from: imageURL!)
        
        pageDescription.text = content["alt"].string
        
        navigationItem.title = content["safe_title"].string
    }
    
    func updateImage(_ content: Data) {
        pageImage.image = UIImage(data: content)
    }
    
    //MARK: - Previous Comic
    @IBAction func prevComicButtonPressed(_ sender: UIButton) {
       comicNumber -= 1
        getContent(id: comicNumber)
    }
    
    //MARK: - Next Comic
    @IBAction func nextComicButtonPressed(_ sender: UIButton) {
        comicNumber += 1
        getContent(id: comicNumber)
    }
    
    
    
    
    //MARK: - Download Image
    func downloadImage(from url: URL) {
        ProgressHUD.show("Loading Image")
        Alamofire.request(url).validate().responseData(queue: DispatchQueue.main) { (response) in
            switch response.result {
            case .success:
                let result = response.result.value!
                self.updateImage(result)
                ProgressHUD.dismiss()
            case .failure(let error):
                print("Error getting image\(error)")
                ProgressHUD.showError("Unable To Get Image")
            }
        }
    }


}

