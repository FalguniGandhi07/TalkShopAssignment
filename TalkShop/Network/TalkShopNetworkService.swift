//
//  TalkShopNetworkService.swift
//  TalkShop
//
//  Created by Falguni Gandhi on 08/06/24.
//

import Foundation

protocol TalkShopNetworkServiceProtocol {
    var networkManager: NetworkManager { get }
    func fetchVideos() async -> FeedResponse?
    func fetchProfileData(for userName: String) async -> ProfileData?
}

class TalkShopNetworkService: TalkShopNetworkServiceProtocol {
    
    var networkManager: NetworkManager = NetworkManager()
    
    func fetchVideos() async -> FeedResponse? {
        let requestModel = RequestModel(header: [:], url: "https://4c81f78d-c7be-46cf-a516-f7a0dcdade22.mock.pstmn.io/api/feed", method: .GET)
        do {
            return try await networkManager.fetchData(request: requestModel)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func fetchProfileData(for userName: String) async -> ProfileData? {
        let reuqestModel = RequestModel(header: [:], url: "https://68d5bcfe-b610-4a7e-87df-9e91dcc1b9ed.mock.pstmn.io/api/profile", queryParams: ["username": userName], method: .GET)
        do {
            return try await networkManager.fetchData(request: reuqestModel)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
}
