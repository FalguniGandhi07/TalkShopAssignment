//
//  FeedView.swift
//  TalkShop
//
//  Created by Falguni Gandhi on 04/06/24.
//

import SwiftUI

// Main View
struct FeedView: View {
    
    @StateObject private var feedVM = FeedViewModel(networkService: TalkShopNetworkService(), internetService: ReachabilityNetworkService())
    
    var body: some View {
        
        NavigationStack {
            
            if feedVM.noInternet {
                Text("No internet")
                    .foregroundStyle(.red)
            }
            
            ScrollView(showsIndicators: false) {
                
                if feedVM.videos.isEmpty {
                    ProgressView()
                } else {
                    LazyVStack {
                        ForEach(feedVM.videos) { video in
                            
                            VideoCardView(video: video)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                                .padding(.horizontal)
                            
                        }
                    }
                }
            }
            .refreshable {
                await feedVM.fetchVideos()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Feed")
            
            .onAppear {
                Task {
                    await feedVM.fetchVideos()
                }
            }
        }
    }
}

