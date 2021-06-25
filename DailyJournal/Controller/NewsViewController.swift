//
//  NewsViewController.swift
//  DailyJournal
//
//  Created by Felipe Lobo on 01/04/21.
//

import UIKit
import WebKit

class NewsViewController: UIViewController, NewsManagerDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var table: UITableView!
    var newsManager = NewsManager()
    var newsModel = [NewsModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "Loading..."
        
        table.delegate = self
        table.dataSource = self
        newsManager.delegate = self
        newsManager.performRequest()
    }
    
    @IBAction func reloadPage(_ sender: UIButton) {
        newsManager.performRequest()
        print("request performed")
    }
    
    func didUpdateView(_ newsManager: NewsManager, news: [NewsModel]) {
        print("updating view")
        newsModel = news
        table.reloadData()
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func downloadImage(from urlString: String) -> Data? {
        let url = URL(string: urlString)
        do {
            let data = try Data(contentsOf: url!)
            return data
        } catch {
            print("Could not convert image")
            return nil
        }
    }

}

extension NewsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: false)
        print(newsModel[indexPath.row].url)
        if let url = URL(string: newsModel[indexPath.row].url) {
            let newsVC = WebViewController(url: url, title: newsModel[indexPath.row].title)
            newsVC.storyboard?.instantiateViewController(identifier: "NewsVC") as? WebViewController
            let navController = UINavigationController(rootViewController: newsVC)
            present(navController, animated: true)
        }
    }
    
}
extension NewsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        titleLabel.text = "Headlines"
        let cell = table.dequeueReusableCell(withIdentifier: "customCell") as! CustomCell
        cell.lbl?.text = newsModel[indexPath.row].title
//        if let newsImage = downloadImage(from: newsModel[indexPath.row].urlToImage) {
//            cell.newsImage.image = UIImage(data: newsImage)
//        }
        if newsModel[indexPath.row].urlToImage != "" {
            let newsImage = downloadImage(from: newsModel[indexPath.row].urlToImage)
            cell.newsImage.image = UIImage(data: newsImage!)
        }
        return cell
    }


}
