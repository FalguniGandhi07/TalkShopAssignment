//
//  NetworkManager.swift
//  TalkShop
//
//  Created by Falguni Gandhi on 07/06/24.
//

import Foundation



class NetworkManager {
    
    var utilityManager: NetworkUtility
    
    init() {
        self.utilityManager = NetworkUtility()
    }
    
    func fetchData<T: Decodable>(request: RequestModel) async throws -> T {
        
        guard let urlRequest = self.utilityManager.formURLRequest(request: request) else {
            throw NetworkError.invalidURLRequest
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard (200..<300).contains(httpResponse.statusCode) else {
                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            }
            
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
            
        } catch {
            throw NetworkError.decodingError(underlyingError: error)
        }
    }
    
}
