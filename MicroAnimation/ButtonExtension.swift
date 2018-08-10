//
//  ButtonExtension.swift
//  MicroAnimation
//
//  Created by Станислав Тищенко on 09.08.2018.
//  Copyright © 2018 Станислав Тищенко. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {

    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.tag == 8 {
            let imageSize: CGSize = self.imageView!.image!.size
            self.setTitle("< Slide to cancel", for: .normal)
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width*2, 0, 0);
            self.setTitleColor(UIColor.black, for: .normal)
            self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0.0, 0);
            self.titleLabel?.numberOfLines = 0;
            self.titleLabel?.adjustsFontSizeToFitWidth = true;
            self.translatesAutoresizingMaskIntoConstraints = true
            self.titleLabel?.font = UIFont(name: "", size: 1)
            if let touch = touches.first {
                let position = touch.location(in: self.viewWithTag(1))
                if position.x < UIScreen.main.bounds.midX {
                    self.setTitle("", for: .normal)
                    self.setImage(UIImage(named: "cancel"), for: .highlighted)
                    if let firstView = superview?.viewWithTag(5) as! UIView? {
                        firstView.backgroundColor = UIColor.red

                        if let secondView = superview?.viewWithTag(6) as! UIView? {
                            secondView.backgroundColor = UIColor.red
                        }
                    }
                } else {
                    self.setImage(UIImage(named: "woBack"), for: .highlighted)
                    if let firstView = superview?.viewWithTag(5) as! UIView? {
                        firstView.backgroundColor = UIColor.blue

                        if let secondView = superview?.viewWithTag(6) as! UIView? {
                            secondView.backgroundColor = UIColor.blue
                        }
                    }
                }
                if position.x > UIScreen.main.bounds.minX + 10 + self.frame.width/2 &&
                    position.x < UIScreen.main.bounds.maxX - 10 - self.frame.width/2 {
                    self.frame = CGRect(x: Int(position.x - self.frame.width/2), y: Int(UIScreen.main.bounds.midY), width: Int(self.frame.width), height: Int(self.frame.height))

                    if let firstView = superview?.viewWithTag(5) as! UIView? {
                        firstView.frame = CGRect(x: Int(position.x - firstView.frame.width/2), y: Int(UIScreen.main.bounds.midY - firstView.frame.height/4), width: Int(firstView.frame.width), height: Int(firstView.frame.height))

                        if let secondView = superview?.viewWithTag(6) as! UIView? {
                            secondView.frame = CGRect(x: Int(position.x - secondView.frame.width/2), y: Int(UIScreen.main.bounds.midY - secondView.frame.height/4), width: Int(secondView.frame.width), height: Int(secondView.frame.height))
                        }
                    }
                    self.imageView?.layer.masksToBounds = false
                    self.imageView?.layer.borderColor = UIColor.white.cgColor
                    self.imageView?.layer.cornerRadius = (self.imageView?.frame.height)!/2
                    self.imageView?.clipsToBounds = true
                }
            }
        }
    }
}

