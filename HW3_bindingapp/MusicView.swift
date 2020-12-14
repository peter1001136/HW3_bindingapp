//
//  MusicView.swift
//  HW3_bindingapp
//
//  Created by 陳政沂 on 2020/11/2.
//

import SwiftUI
import AVFoundation
import MediaPlayer

struct MusicView: View {
    @Binding var style: Int
    @Binding var trend: Double
    @Binding var bgcolor: Color
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                Text("推薦歌曲")
                    .font(.system(size: 30))
                    .fontWeight(.bold)
                Spacer()
                
                detailView(style: self.style, trend: self.trend)
            }
        }
        
    }
}

struct detailView: View {
    var style: Int
    var trend: Double
    let classification = [Jay_songs, Eso_songs, Eric_songs]
    
    var body: some View {
        let pick = self.choose(style: style, trend: trend)
        
        return VStack{
            SongsView(sg: classification[style][pick])
        }
        
    }
    func choose(style: Int, trend: Double) -> Int {
        var qualified: [Int] = []
        var choice: Int
        
        if(trend == 0.0){
            choice = Int.random(in: 0 ..< classification[style].count)
            return choice
        }
        else{
            for i in 0 ..< classification[style].count{
                if(classification[style][i].grade >= trend - 1.0){
                    qualified.append(i)
                }
            }
            choice = qualified.randomElement()!
            return choice
        }
    }
}

struct SongsView: View {
    let sg: Songs
    
    @State private var showImg = true
    @State var isplay = false//音樂
    let player = AVPlayer()
    let commandCenter = MPRemoteCommandCenter.shared()
    
    var body: some View {
        VStack{
            if showImg{
                Image(sg.pic)
                    .resizable()
                    .scaledToFill()
                    .multilineTextAlignment(.leading)
                    .frame(width: 400, height: 400)
                
                Spacer()
                
                HStack {
                    Text(sg.song_name)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.black)
                        .padding(.leading, 120)
                    
                    Spacer()
                    
                    Button(action: {
                        let fileUrl = Bundle.main.url(forResource: sg.music, withExtension: "mp3")
                        let playerItem = AVPlayerItem(url: fileUrl!)
                        self.player.replaceCurrentItem(with: playerItem)
                        self.isplay.toggle()
                        if self.isplay{
                            self.player.play()
                        }
                        else{
                            self.player.pause()
                        }
                        self.commandCenter.playCommand.addTarget{
                            event in
                            if self.player.rate == 0.0{
                                self.player.play()
                                return .success
                            }
                            return .commandFailed
                        }
                    }){
                        Image(systemName: isplay ? "pause.fill" : "play.fill")
                            .resizable()
                            .frame(width:30,height:30)
                            .foregroundColor(Color(red: 244/255, green: 96/255, blue: 108/255))
                            .padding(.trailing, 100)
                    }
                }
                
                
                
                Text(sg.lyrics)
                    .padding()
                    .font(.title)
                    .multilineTextAlignment(.leading)
                    
            }
        }
    }
}

struct MusicView_Previews: PreviewProvider {
    static var previews: some View {
        MusicView(style: .constant(1), trend: .constant(1.0), bgcolor: .constant(Color.white))
        //Text("123")
    }
}

