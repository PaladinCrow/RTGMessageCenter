//
//  RTGMessagesView.swift
//  RTGMessageCenter
//
//  Created by John Stanford on 3/25/24.
//

import Foundation
import SwiftUI

struct RTGMessagesView: View {
    @State var messages: [Message]
    
    var body: some View {
        Divider()
        VStack {
            Text("Message Center")
                .font(Font.custom("Poppins-Bold", size: 16))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
        }
        .frame(maxWidth: .infinity)
        Divider()
        List {
            ForEach(messages) { message in
                HStack {
                    Text(message.message)
                        .font(Font.custom("Poppins-Regular", size: 14))
                        .frame(alignment: .leading)
                    Spacer()
                    Text(formatDate(message.date) ?? "")
                        .font(Font.custom("Poppins-Regular", size: 14))
                        .frame(alignment: .trailing)
                }
            }
            .listRowBackground(Color.white)
        }
        .scrollContentBackground(.hidden)
        .frame(maxWidth: .infinity)
        .offset(x: -15)
    }
    
    func formatDate(_ input: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"
        guard let date = dateFormatter.date(from: input) else {return nil}
        let toStringFormatter = DateFormatter()
        toStringFormatter.dateStyle = .short
        return toStringFormatter.string(from: date)
    }
}
