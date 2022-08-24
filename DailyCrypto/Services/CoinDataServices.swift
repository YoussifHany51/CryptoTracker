//
//  CoinDataServices.swift
//  DailyCrypto
//
//  Created by Youssif Hany on 11/08/2022.
//

import Foundation
import Combine

class CoinDataServices {
    
    
    @Published var allCoins:[CoinModel] = []
    var coinsSubscription: AnyCancellable?
    
    init(){
        getAllCoins()
    }
    
    // Combine discussion:
           /*
           // 1. sign up for monthly subscription for package to be delivered
           // 2. the company would make the package behind the scene
           // 3. recieve the package at your front door
           // 4. make sure the box isn't damaged
           // 5. open and make sure the item is correct
           // 6. use the item!!!!
           // 7. cancellable at any time!!
           
           // 1. create the publisher
           // 2. subscribe publisher on background thread
           // 3. recieve on main thread
           // 4. tryMap (check that the data is good)
           // 5. decode (decode data into PostModels)
           // 6. sink (put the item into our app)
           // 7. store (cancel subscription if needed)
           */
    
        func getAllCoins(){
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else {return}
        
        coinsSubscription = NetworkManager.downloadURL(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
                self?.coinsSubscription?.cancel()
            })
    }
}
