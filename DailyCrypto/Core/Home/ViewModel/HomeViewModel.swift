//
//  HomeViewModel.swift
//  DailyCrypto
//
//  Created by Youssif Hany on 08/08/2022.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText:String = ""
    
    private let dataServices = CoinDataServices()
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        addSubsribers()
    }
    
    func addSubsribers(){
        
        $searchText
            .combineLatest(dataServices.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
    }
    
    private func filterCoins(text:String , coin:[CoinModel]) -> [CoinModel]{
        guard !text.isEmpty else{
            return coin
        }
        
        let lowerCased = text.lowercased()
        
        return coin.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowerCased) ||
                    coin.symbol.lowercased().contains(lowerCased) ||
                    coin.id.lowercased().contains(lowerCased)
        }
    }
    
}
