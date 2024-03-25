//
//  MessageCenterViewModel.swift
//  RTGMessageCenter
//
//  Created by John Stanford on 3/25/24.
//

import Foundation

@MainActor class MessageCenterViewModel: ObservableObject {
    @Published var results: [Message] = []
    @Published var error: Bool = false
    
    func downloadMessages(_ email: String) async {
        let urlString = "https://vcp79yttk9.execute-api.us-east-1.amazonaws.com/messages/users/" + email
        guard let downloadedResults: [Message] = await WebService().downloadData(fromURL: urlString) else {
            error = true
            return
        }
        results = downloadedResults
        error = false
    }
}
