//
//  HapticManager.swift
//  DailyCrypto
//
//  Created by Youssif Hany on 22/08/2022.
//

import Foundation
import UIKit


class HapticManager{
    
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notification(type:UINotificationFeedbackGenerator.FeedbackType){
        generator.notificationOccurred(type)
    }
    
}
