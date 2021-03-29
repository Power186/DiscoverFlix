//
//  NetworkManager.swift
//  DiscoverFlix
//
//  Created by Scott on 3/19/21.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case invalidResponse
    case nilResponse
}

final class NetworkManager<T: Codable> {
    static func fetch(from urlString: String, completion: @escaping (Result<T, NetworkError>) -> Void) {
        AF.request(urlString).responseDecodable(of: T.self) { (resp) in
            if resp.error != nil {
                completion(.failure(.invalidResponse))
                print(resp.error!)
                return
            }
            
            if let payload = resp.value {
                completion(.success(payload))
                return
            }
            
            completion(.failure(.nilResponse))
        }
    }
    
}
