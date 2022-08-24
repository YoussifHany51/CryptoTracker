//
//  MarketDataService.swift
//  DailyCrypto
//
//  Created by Youssif Hany on 17/08/2022.
//

import Foundation
import Combine

class MarketDataService {
    
    
    @Published var marketData:MarketDataModel? = nil
    var marketSubscription: AnyCancellable?
    
    init(){
        getData()
    }
    
        func getData(){
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else {return}
        
        marketSubscription = NetworkManager.downloadURL(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] (returnedGlobalData) in
                self?.marketData = returnedGlobalData.data
                self?.marketSubscription?.cancel()
            })
    }
}

