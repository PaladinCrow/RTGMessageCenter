//
//  RTGSearchView.swift
//  RTGMessageCenter
//
//  Created by John Stanford on 3/26/24.
//

import SwiftUI

struct RTGSearchView: View {
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
                    .background(Color.clear)
                    .animation(.easeIn(duration: 3), value: isLoading)
            } else {
                VStack {
                    Image(.rtgLogo)
                        .padding()
                    Text("MCTitle")
                        .font(Font.custom("Poppins-Regular", size: 24))
                        .padding()
                        .multilineTextAlignment(.center)
                    Text("MCLookupText")
                        .frame(width: 300)
                        .font(Font.custom("Poppins-Regular", size: 16))
                        .padding()
                        .multilineTextAlignment(.center)
                    TextField("MCTextFieldPlaceholder", text: $searchText)
                        .font(Font.custom("Poppins-Regular", size: 16))
                        .textContentType(.emailAddress)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                        .padding([.leading, .trailing, .top])
                    Divider()
                        .padding([.leading, .trailing, .bottom])
                    Spacer()
                    NavigationLink(
                        destination: RTGMessagesView(messages: vm.sortedResults)
                            .toolbarRole(.editor),
                        isActive: $isShowingMessagesView) {EmptyView()}
                    Button {
                        lookUpMessages()
                    } label: {
                        Text("MCSearchButtonText")
                            .font(Font.custom("Poppins-Regular", size: 16))
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color(hex: 0x004fb5))
                    .cornerRadius(30.0)
                }
                .padding()
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
        }
    }
    
    func lookUpMessages() {
        isLoading = true
        guard searchText.isValidEmail else {
            isLoading = false
            searchText = ""
            alertTitle = String(localized: "InvalidEmailAlertTitle")
            alertMessage = String(localized: "InvalidEmailAlertText")
            showAlert = true
            return
        }
        print("looking up \(searchText)")
        Task {
            await vm.downloadMessages(searchText)
            isLoading = false
            if let error = vm.error as? NetworkError {
                switch error {
                case .badStatus:
                    alertTitle = String(localized: "BadStatusCodeAlertTitle")
                    alertMessage = String(localized: "BadStatusCodeAlertText")
                    showAlert = true
                    return
                case .notFound:
                    alertTitle = String(localized: "EmailNotFoundAlertTitle")
                    alertMessage = String(localized: "EmailNotFoundAlertText")
                    showAlert = true
                    return
                case .serverIssues:
                    alertTitle = String(localized: "ServerIssuesAlertTitle")
                    alertMessage = String(localized: "ServerIssuesAlertText")
                    showAlert = true
                    return
                case .decodeFail:
                    alertTitle = String(localized: "MessageErrorAlertTitle")
                    alertMessage = String(localized: "MessageErrorAlertText")
                    showAlert = true
                    return
                case .unknown:
                    alertTitle = String(localized: "UnknownErrorAlertTitle")
                    alertMessage = String(localized: "UnknownErrorAlertText")
                    showAlert = true
                    return
                }
            }
            if vm.sortedResults.isEmpty {
                alertTitle = String(localized: "NoMessagesAlertTitle")
                alertMessage = String(localized: "NoMessagesAlertText")
                showAlert = true
                return
            }
            isShowingMessagesView = true
        }
    }
}

#Preview {
    RTGSearchView()
}
