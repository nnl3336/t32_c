//
//  MessageCopyBalloon.swift
//  Tiles
//
//  Created by Yuki Sasaki on 2024/03/12.
//

import SwiftUI

class MessageCopyBalloon:ObservableObject{
    @Published  var opacity:Double = 10.0
    @Published  var isCopyPreview:Bool = false
    private var timer = Timer()
    
    func castOpacity() -> Double{
        Double(self.opacity / 10)
    }
    
    func vanishCopyMessage(){         
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true){ _ in
            self.opacity = self.opacity - 1.0
        if(self.opacity == 0.0){
            self.isCopyPreview = false
            self.opacity = 10.0
            self.timer.invalidate()
        }
    }
    }
    
}
