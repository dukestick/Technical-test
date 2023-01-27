//
//  DataManager.swift
//  Technical-test
//
//  Created by Patrice MIAKASSISSA on 29.04.21.
//

import UIKit
import Foundation
import CoreData


class DataManager {
     
     private static let path = "https://www.swissquote.ch/mobile/iphone/Quote.action?formattedList&formatNumbers=true&listType=SMI&addServices=true&updateCounter=true&&s=smi&s=$smi&lastTime=0&&api=2&framework=6.1.1&format=json&locale=en&mobile=iphone&language=en&version=80200.0&formatNumbers=true&mid=5862297638228606086&wl=sq"
     
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

     private func fetchApiQuotes(completionHandler: @escaping (_ quotes: [ApiQuote]?) -> ()) {
          guard let url = URL(string: Self.path) else { return }
          var request = URLRequest(url: url)
          request.httpMethod = "GET"
          URLSession.shared.dataTask(with: request) { data, response, error in
               guard error == nil else { fatalError("Can not download data") }
               if let data = data {
                    print("fetchApiQuotes JSON:", try! JSONSerialization.jsonObject(with: data))
                    if let decodedRequest = try? JSONDecoder().decode([ApiQuote].self, from: data) {
                         completionHandler(decodedRequest)
                    } else {
                         completionHandler(nil)
                    }
               }
          }.resume()
     }
     
     func fetchQuotes(completion: @escaping () -> ()) {
          self.fetchApiQuotes { apiQuotes in
               if let apiQuotes = apiQuotes {
                    self.processApiQuotes(apiQuotes: apiQuotes)
                    completion()
               }
          }
     }
     
     func processApiQuotes(apiQuotes: [ApiQuote]) {
          apiQuotes.forEach { apiQuote in
               let quotesByName = self.retrieve(byName: apiQuote.name)
               if quotesByName.isEmpty {
                    self.add(apiQuote: apiQuote)
               } 
          }
     }
     
     func retrieve(byName: String? = nil) -> [Quote] {
          do {
               let request = Quote.fetchRequest()
               
               if let name = byName {
                    let predicate = NSPredicate(format: "name MATCHES '\(name)'")
                    request.predicate = predicate
               }
               return try self.context.fetch(request)
          } catch {
               fatalError("can't fetch the data")
          }
     }
     
     func persistAll() {
          do {
               try self.context.save()
          } catch {
               fatalError("failed to persist data")
          }
     }
     
     func add(apiQuote: ApiQuote) {
          let quote = Quote(context: self.context)
          quote.name = apiQuote.name
          quote.last = apiQuote.last
          quote.currency = apiQuote.currency
          quote.readableLastChangePercent = apiQuote.readableLastChangePercent
          quote.variationColor = apiQuote.variationColor
          quote.symbol = apiQuote.symbol
          quote.isLiked = false
          do {
               try self.context.save()
          } catch {
               fatalError("can't save context")
          }
     }
     
     func delete(quote: Quote) {
          self.context.delete(quote)
          do {
               try self.context.save()
          } catch {
               fatalError("failed to persist data")
          }
     }
}

struct ApiQuote: Codable {
     let analyseIt: String?
     let ask: String?
     let askSize: String?
     let bid: String?
     let bidSize: String?
     let close: String?
     let currency: String?
     let delayed: String?
     let description: String?
     let estimatedPrice: String
     let estimates: String?
     let exchange: String?
     let exchangeId: String?
     let high: String?
     let high52: String?
     let industryName: String?
     let isin: String?
     let key: String?
     let last: String?
     let lastChange: String?
     let lastChangePercent: String?
     let lastDate: String?
     let lastTime: String?
     let low: String?
     let low52: String?
     let name: String?
     let news: String?
     let newsAlertable: String?
     let open: String?
     let orderbook: String?
     let paidPrices: String?
     let priceAlertable: String?
     let readableLastChangePercent: String?
     let readableLastTimeOrDate: String?
     let sectorName: String?
     let sharable: String?
     let stopTrading: String?
     let symbol: String?
     let tradable: String?
     let typeId: String?
     let variationColor: String?
     let volume: String?
}
