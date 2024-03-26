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
    @Published var error: Error?
    
    func downloadMessages(_ email: String) async {
        results = []
        sortedResults = []
        let urlString = "https://vcp79yttk9.execute-api.us-east-1.amazonaws.com/messages/users/" + email
        let downloadedResults: (Error?, [Message]?) = await WebService().downloadData(fromURL: urlString)
        guard let result = downloadedResults.1 else {
            error = downloadedResults.0
            return
        }
        results = result
        sortMessagesByDate()
        error = nil
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
