//
//  ContentView.swift
//  HW3_bindingapp
//
//  Created by 陳政沂 on 2020/11/1.
//

import SwiftUI

struct ContentView: View {
    @State private var name = ""
    @State private var selectDate = Date()
    @State private var listenmusic = false
    @State private var stylepick = 0
    @State private var trendscore = 0.0
    @State private var isEspand = false
    @State private var showActionsheet = false
    @State private var showsheet = false
    @State private var showalert = false
    @State var bgcolor = Color.black
    
    let today = Date()
    let startDate = Calendar.current.date(byAdding: .year, value: -100, to: Date())!
    var year: Int{
        Calendar.current.component(.year, from: selectDate)
    }
    
    var body: some View {
        VStack{
            Image("music")
                .resizable()
                .scaledToFit()
                .frame(height: 250)
            
            ColorPicker("選擇字體顏色", selection: $bgcolor)
            
            Form {
                Name(name: $name)
                
                DatePicker("你的生日", selection: $selectDate, in: self.startDate...self.today, displayedComponents: .date)
                
                Toggle("推薦音樂", isOn: $listenmusic)
                if listenmusic{
                    VStack{
                        PlayList(isEspand: $isEspand)
                        
                        stylePicker(style: $stylepick)
                        
                        Hotstepper(trend: $trendscore)
                        Hotslider(trend: $trendscore)
                    }
                }
            }
            if listenmusic{
                Button(action: {
                        if (trendscore == 0.0){
                            showActionsheet = true
                        }
                        else if(trendscore > 5){
                            showalert = true
                        }
                        else{
                            showsheet = true
                        }}){
                    Text("去聽歌～")
                        .font(.system(size: 30))
                        .padding()
                        .background(Color(red: 200/255, green: 170/255, blue: 230/255))
                        .foregroundColor(.black)
                        .cornerRadius(30)
                        .padding(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color(red: 200/255, green: 170/255, blue: 230/255), lineWidth: 5))
                }
                .actionSheet(isPresented: $showActionsheet){
                    ActionSheet(title: Text("熱門程度為0"), message: Text("請選擇"),
                        buttons:[.default(Text("重選")), .default(Text("隨機播放")){showsheet = true}])
                }
                .sheet(isPresented: $showsheet){
                    MusicView(style: $stylepick, trend: $trendscore, bgcolor: $bgcolor).foregroundColor(bgcolor)
                }
                .alert(isPresented: $showalert){() -> Alert in
                    return Alert(title: Text("爆表囉！"), message: Text("請重選"))
                    
                }
            }
        }
        .foregroundColor(bgcolor)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Name: View {
    @Binding var name: String
    var body: some View {
        TextField("你的名字", text: $name)
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.blue, lineWidth: 2))
    }
}


struct stylePicker: View {
    @Binding var style: Int
    
    let styles = ["周杰倫", "瘦子Ｅ.SO", "周興哲"]
    
    var body: some View {
        Picker(selection: self.$style, label: Text("喜好類型")) {
            ForEach(styles.indices) { (index) in
                Text(self.styles[index])
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

struct Hotstepper: View {
    @Binding var trend: Double
    
    var body: some View {
        Stepper("熱門程度:  " + String(format: "%.1f", trend), value: $trend, in: 0 ... 6)
    }
}

struct Hotslider: View {
    @Binding var trend: Double
    
    var body: some View {
        Slider(value: $trend, in: 0 ... 5, step: 1, minimumValueLabel: Text("0"), maximumValueLabel: Text("5")){
            Text("")
        }
    }
}

struct PlayList: View {
    @Binding var isEspand: Bool
    var body: some View {
        DisclosureGroup(
            isExpanded: $isEspand,
            content: { VStack(alignment: .leading){
                ForEach(Jay_songs.indices){(index) in
                    Text(Jay_songs[index].song_name)
                }
                Spacer()
                ForEach(Eso_songs.indices){(index) in
                    Text(Eso_songs[index].song_name)
                }
                Spacer()
                ForEach(Eric_songs.indices){(index) in
                    Text(Eric_songs[index].song_name)
                }
            } },
            label: { Text("Playlist") }
        )
    }
}
