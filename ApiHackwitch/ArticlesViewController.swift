//
//  ViewController.swift
//  ApiHackwitch
//
//  Created by ZAYVIAN WILSON on 10/1/18.
//  Copyright © 2018 ZAYVIAN WILSON. All rights reserved.
//

import UIKit

class ArticlesViewController: UITableViewController {
    
    var sources = [String: String]()
    var articles = [[String: String]]()
    var apiKey = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Top Stories"
        let query = " https://newsapi.org/v1/articles?source=\(sources["id"]!)&apiKey=\(apiKey)"
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
        for result in json["articles"].arrayValue {
            let title = result["title"].stringValue
            let description = result["description"].stringValue
            let url = result["url"].stringValue
            let article = ["title": title, "description": description,
                           "url": url]
            articles.append(article)
        }
            DispatchQueue.main.async {
                [unowned self] in
                self.tableView.reloadData()
            }
        }

    
    func loadError() {
        let alert = UIAlertController(title: "Loading Error",message: "There was a problem loading the newsfeed",
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OK",style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ID Cell", for: indexPath)
        let article = articles[indexPath.row]
        cell.textLabel?.text = article["title"]
        cell.detailTextLabel?.text = article["description"]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dvc = segue.destination as! ArticlesViewController
        let index = tableView.indexPathForSelectedRow?.row
        dvc.source = sources[index!]
        dvc.apiKey = apiKey
    }
}

