//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate{
    func didFailWithError(_ error: Error)
    func didUpdateCoinPrice(price: String, currency: String)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = ""
    
    var delegate: CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency : String){
        print(currency)
        fetchCoinPrice(currency: currency)
    }
    
    func fetchCoinPrice(currency: String){
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(with: urlString, currency: currency)
    }
    
    func performRequest(with url: String, currency: String){
        if let url = URL(string: url){
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    print(error!)
                    self.delegate?.didFailWithError(error!)
                    return
                }
                if let safeData = data{
                    
                    if let bitcoinPrice = self.parseJSON(safeData){
                        let stringPrice = String(format: "%.2f", bitcoinPrice)
                        print(stringPrice)
                        self.delegate?.didUpdateCoinPrice(price: stringPrice, currency: currency)
                    }
                    
                }
            }
            task.resume()
        }
    }
    func parseJSON(_ coinData: Data) -> Double? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let lastPrice = decodedData.rate
            print("the price is: \(lastPrice)")
            return lastPrice
        }catch{
            print(error)
            delegate?.didFailWithError(error)
            return nil
        }
    }

    
}
