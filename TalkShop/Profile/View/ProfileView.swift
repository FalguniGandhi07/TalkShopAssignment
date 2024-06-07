//
//  ProfileView.swift
//  TalkShop
//
//  Created by Falguni Gandhi on 08/06/24.
//

import SwiftUI
import AVKit

struct ProfilePage: View {
    
    let username: String
    @StateObject var profileVM = ProfileViewModel(networkService: TalkShopNetworkService(), internetService: ReachabilityNetworkService())
    
    init(username: String) {
        self.username = username
    }
    
    var body: some View {
        if profileVM.noInternet {
            Text("No internet")
                .foregroundStyle(.red)
        }
        ScrollView {
            VStack(alignment: .center) {
                if let userProfile = profileVM.profileData {
                    ProfileInfoView(userName: self.username)
                    
                    if !userProfile.posts.isEmpty {
                        
                        VStack {
                            ForEach(Array(userProfile.posts.enumerated()), id: \.offset) { index, post in
                                
                                VideoPostView(post: post)
                                
                                if index != userProfile.posts.count - 1 {
                                    Divider()
                                        .padding(.vertical, 8)
                                }
                            }
                        }
                        
                    } else {
                        Text("No posts yet.")
                    }
                } else {
                    ProgressView()
                }
            }
        }
        .scrollIndicators(.hidden)
        .navigationTitle("Profile")
        .onAppear {
            Task {
                await self.profileVM.fetchProfileData(for: username)
            }
        }
    }
}

struct ProfileInfoView: View {
    let userName: String
    
    var body: some View {
        VStack {
            // Display user profile picture
            AsyncImage(url: URL(string: "https://picsum.photos/100/100")) { image in
                image
                    .resizable()
                    .frame(width: 100, height: 80)
                    .scaledToFit()
                    .clipShape(Circle())
            } placeholder: {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .fontWeight(.light)
            }
            
            // Display username
            Text(self.userName)
                .font(.title)
        }
    }
}

struct VideoPostView: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Display video thumbnail
            VideoPlayer(player: AVPlayer(url: URL(string: post.videoUrl)!))
                .frame(height: 300)
                .cornerRadius(10)
                .padding(.horizontal)
            
            // Display post details (likes, etc.)
            
            HStack {
                
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                
                Text("Likes: \(post.likes)")
                    .font(.headline)
                
                Spacer()
            }
            .padding(.leading)
        }
    }
}

