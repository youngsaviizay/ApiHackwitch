//
//  ViewController.swift
//  ApiHackwitch
//
//  Created by ZAYVIAN WILSON on 10/1/18.
//  Copyright © 2018 ZAYVIAN WILSON. All rights reserved.
//

import UIKit

class ArticlesViewController: UITableViewController {
    
    
    var articles = [[String: String]]()
    var apiKey = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "News Sources"
        let query = "https://newsapi.org/v1/sources?language=en&country=us&apiKey=\(apiKey)"
        DispatchQueue.global(qos: .userInitiated).async {
            [unowned self] in
            if let url = URL(string: query) {
                if let data = try? Data(contentsOf: url) {
                    let json = try! JSON(data: data)
                    if json["status"] == "ok" {
                        self.parse(json: json)
                        return
                    }
                }
            }
            self.loadError()
        }
    }
    
    func parse(json: JSON) {
        for result in json["sources"].arrayValue {
            let id = result["id"].stringValue
            let name = result["name"].stringValue
            let description = result["description"].stringValue
            let source = ["id": id, "name": name, "description": description]
            articles.append(source)
            tableView.reloadData()
            DispatchQueue.main.async {
                [unowned self] in
                self.tableView.reloadData()
            }
            
        }
    }
    
    func loadError() {
        let alert = UIAlertController(title: "Loading Error",message: "There was a problem loading the newsfeed",
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OK",style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let source = sources[indexPath.row]
        cell.textLabel?.text = source["name"]
        cell.detailTextLabel?.text = source["description"]
        return cell
    }
}
