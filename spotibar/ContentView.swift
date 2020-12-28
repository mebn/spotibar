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
    
    init() {
        self.buttonImage = spotify.playerState == .playing ? "play.fill" : "pause.fill"
    }
    
    var body: some View {
        VStack {
            Spacer()
                .frame(width: 300, height: 300)
                .background(Color.blue)
            
            Text(spotify.currentTrack!.name!)
                .padding()
            
            HStack {
                // previous track
                Button(action: {
                    spotify.previousTrack?()
                }) {
                    Image(systemName: "backward.fill")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 25, height: 25, alignment: .center)
                }
                .buttonStyle(PlainButtonStyle())
                .padding()
                
                Spacer()
                
                // play / pause button
                Button(action: {
                    spotify.playpause?()
                    buttonImage = spotify.playerState == .playing ? "play.fill" : "pause.fill"
                }) {
                    Image(systemName: buttonImage)
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 35, height: 35, alignment: .center)
                }
                .buttonStyle(PlainButtonStyle())
                .padding()
                
                Spacer()
                
                // next track
                Button(action: {
                    spotify.nextTrack?()
                }) {
                    Image(systemName: "forward.fill")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 25, height: 25, alignment: .center)
                }
                .buttonStyle(PlainButtonStyle())
                .padding()
            }
            
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
