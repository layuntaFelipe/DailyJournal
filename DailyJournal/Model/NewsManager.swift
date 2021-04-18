//
//  NewsManager.swift
//  WeatherApp
//
//  Created by Felipe Lobo on 01/04/21.
//

import Foundation

protocol NewsManagerDelegate {
    func didUpdateView(_ newsManager: NewsManager, news: [NewsModel])
    func didFailWithError(error: Error)
}

struct NewsManager {
    
    var delegate: NewsManagerDelegate?
    
    let newsURL = "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(KeysAPIs().news)"
    
    func performRequest() {
        print("Performing Request")
        if let url = URL(string: newsURL) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("ERROR FOUND NILL IN TASK")
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let newsArray = parseJSON(safeData) {
                        print("About Update View")
                        DispatchQueue.main.async {
                            delegate?.didUpdateView(self, news: newsArray)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ newsData: Data) -> [NewsModel]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(NewsData.self, from: newsData)
            print(decodedData)

            var articlesArray = [NewsModel]()
            var numberOfArticles = 0
            
            for _ in decodedData.articles{
                numberOfArticles += 1
            }

            for num in 0...numberOfArticles-1 {
                let models = NewsModel(title: decodedData.articles[num].title,
                                       url: decodedData.articles[num].url,
                                       publishedAt: decodedData.articles[num].publishedAt, urlToImage: decodedData.articles[num].urlToImage ?? "")
                articlesArray.append(models)
            }

            return articlesArray


        } catch {
            print("ERROR IN JSON")
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
