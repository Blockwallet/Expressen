//
//  ViewController.swift
//  Expressen
//
//  Created by Lucas Karlsson on 2020-04-09.
//  Copyright © 2020 Picturit. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SDWebImage

struct ItemImg : Codable {
    
    var src: String?
    var position: String?
    
    init(dictionary: JSON) {
        
        self.src = dictionary["src"].string ?? ""
        self.position = dictionary["position"].string ?? ""
    }
}

struct Item : Codable {
    
    var subHeadline: String?
    var linkUrl: String?
    var headline: String?
    var absoluteUrl: String?
    var image: ItemImg?
    var color: Int?
    
    init(dictionary: JSON) {
        
        self.subHeadline = dictionary["subHeadline"].string ?? ""
        self.linkUrl = dictionary["linkUrl"].string ?? ""
        self.headline = dictionary["headline"].string ?? ""
        self.absoluteUrl = dictionary["absoluteUrl"].string ?? ""
        self.image = ItemImg(dictionary: dictionary["image"])
        self.color = 0
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    let cellReuseIdentifier = "cell"
    
    var items: [Item] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)

        AF.request("https://s3-eu-west-1.amazonaws.com/test.device.expressen.se/latest-articles.json").response{ response in
            
            print("Response: \(response)")
            
            if let json = response.value{
                
                print("1: \(JSON(json)["groups"][0]["items"])")
                
                for (index, item) in JSON(json)["groups"][0]["items"]{
                    
                    var newItem = Item(dictionary: item)
                    newItem.color = 2
                    self.items.append(newItem)
                }
                for (index, item) in JSON(json)["groups"][1]["items"]{
                    
                    self.items.append(Item(dictionary: item))
                }
                for (index, item) in JSON(json)["groups"][2]["items"]{
                    
                    self.items.append(Item(dictionary: item))
                }
                
                self.tableView.reloadData()
            }
        }
        
        
    }

     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellReuseIdentifier)
        
        let item = items[indexPath.item]
        
        cell.textLabel?.text = item.headline
        cell.detailTextLabel?.text = item.subHeadline
        
        if(item.color == 2){
            cell.textLabel?.textColor = .red
        }
        
        if let url = URL(string: item.image?.src ?? ""){
            
            cell.imageView?.sd_setImage(with: url, completed: { (image, error, type, url) in
                
            })
        }
        
        return cell
    }
}

