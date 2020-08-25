//
//  EmojiArtDoc.swift
//  EmojiArt
//
//  Created by Hugo Santiago on 25/08/20.
//  Copyright © 2020 Hugo Santiago. All rights reserved.
//

import Foundation
import SwiftUI

class EmojiArtDoc : ObservableObject {
    static let palette: String = "😀😡🐱🥑🏈🏋🏼‍♂️🤼🏓🏐"
    
    var emojis: [EmojiArt.Emoji] { emojiArt.emojis }
    
    @Published private var emojiArt = EmojiArt()
    
    @Published private(set) var backgroundImage : UIImage?
    
    // MARK: - Intent(s)
    
    func addEmoji(_ emoji: String, at location: CGPoint, size: CGFloat){
        emojiArt.addEmoji(emoji, x: Int(location.x), y: Int(location.y), size: Int(size))
    }
    
    func moveEmoji(_ emoji: EmojiArt.Emoji, by offset: CGSize){
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.height)
        }
    }
    
    func scaleEmoji(_ emoji: EmojiArt.Emoji, by scale: CGFloat){
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrEven))
        }
    }
    
    func setBackgroundURL (_ url: URL?) {
        emojiArt.backgroundURL = url?.imageURL
        fetchBackgroudImageData()
    }
    private func fetchBackgroudImageData(){
        backgroundImage = nil
        if let url = self.emojiArt.backgroundURL {
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageData = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        // Si el usuario se queda esperando y pone otra imagen, este codigo va a prevenir que se vuelvan
                        // a cambiar
                        if url == self.emojiArt.backgroundURL {
                            self.backgroundImage = UIImage(data: imageData)
                        }
                    }
                }
            }
        }
    }
}

extension EmojiArt.Emoji {
    var fontSize: CGFloat { CGFloat(self.size)}
    var location: CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y))}

}


