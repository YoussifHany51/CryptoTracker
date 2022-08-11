//
//  DailyCryptoApp.swift
//  DailyCrypto
//
//  Created by Youssif Hany on 06/08/2022.
//

import SwiftUI

@main
struct DailyCryptoApp: App {
    
    @StateObject private var vm = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView{
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(vm)
        }
    }
}
