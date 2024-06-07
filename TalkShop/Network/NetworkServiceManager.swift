//
//  NetworkServiceManager.swift
//  TalkShop
//
//  Created by Falguni Gandhi on 08/06/24.
//

import Foundation
import Network


class ReachabilityNetworkService: ObservableObject {
    
    private let monitor = NWPathMonitor()
    private var isMonitoring = false
    @Published var isInternetAvailable: Bool = false
    
    init() {}
    
    func startMonitoring() {
        guard !isMonitoring else { return }
        
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isInternetAvailable = path.status == .satisfied
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
        isMonitoring = true
    }
    
    func stopMonitoring() {
        guard isMonitoring else { return }
        monitor.cancel()
        isMonitoring = false
    }
}
