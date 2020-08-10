//
//  AuctionAPI.swift
//  auction
//
//  Created by mathias cloet on 02/08/2020.
//  Copyright © 2020 mathias cloet. All rights reserved.
//

import Foundation
import UIKit


class AuctionAPI {
    
    let API_URL: String = "https://mathiascloet.com/api"
    let API_KEY: String = "AAEf47#g1H92jQyUnQWDlmubXc8YmVyuVTVV#oAI"
    
    func getAuctions(completion: @escaping ([Auction]?) -> Void) {
        
        let url : String = "\(API_URL)/Auctions/"
        
        guard let resourceUrl = URL(string: url) else {fatalError()}
        
        var request = URLRequest(url: resourceUrl)
        request.httpMethod = "GET"
        request.setValue(API_KEY, forHTTPHeaderField: "X-Api-Key")
        
        let task = URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let jsonData = data else {
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                
                // print(String(data: jsonData, encoding: .utf8))
                let auctionResponse = try decoder.decode([Auction].self, from: jsonData)
                completion(auctionResponse)
            } catch {
                completion(nil)
                print(error)
                return
            }
            
        }
        task.resume()
        
    }
    
    func getLots(auctionId: Int, completion : @escaping ([Lot]?) -> Void) {
        let url : String = "\(API_URL)/Lots?auction=\(auctionId)"
        
        guard let resourceUrl = URL(string: url) else { fatalError() }
        
        var request = URLRequest(url: resourceUrl)
        request.httpMethod = "GET"
        request.setValue(API_KEY, forHTTPHeaderField: "X-Api-Key")
        
        let task = URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let jsonData = data else {
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                
                let response = try decoder .decode([Lot].self, from: jsonData)
                completion(response)
            } catch {
                completion(nil)
                print(error)
                return
            }
            
        }
        task.resume()
        
    }
    
    func postLotBid(lotId: Int, bid: Double, completion: @escaping (Lot?) -> Void) {
        let url : String = "\(API_URL)/Lots/\(lotId)/Bid"
        
        guard let resourceUrl = URL(string: url) else {fatalError()}
        
        var request = URLRequest(url: resourceUrl)
        request.httpMethod = "POST"
        request.setValue(API_KEY, forHTTPHeaderField: "X-Api-Key")
    }
    
    func getLotImage(lotId: Int, imageId: Int, completion: @escaping (UIImage?) -> Void) {
        
        let url: String = "\(API_URL)/Lots/\(lotId)/images/\(imageId)"
        
        guard let resourceUrl = URL(string: url) else {fatalError()}
        
        var request = URLRequest(url: resourceUrl)
        request.httpMethod = "GET"
        request.setValue(API_KEY, forHTTPHeaderField: "X-Api-Key")
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                print("Error downloading an image: \(String(describing: error))")
                completion(nil)
                return
            }
            completion(UIImage(data: data)!)
        }
        task.resume()
    }
    
    func getLotImages(lot: Lot, completion: @escaping ([UIImage]?) -> Void ) {
        
        let group = DispatchGroup()
        var images: [UIImage] = []
        
        for image in lot.images {
            group.enter()
            getLotImage(lotId: image.lotID, imageId: image.id, completion: { (data) in
                guard let data = data else {return}
                images.append(data)
                group.leave()
            })
        }
        
        group.notify(queue: .main) {
            completion(images)
        }
    }
    
    func getImage(auctionId: Int, imageId: Int, completion: @escaping (UIImage?) -> Void) {
        
        let url : String = "\(API_URL)/Auctions/\(auctionId)/images/\(imageId)"
        
        guard let resourceUrl = URL(string: url) else {fatalError()}
        
        var request = URLRequest(url: resourceUrl)
        request.httpMethod = "GET"
        request.setValue(API_KEY, forHTTPHeaderField: "X-Api-Key")
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                print("Error downloading an image : \(String(describing: error))")
                completion(nil)
                return
            }
            completion(UIImage(data: data)!)
        }
        task.resume()
        
    }
    
    func getImages(auction: Auction, completion: @escaping ([UIImage]?) -> Void) {

        let group = DispatchGroup()
        var images: [UIImage] = []
        
        for image in auction.images {
            group.enter()
            getImage(auctionId: image.auctionID, imageId: image.id, completion: { (data) in
                guard let data = data else  { return}
                images.append(data)
                group.leave()
            } )
            
        }
        
        group.notify(queue: .main) {
            completion(images)
        }

    }
    
    
}
