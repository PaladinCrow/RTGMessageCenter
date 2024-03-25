//
//  MessageCenterViewModel.swift
//  RTGMessageCenter
//
//  Created by John Stanford on 3/25/24.
//

import Foundation

@MainActor 
class MessageCenterViewModel: ObservableObject {
    private var results: [Message] = []
    @Published var sortedResults: [Message] = []
    @Published var error: Bool = false
    
    func downloadMessages(_ email: String) async {
        let urlString = "https://vcp79yttk9.execute-api.us-east-1.amazonaws.com/messages/users/" + email
        guard let downloadedResults: [Message] = await WebService().downloadData(fromURL: urlString) else {
            error = true
            return
        }
        results = downloadedResults
        sortMessagesByDate()
        error = false
    }
    
    private func sortMessagesByDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"
        for message in results {
            let date = dateFormatter.date(from: message.date)
            if let date = date {
                message.receivedDate = date
            }
        }
        sortedResults = results.sorted(by: {$0.receivedDate!.compare($1.receivedDate!) == .orderedDescending })
    }
}
