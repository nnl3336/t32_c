//
//  BallonModifier.swift
//  Tiles
//
//  Created by Yuki Sasaki on 2024/03/12.
//

import SwiftUI

struct CopyBallonModifier: ViewModifier {
    @EnvironmentObject var messageCopyBallon: MessageCopyBalloon
    func body(content: Content) -> some View {
        content
.font(.system(size: 24))
                        .padding(3)
                        .background(Color(red: 0.3, green: 0.3 ,blue: 0.3))
                        .foregroundColor(.white)
                        .opacity(messageCopyBallon.castOpacity())
                        .cornerRadius(5)
                        .offset(x: -5, y: -20)
    }
}
