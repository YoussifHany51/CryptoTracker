//
//  CoinImageView.swift
//  DailyCrypto
//
//  Created by Youssif Hany on 13/08/2022.
//

import SwiftUI

struct CoinImageView: View {
    
    @StateObject var coinImgVM: CoinImageViewModel
    
    init(coin: CoinModel){
        _coinImgVM = StateObject(wrappedValue: CoinImageViewModel(coin: coin))
    }
    
    var body: some View {
        ZStack{
            if let image = coinImgVM.image{
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }else if coinImgVM.isLoading{
                ProgressView()
            }else{
                Image(systemName: "questionmark")
                    .foregroundColor(Color.theme.secondaryText)
            }
        }
    }
}

struct CoinImageView_Previews: PreviewProvider {
    static var previews: some View {
        CoinImageView(coin: dev.coin)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
