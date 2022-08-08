//
//  DailyCryptoApp.swift
//  DailyCrypto
//
//  Created by Youssif Hany on 06/08/2022.
//

import SwiftUI

@main
struct DailyCryptoApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView{
                HomeView()
                    .navigationBarHidden(true)
            }
        }
    }
}
