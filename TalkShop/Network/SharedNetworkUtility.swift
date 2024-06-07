//
//  SharedNetworkUtility.swift
//  TalkShop
//
//  Created by Falguni Gandhi on 07/06/24.
//

import Foundation

protocol NetworkRequestProtocol {
    func formURLRequest(request: RequestModel) -> URLRequest?
    func urlWithParams(url: URL, params: [String:String?]?) -> URL
}

class NetworkUtility: NetworkRequestProtocol {
    
    func formURLRequest(request: RequestModel) -> URLRequest? {
        
        guard let url = URL(string: request.url) else {
            return nil
        }
        var urlTemp = url
        if let queryParams = request.queryParams {
            urlTemp = urlWithParams(url: urlTemp, params: queryParams)
        }
        var urlRequest = URLRequest(url: urlTemp)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.timeoutInterval = 30
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.allHTTPHeaderFields = [String:String]() // for all headers
        
        if let requestBody = request.requestBody {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
                urlRequest.httpBody = jsonData
            } catch {
                print("Error: Failed to serialize dictionary to JSON data -", error)
            }
        }
        
        return urlRequest
    }
    
    func urlWithParams(url: URL, params: [String:String?]?) -> URL {
        guard let params = params else {
            return url
        }
        
        guard var urlComponents = URLComponents(string: url.absoluteString) else {
            return url
        }
        
        urlComponents.queryItems = params.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        urlComponents.percentEncodedQuery = urlComponents.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        return urlComponents.url!
    }
}

enum NetworkError: Error {
    
    case invalidURL
    case serverError(statusCode: Int)
    case invalidURLRequest
    case decodingError(underlyingError: Error)
    case unknownError
    case invalidResponse
}

enum RequestMethod: String {
    
    case GET
    case POST
    case PUT
    case PATCH
    case DELETE
}

struct RequestModel {
    var header: [String: String]
    var url: String
    var requestBody: [String: Any]?
    var queryParams: [String: String]?
    var method: RequestMethod
}
