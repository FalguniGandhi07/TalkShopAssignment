//
//  FeedViewModel.swift
//  TalkShop
//
//  Created by Falguni Gandhi on 07/06/24.
//

import Foundation
import Combine

class FeedViewModel: ObservableObject {
    
    @Published var videos: [Video] = []
    @Published var noInternet: Bool = false
    private var networkDelegate: TalkShopNetworkServiceProtocol
    @Published var internetDelegate: ReachabilityNetworkService
    private var cancellables = Set<AnyCancellable>()
    
    init(networkService: TalkShopNetworkServiceProtocol, internetService: ReachabilityNetworkService) {
        self.networkDelegate = networkService
        self.internetDelegate = internetService
        self.internetDelegate.startMonitoring()
        
        self.internetDelegate.objectWillChange
                    .sink { [weak self] _ in
                        guard let self = self else { return }
                        self.noInternet = !(self.internetDelegate.isInternetAvailable)
                    }
                    .store(in: &cancellables)
    }
    
    deinit {
        self.internetDelegate.stopMonitoring()
    }
    
    func fetchVideos() async {
        if internetDelegate.isInternetAvailable == false {
            self.noInternet = true
        } else {
            self.noInternet = false
            if let response: FeedResponse = await networkDelegate.fetchVideos() {
                DispatchQueue.main.async {
                    print("response", response)
                    self.videos = response.data
                }
            }
        }
    }
    
}

