//
//  NetworkManager.swift
//  DailyCrypto
//
//  Created by Youssif Hany on 13/08/2022.
//

import Foundation
import Combine

class NetworkManager {
    
    enum NetworkError:LocalizedError{
        case badUrlResponse(url:URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badUrlResponse(url: let url):
                return "Bad URL Response : \(url)"
            case .unknown:
                return "Unknown error"
            }
        }
    }
    
    static func downloadURL(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({ try handleURLresponse(output: $0, url: url)})
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    static func handleURLresponse(output:URLSession.DataTaskPublisher.Output, url:URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkError.badUrlResponse(url: url)
              }
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished :
            break
        case .failure(let error) :
            print(error.localizedDescription)
        }
    }
}
