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
            Text("MCTitle")
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
                    Text(formatDate(message.receivedDate!) ?? "")
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
    
    func formatDate(_ input: Date) -> String? {
        let toStringFormatter = DateFormatter()
        toStringFormatter.dateStyle = .short
        toStringFormatter.locale = .current
        return toStringFormatter.string(from: input)
    }
}
