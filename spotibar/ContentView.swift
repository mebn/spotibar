//
//  ContentView.swift
//  spotibar
//
//  Created by Marcus Nilszén on 2020-12-28.
//

import SwiftUI
import ScriptingBridge

struct ContentView: View {
    let spotify = SBApplication(bundleIdentifier: "com.spotify.client")! as SpotifyApplication
    
    @State var buttonImage = "play.fill"
    @State var blurRadius: CGFloat = 0
    @State var isHover = false
    
    init() {
        self.buttonImage = spotify.playerState == .playing ? "play.fill" : "pause.fill"
    }
    
    
    var body: some View {
        ZStack {
            Image(nsImage: spotify.currentTrack!.artworkUrl!.load())
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 240)
                .blur(radius: blurRadius, opaque: true)
                .cornerRadius(5)
                .onHover {hover in
                    withAnimation {
                        isHover = hover
                        self.blurRadius = hover ? 5 : 0
                    }
                }
            
            if isHover {
                VStack {
                    Text(spotify.currentTrack!.name!)
                        .padding()
                    
                    HStack {
                        // previous track
                        Button(action: {
                            spotify.previousTrack?()
                        }) {
                            Image(systemName: "backward.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, alignment: .center)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding()
                        
                        // play / pause button
                        Button(action: {
                            if spotify.playerState == .playing {
                                spotify.pause?()
                                buttonImage = "play.fill"
                            } else {
                                spotify.play?()
                                buttonImage = "pause.fill"
                            }
                        }) {
                            Image(systemName: buttonImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 35, alignment: .center)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding()
                        
                        // next track
                        Button(action: {
                            spotify.nextTrack?()
                        }) {
                            Image(systemName: "forward.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, alignment: .center)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding()
                    }
                    
                    Text("")
                        .padding()
                } // vstack
                .transition(.opacity)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension String {
    func load() -> NSImage {
        do {
            guard let url = URL(string: self) else {
                return NSImage()
            }
            
            let data: Data = try Data(contentsOf: url)
            
            return NSImage(data: data) ?? NSImage()
        } catch {}
        
        return NSImage()
    }
}
