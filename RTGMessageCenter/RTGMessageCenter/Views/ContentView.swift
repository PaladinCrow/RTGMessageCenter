//
//  ContentView.swift
//  RTGMessageCenter
//
//  Created by John Stanford on 3/25/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isShowingMessagesView = false
    @State private var isLoading = false
    @State private var searchText = ""
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    @StateObject private var vm = MessageCenterViewModel()
    
    var body: some View {
        NavigationView {
            if isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
            } else {
                VStack {
                    Image(.rtgLogo)
                        .padding()
                    Text("Message Center")
                        .font(Font.custom("Poppins-Regular", size: 24))
                        .padding()
                        .multilineTextAlignment(.center)
                    Text("Enter your email to search for your messages")
                        .frame(width: 300)
                        .font(Font.custom("Poppins-Regular", size: 16))
                        .padding()
                        .multilineTextAlignment(.center)
                    TextField("Enter your email", text: $searchText)
                        .font(Font.custom("Poppins-Regular", size: 16))
                        .textContentType(.emailAddress)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                        .padding([.leading, .trailing, .top])
                    Divider()
                        .padding([.leading, .trailing, .bottom])
                    Spacer()
                    NavigationLink(
                        destination: RTGMessagesView(messages: vm.results)
                            .toolbarRole(.editor),
                        isActive: $isShowingMessagesView) {EmptyView()}
                    Button {
                        lookUpMessages()
                    } label: {
                        Text("Search")
                            .font(Font.custom("Poppins-Regular", size: 16))
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .cornerRadius(30.0)
                }
                .padding()
            }
        }
        .alert(alertTitle, isPresented: $showAlert) {
            Button(role: .cancel){
                showAlert = false
            } label: {
                Text("Ok")
            }
        } message: {
            Text(alertMessage)
        }
        
    }
    
    func lookUpMessages() {
        isLoading = true
        guard searchText.isValidEmail else {
            print("No valid email to lookup")
            isLoading = false
            searchText = ""
            alertTitle = "Invalid Email"
            alertMessage = "You have input an invalid email address. Please try again."
            showAlert = true
            return
        }
        print("looking up \(searchText)")
        Task {
            await vm.downloadMessages(searchText)
            isLoading = false
            if vm.results.isEmpty {
                print("Present no messages alert")
                alertTitle = "No Messages"
                alertMessage = "No messages were found for this email."
                showAlert = true
                return
            }
            if vm.error {
                print("Present error alert")
                alertTitle = "Unknown Error"
                alertMessage = "We seem to having some problems. Please try again or try a different email."
            }
            isShowingMessagesView = true
        }
    }
}

#Preview {
    ContentView()
}
