//
//  Networking.swift
//  RTGMessageCenter
//
//  Created by John Stanford on 3/25/24.
//

import Foundation

enum NetworkError: Error {
    case badStatus
    case notFound
    case serverIssues
    case decodeFail
    case unknown
}

class WebService: Codable {
    func downloadData<T: Codable>(fromURL: String) async -> (Error?,T?) {
        do {
            //MARK: Building the url (add future headers and params here)
            guard let url = URL(string: fromURL) else { throw NetworkError.unknown }
            let (data, response) = try await URLSession.shared.data(from: url)
            /// Attempt to decode the response
            guard let response = response as? HTTPURLResponse else { throw NetworkError.unknown }
            /// Validate the status code
            if response.statusCode >= 500 { throw NetworkError.serverIssues }
            if response.statusCode >= 400 && response.statusCode < 500 { throw NetworkError.notFound }
            guard response.statusCode >= 200 && response.statusCode < 300 else { throw NetworkError.badStatus }
            /// Attempt to decode the data into the model
            guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else { throw NetworkError.decodeFail }
            /// return the decode response
            return (nil,decodedResponse)
        } catch NetworkError.badStatus {
            // TODO: internally log the error code
            return (NetworkError.badStatus, nil)
        } catch NetworkError.notFound{
            // TODO: internally log the error code
            return (NetworkError.notFound, nil)
        } catch NetworkError.decodeFail {
            // TODO: internally log the error code
            return (NetworkError.decodeFail, nil)
        } catch {
            // TODO: internally log the error code
            return (NetworkError.unknown, nil)
        }
    }
}
