//
//  ViewController.swift
//  Gesture Recognizer Tutorial
//
//  Created by Tulio Marcos Franca on 06/09/17.
//  Copyright © 2017 0neTech. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet var monkeyPan: UIPanGestureRecognizer!
    @IBOutlet var bananaPan: UIPanGestureRecognizer!
    
    var chompPlayer: AVAudioPlayer? = nil
    var hehePlayer: AVAudioPlayer? = nil

    func loadSound(filename: String) -> AVAudioPlayer {
        let url = Bundle.main.url(forResource: filename, withExtension: "caf")
        var player = AVAudioPlayer()
        do {
            try player = AVAudioPlayer(contentsOf: url!)
            player.prepareToPlay()
        } catch {
            print("Error loading \(url!): \(error.localizedDescription)")
        }
        return player
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let filteredSubviews = self.view.subviews.filter({
            $0 is UIImageView })
        
        for view in filteredSubviews  {
            // UITapGestureRecognizer
            let recognizer = UITapGestureRecognizer(target: self,
                                                    action:#selector(handleTap(recognizer:)))
            recognizer.delegate = self
            view.addGestureRecognizer(recognizer)
            
            recognizer.require(toFail: monkeyPan)
            recognizer.require(toFail: bananaPan)
            
            // TickleGestureRecognizer
            let recognizer2 = TickleGestureRecognizer(target: self, action: #selector(handleTickle(recognizer:)))
            recognizer2.delegate = self
            view.addGestureRecognizer(recognizer2)
        }
        self.chompPlayer = self.loadSound(filename: "chomp")
        self.hehePlayer = self.loadSound(filename: "hehehe1")
    }
    
    @IBAction func handlePan(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        
        // Deceleration
        if recognizer.state == UIGestureRecognizerState.ended {
            let velocity = recognizer.velocity(in: self.view)
            let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
            let slideMultiplier = magnitude / 200
            print("magnitude: \(magnitude), slideMultiplier: \(slideMultiplier)")
            
            let slideFactor = 0.1 * slideMultiplier //Increase for more of a slide
            
            var finalPoint = CGPoint(x:recognizer.view!.center.x + (velocity.x * slideFactor),
                                     y:recognizer.view!.center.y + (velocity.y * slideFactor))
            
            finalPoint.x = min(max(finalPoint.x, 0), self.view.bounds.size.width)
            finalPoint.y = min(max(finalPoint.y, 0), self.view.bounds.size.height)
            
            UIView.animate(withDuration: Double(slideFactor * 2),
                           delay: 0,
                           options: UIViewAnimationOptions.curveEaseOut,
                           animations: {recognizer.view!.center = finalPoint},
                           completion: nil)
        }
    }
    
    @IBAction func handlePinch(recognizer: UIPinchGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
            recognizer.scale = 1
        }
    }

    @IBAction func handleRotate(recognizer: UIRotationGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = view.transform.rotated(by: recognizer.rotation)
            recognizer.rotation = 0
        }
    }

    @objc func handleTap(recognizer: UITapGestureRecognizer) { //@IBAction
        self.chompPlayer?.play()
    }
    
    @objc func handleTickle(recognizer: TickleGestureRecognizer) {
        self.hehePlayer?.play()
    }

}

// MARK: - UIGestureRecognizerDelegate
extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

