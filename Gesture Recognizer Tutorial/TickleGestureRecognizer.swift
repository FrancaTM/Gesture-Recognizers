//
//  TickleGestureRecognizer.swift
//  Gesture Recognizer Tutorial
//
//  Created by Tulio Marcos Franca on 16/09/17.
//  Copyright © 2017 0neTech. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

class TickleGestureRecognizer: UIGestureRecognizer {
    let requiredTickles = 2
    let distanceForTickleGesture: CGFloat = 25.0
    
    enum Direction: Int {
        case DirectionUnknown = 0
        case DirectionLeft
        case DirectionRight
    }
    
    var tickleCount: Int = 0
    var curTickleStart: CGPoint = CGPoint.zero
    var lastDirection: Direction = .DirectionUnknown
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if let touch = touches.first {
            self.curTickleStart = touch.location(in: self.view)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        if let touch = touches.first {
            let ticklePoint = touch.location(in: self.view)
            
            let moveAmt = ticklePoint.x - curTickleStart.x
            var curDireciton: Direction
            if moveAmt < 0 {
                curDireciton = .DirectionLeft
            } else {
                curDireciton = .DirectionRight
            }
            
            //moveAmt is a Float, so self.distanceForTickleGesture needs to be a Float also
            if abs(moveAmt) < self.distanceForTickleGesture {
                return
            }
            
            if self.lastDirection == .DirectionUnknown ||
                (self.lastDirection == .DirectionLeft && curDireciton == .DirectionRight) ||
                (self.lastDirection == .DirectionRight && curDireciton == .DirectionLeft) {
                self.tickleCount += 1
                self.curTickleStart = ticklePoint
                self.lastDirection = curDireciton
                
                if self.state == .possible && self.tickleCount > self.requiredTickles {
                    self.state = .ended
                }
            }
        }
    }
    
    override func reset() {
        self.tickleCount = 0
        self.curTickleStart = CGPoint.zero
        self.lastDirection = .DirectionUnknown
        if self.state == .possible {
            self.state = .failed
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        self.reset()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        self.reset()
    }
}




