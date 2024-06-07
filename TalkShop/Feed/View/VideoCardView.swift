//
//  VideoCardView.swift
//  TalkShop
//
//  Created by Falguni Gandhi on 08/06/24.
//

import SwiftUI
import AVKit

// Video Card View
struct VideoCardView: View {
    let video: Video
    @State private var isPlaying: Bool = false
    @State private var player: AVPlayer?
    
    var body: some View {
        VStack(alignment: .leading) {
            GeometryReader { geometry in
                ZStack {
                    if let player = player {
                        VideoPlayer(player: player)
                            .frame(height: 500)
                            .cornerRadius(10)
                            .onAppear {
                                updatePlaybackState(in: geometry)
                            }
                            .onChange(of: geometry.frame(in: .global), { _, _ in
                                updatePlaybackState(in: geometry)
                            })
                        
                    } else {
                        AsyncImage(url: URL(string: video.thumbnailUrl)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 500)
                        .cornerRadius(10)
                    }
                }
            }
            .frame(height: 500)
            
            NavigationLink(video.username) {
                ProfilePage(username: video.username)
            }
            .padding(.top, 5)
            
            HStack {
                Text("\(video.likes) likes")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                NavigationLink("View details") {
                    VideoDetailView(video: video)
                }
            }
        }
        .padding()
        
        .onAppear {
            if player == nil {
                player = AVPlayer(url: URL(string: video.videoUrl)!)
            }
        }
        .onDisappear {
            player?.pause()
        }
    }
    
    private func updatePlaybackState(in geometry: GeometryProxy) {
        let midY = geometry.frame(in: .global).midY
        let screenHeight = UIScreen.main.bounds.height
        let isCentered = abs(midY - screenHeight / 2) < 100
        
        if isCentered && !isPlaying {
            player?.play()
            isPlaying = true
        } else if !isCentered && isPlaying {
            player?.pause()
            isPlaying = false
        }
    }
}
