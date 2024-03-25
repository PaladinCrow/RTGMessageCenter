//
//  Networking.swift
//  RTGMessageCenter
//
//  Created by John Stanford on 3/25/24.
//

import Foundation

enum NetworkError: Error {
    case badStatus
    case decodeFail
    case unknown
}

class WebService: Codable {
    func downloadData<T: Codable>(fromURL: String) async -> T? {
        do {
            //MARK: Building the url (add future headers and params here)
            guard let url = URL(string: fromURL) else { throw NetworkError.unknown }
            let (data, response) = try await URLSession.shared.data(from: url)
            /// Attempt to decode the response
            guard let response = response as? HTTPURLResponse else { throw NetworkError.unknown }
            /// Validate the status code
            guard response.statusCode >= 200 && response.statusCode < 300 else { throw NetworkError.badStatus }
            /// Attempt to decode the data into the model
            guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else { throw NetworkError.decodeFail }
            /// return the decode response
            return decodedResponse
        } catch NetworkError.badStatus {
            // TODO: internally log the error code
            print("Unknown status code for call from \(fromURL)")
        } catch NetworkError.decodeFail {
            // TODO: internally log the error code
            print("Failed to decode data for call from \(fromURL)")
        } catch {
            // TODO: internally log the error code
            print("Unknown error from call \(fromURL)")
        }
        return nil
    }
}
