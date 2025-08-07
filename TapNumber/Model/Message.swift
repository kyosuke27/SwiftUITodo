//
//  Message.swift
//  TapNumber
//
//  Created by kyosuke on 2024/12/03.
//

import Foundation

class Message: Identifiable {
    let id: UUID
    var message: String
    let registerData: Date
    
    init(id: UUID, message: String) {
        self.id = id
        self.message = message
        self.registerData = Date()
    }
}
