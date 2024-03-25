//
//  MessageResults.swift
//  RTGMessageCenter
//
//  Created by John Stanford on 3/25/24.
//

import Foundation

class Message: Identifiable, Codable {
    var name: String
    var date: String
    var message: String
}
