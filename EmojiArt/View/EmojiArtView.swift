//
//  EmojiArtView.swift
//  EmojiArt
//
//  Created by Hugo Santiago on 25/08/20.
//  Copyright © 2020 Hugo Santiago. All rights reserved.
//

import SwiftUI

struct EmojiArtView: View {
    @ObservedObject var document: EmojiArtDoc
    
    var body: some View {
        VStack{
            ScrollView (.horizontal){
                HStack{
                    ForEach(EmojiArtDoc.palette.map{ String($0) }, id: \.self){emoji in
                        Text(emoji)
                            .font(Font.system(size: self.defultSizeEmoji))
                            .onDrag { NSItemProvider(object: emoji as NSString) }
                    }
                }
            }
            .padding(.horizontal)
            ZStack {
                GeometryReader { geometry in
                    Color.white.overlay(
                        Group {
                            if self.document.backgroundImage != nil {
                                Image(uiImage: self.document.backgroundImage!)
                            }
                        }
                    )
                        .edgesIgnoringSafeArea([.horizontal,.bottom])
                        .onDrop(of: ["public.image", "public.text"], isTargeted: nil) { providers, location in
                            var location = geometry.convert(location, from: .global)
                            location = CGPoint(x: location.x - geometry.size.width/2, y: location.y - geometry.size.height/2)
                            return self.drop(providers: providers, at: location)
                    }
                    ForEach(self.document.emojis){emoji in
                        Text(emoji.text)
                            .font(self.font(for: emoji))
                            .position(self.position(for: emoji, in: geometry.size))
                    }
                }
            }
        }
    }
    
    private func font( for emoji: EmojiArt.Emoji)-> Font{
        Font.system(size: emoji.fontSize)
    }
    private func position(for emoji: EmojiArt.Emoji, in size: CGSize) -> CGPoint {
        CGPoint(x: emoji.location.x + size.width/2, y: emoji.location.y + size.height/2)
    }
    
    private func drop(providers: [NSItemProvider], at location: CGPoint) -> Bool {
        var found = providers.loadFirstObject(ofType: URL.self) { url in
            self.document.setBackgroundURL(url)
        }
        if !found {
            found = providers.loadObjects(ofType: String.self) {string in
                self.document.addEmoji(string, at: location, size: self.defultSizeEmoji)
            }
        }
        return found
    }
    private let defultSizeEmoji : CGFloat = 40
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtView(document: EmojiArtDoc())
    }
}
