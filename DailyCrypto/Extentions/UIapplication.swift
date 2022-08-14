//
//  UIapplication.swift
//  DailyCrypto
//
//  Created by Youssif Hany on 14/08/2022.
//

import Foundation
import SwiftUI

extension UIApplication{
    // Dismiss keyboard
    func endEditing(){
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
