//
//  CoinImageService.swift
//  DailyCrypto
//
//  Created by Youssif Hany on 13/08/2022.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService {
    
    @Published var image : UIImage? = nil
    var imgSubscription: AnyCancellable?
    private let coin : CoinModel
    
    init(coin: CoinModel){
        self.coin = coin
        getCoinsImage()
    }
    
    private func getCoinsImage(){
        guard let url = URL(string: coin.image) else {return}
        
        imgSubscription = NetworkManager.downloadURL(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] (returnedCoins) in
                self?.image = returnedCoins
                self?.imgSubscription?.cancel()
            })
    }
}
