//
//  Service.swift
//  wstoriette
//
//  Created by Reksa on 26/05/19.
//  Copyright © 2019 Reksa. All rights reserved.
//

import Foundation
import UIKit

class Service {
    
    static let shared = Service()
    fileprivate let mainURL = "http://storiette-api.azurewebsites.net/getStories"
    
    func fetch(searchTerm: String, completion: @escaping ([ResultJSON], Error?) -> ()) {
        print("Fetching")
        
        let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&entity=ebook"
        let realURL = URL(string: urlString)
        URLSession.shared.dataTask(with: realURL!) { (data, respons, err) in
            
            //fail
            if let er = err {
                print("Fail", er)
                completion([], nil)
                return
            }
            
            guard let data = data else {return}
            
            do{
                let sreasult = try JSONDecoder().decode(SearchResultJSON.self, from: data)
                completion(sreasult.results, nil)
            }catch {
                print("Errr", error)
                completion([], error)
            }
            }.resume()
    }
    
    func fetchGetStories(completion: @escaping ([GetStories], Error?) -> ()) {
        print("Fetching")
        
        let urlString = mainURL
        let realURL = URL(string: urlString)
        URLSession.shared.dataTask(with: realURL!) { (data, respons, err) in
            
            //fail
            if let er = err {
                print("Fail", er)
                completion([], nil)
                return
            }
            
            guard let data = data else {return}
            
            do{
                let sreasult = try JSONDecoder().decode([GetStories].self, from: data)
                completion(sreasult, nil)
            }catch {
                print("Errr", error)
                completion([], error)
            }
        }.resume()
    }
    
    func fetchAppGroup(urlString: String, completion: @escaping (AppGroup?, Error?) -> Void) {
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    func fetchTopGrossing(completion: @escaping (AppGroup?, Error?) -> ()) {
        let urlString = "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-grossing/all/50/explicit.json"
        fetchAppGroup(urlString: urlString, completion: completion)
    }
    
    func fetchBook(completion: @escaping (AppGroup?, Error?) -> ()) {
        let urlString = "https://rss.itunes.apple.com/api/v1/us/books/top-free/all/25/explicit.json"
        fetchAppGroup(urlString: urlString, completion: completion)
    }
    
    func fetchGenericJSONData<T: Decodable>(urlString: String, completion: @escaping (T?, Error?) -> ()) {
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let err = err {
                completion(nil, err)
                return
            }
            do {
                let objects = try JSONDecoder().decode(T.self, from: data!)
                // success
                completion(objects, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
}
