//
//  ComicShelfViewController.swift
//  ComicBox
//
//  Created by Joshua Okoro on 1/31/19.
//  Copyright © 2019 Joshua Okoro. All rights reserved.
//

import UIKit


//protocol ClearToLand {
//    func dataReceived(data: Int)
//}

class ComicShelfViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
//    var delegate: ClearToLand?
    
    var allComics = [String]()
    
    var selectedTitleIndex: Int = 0

    @IBOutlet weak var comicShelfTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Comic Shelf"
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allComics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "ComicShelfCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
//        let newHold = allComics.shuffled()
        
        cell.textLabel?.text = allComics[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
