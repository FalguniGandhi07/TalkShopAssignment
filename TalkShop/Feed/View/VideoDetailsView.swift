//
//  VideoDetailsView.swift
//  TalkShop
//
//  Created by Falguni Gandhi on 08/06/24.
//

import SwiftUI
import AVKit

struct VideoDetailView: View {
    
    let video: Video
    @State private var player: AVPlayer?
    @State private var likes: Int
    @State private var isLiked: Bool
    
    init(video: Video) {
        self.video = video
        self._likes = State(initialValue: video.likes)
        self._isLiked = State(initialValue: false) // Assuming the initial state is not liked
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack(alignment: .center, spacing: 8) {
                
                AsyncImage(url: URL(string: "https://picsum.photos/60/60")) { image in
                    image
                        .resizable()
                        .frame(width: 60, height: 60)
                        .scaledToFit()
                        .clipShape(Circle())
                } placeholder: {
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 60, height: 60)
                }
                
                NavigationLink(video.username) {
                    ProfilePage(username: video.username)
                }
                
            }
            .padding(.leading)
            
            
            VideoPlayer(player: player)
                .frame(height: 300)
                .cornerRadius(10)
                .padding(.horizontal)
            
            HStack {
                
                Button(action: {
                    if isLiked {
                        likes -= 1
                    } else {
                        likes += 1
                    }
                    isLiked.toggle()
                }) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .foregroundColor(isLiked ? .red : .gray)
                }
                
                Text("Likes: \(likes)")
                    .font(.headline)
                
            }
            .padding(.leading)
            
            Spacer()
        }
        .onAppear {
            self.player = AVPlayer(url: URL(string: video.videoUrl)!)
            player?.play()
        }
        .onDisappear {
            player = nil
        }
        .navigationTitle("Video Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
