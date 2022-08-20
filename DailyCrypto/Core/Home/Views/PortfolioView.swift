//
//  PortfolioView.swift
//  DailyCrypto
//
//  Created by Youssif Hany on 17/08/2022.
//

import SwiftUI

struct PortfolioView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var vm : HomeViewModel
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText: String = ""
    @State private var showCheckMark: Bool = false

    var body: some View {
        NavigationView{
            ScrollView{
                VStack(alignment:.leading,spacing: 0){
                    SearchBarView(searchText: $vm.searchText)
                    
                   CoinLogoList
                    
                    if selectedCoin != nil {
                        PortfolioInputeSection
                    }
                }
            }
            .navigationTitle("Portfolio")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button{
                        presentationMode.wrappedValue.dismiss()
                    }label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack{
                        Image(systemName: "checkmark")
                            .opacity(showCheckMark ? 1.0 : 0.0)
                        Button{
                            saveButtonPressed()
                        }label: {
                            Text("save".uppercased())
                        }
                        .opacity(
                            (selectedCoin != nil && selectedCoin?.currentPrice != Double(quantityText))  ? 1.0 : 0
                        )
                    }
                }
            }
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(dev.homeVM)
    }
}


extension PortfolioView{
    private var CoinLogoList: some View{
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing:10){
                ForEach(vm.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width:75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                selectedCoin = coin
                            }
                        }
                        .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(
                                selectedCoin?.id == coin.id ?
                                Color.theme.green : Color.clear, lineWidth: 1)
                        )
                }
            }
            .frame(height:120)
            .padding(.leading)
        }
    }
    
    private var PortfolioInputeSection : some View{
        VStack(spacing:20){
            HStack{
                Text("Current Price of \(selectedCoin?.symbol.uppercased() ?? "") :")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            Divider()
            HStack{
                Text("Amount holding:")
                Spacer()
                TextField("Ex: 1.4",text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad )
            }
            Divider()
            HStack{
                Text("Current Value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }
        .animation(.none)
        .padding()
        .font(.headline)
    }
    
    
    private func getCurrentValue()->Double{
        if let quantity = Double(quantityText) {
            return quantity * (selectedCoin?.currentPrice  ?? 0)
        }
        return 0
    }
    
    private func saveButtonPressed(){
        guard let coin = selectedCoin else {return}
        
        
        
        withAnimation(.easeIn) {
            showCheckMark = true
            removeSelectionCoin()
        }
        
        // hide keyboard
        UIApplication.shared.endEditing()
        
        //hide checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            withAnimation(.easeIn) {
                showCheckMark = false
            }
        }
    }
    
    private func removeSelectionCoin(){
        selectedCoin = nil
        vm.searchText = ""
    }
}
