//
//  ContentView.swift
//  CrashTools
//
//  Created by Drayl on 2022/4/6.
//

import SwiftUI

struct SideItem: Hashable {
    let title: String
    let imageName: String
}

struct ContentView: View {
    @State var currentSelectedItem: Int = 0
    
    let sideItems: [SideItem] = [
        .init(title: "解析崩溃日志", imageName: "clock.badge.checkmark"),
        .init(title: "Logan日志解析", imageName: "arrow.triangle.2.circlepath"),
    ]
    
    var body: some View {
        
        let content = self.crashContent(fromFile: "AppleDemo", ofType: "ips")

        let parser = AppleParser()
        let crash: Crash! = parser.parse(content)
        let crashString = crash.symbolicate(dsymPaths: nil)
        
        
        NavigationView {
            ListView(currentSelectedItem: $currentSelectedItem, sideItems: sideItems)
            
            switch currentSelectedItem {
            case 0:
                VStack {
                    ZStack {
                        Text("xxx")
                    }
                    .frame(height: 100, alignment: .top)
                    .background(Color.green)
                    Text(crashString)
                }
                Text(crashString)
            default:
                Text("Other")
            }
            
        }
    
    }
    
    func crashContent(fromFile file: String, ofType ftype: String) -> String {
        let bundle = Bundle.main
        let path = bundle.path(forResource: file, ofType: ftype)!
        return try! String(contentsOfFile: path)
    }
    
    private func infoString(fromCrash crash: Crash) -> String {
        var info = ""
        var divider = ""
        if let device = crash.device {
            info += "🏷 " + modelToName(device)
            divider = " - "
        }
        if let osVersion = crash.osVersion {
            info += "\(divider)\(osVersion)"
        }
        
        if let appVersion = crash.appVersion {
            info += "\(divider)\(appVersion)"
        }
        
        return info
    }
    
    let modelMap = parseModels()

    func modelToName(_ model: String) -> String {
        return modelMap[model] ?? model
    }
}

struct ListView: View {
    @Binding var currentSelectedItem: Int
    
    let sideItems: [SideItem]
    var body: some View {
        VStack {
            ForEach(sideItems.indices, id: \.self) { index in
                let current = sideItems[currentSelectedItem]
                let option = sideItems[index]
                HStack {
                    Image(systemName: option.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20)
                    
                    Text(option.title).foregroundColor(current == option ? .red : .white)
                    
                    Spacer()
                }
                .padding(8)
                .onTapGesture {
                    currentSelectedItem = index
                }
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
