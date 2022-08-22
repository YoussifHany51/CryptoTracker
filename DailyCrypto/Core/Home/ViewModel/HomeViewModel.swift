//
//  HomeViewModel.swift
//  DailyCrypto
//
//  Created by Youssif Hany on 08/08/2022.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var statistics: [StatisticModel] = [
        StatisticModel(title: "title", value: "value", percentageChange: 1),
        StatisticModel(title: "title", value: "value"),
        StatisticModel(title: "title", value: "value"),
        StatisticModel(title: "title", value: "value", percentageChange: -7),
        ]
    
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText:String = ""
    
    private let coinDataService = CoinDataServices()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        addSubsribers()
    }
    
    func addSubsribers(){
        
        //Update Coins
        $searchText
            .combineLatest(coinDataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        //Update MarketData
        marketDataService.$marketData
            .map(mapGlobalMarketData)
            .sink { [weak self] (returnedStats) in
                self?.statistics = returnedStats
            }
            .store(in: &cancellables)
        //Update Portfolio Coins
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map { (coinModels,portfolioEntities) -> [CoinModel] in
                coinModels
                    .compactMap { (coin) -> CoinModel? in
                        guard let entity = portfolioEntities.first(where: {$0.coinID == coin.id})
                        else{
                            return nil
                        }
                        return coin.updateHoldings(amount: entity.amount)
                    }
            }
            .sink { [weak self](returnedCoins) in
                self?.portfolioCoins = returnedCoins
            }
            .store(in: &cancellables)
    }
    
    func updatePortfolio(coin:CoinModel,amount:Double){
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
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
    
    private func mapGlobalMarketData(marketDataModel:MarketDataModel?) -> [StatisticModel]{
        var stats: [StatisticModel] = []
        guard let data = marketDataModel else {return stats}
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        let portfolio = StatisticModel(title: "Portoflio value", value: "$0.00", percentageChange: 0)
        
        stats.append(contentsOf: [
        marketCap,
        volume,
        btcDominance,
        portfolio,
        ])
        return stats
    }
    
}
