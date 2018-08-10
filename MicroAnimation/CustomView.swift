//
//  CustomView.swift
//  MicroAnimation
//
//  Created by Станислав Тищенко on 06.08.2018.
//  Copyright © 2018 Станислав Тищенко. All rights reserved.
//

import UIKit
import Toaster

class CustomView: UIView {
    var timer: Timer?
    var timeInterval: TimeInterval = 0.0
    var seconds: Int = 0
    var minutes: Int = 0
    var backViewFirst = UIView()
    var backViewSeconds = UIView()
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet var view: UIView!
    
    @IBAction func buttonTouchDown(_ sender: Any) {
        print("start")
        tapButton()

    }

    @IBAction func buttonTouchUpInside(_ sender: Any) {
        print("finish in")
        buttonTouchUp()
        backViewFirst.isHidden = true
        backViewSeconds.isHidden = true
    }
    @IBAction func buttonTouchUpOutside(_ sender: Any) {
        print("finish out")
        buttonTouchUp()
        backViewFirst.isHidden = true
        backViewSeconds.isHidden = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }

    func initSubviews() {
        DispatchQueue.main.async{
            self.backViewFirst.tag = 5
            self.insertSubview(self.backViewFirst, at: 1)
            self.backViewSeconds.tag = 6
            self.insertSubview(self.backViewSeconds, at: 2)
            self.insertSubview(self.button, at: 3)

            self.timerLabel.isHidden = true
            self.textField.frame = CGRect(x: Int(self.textField.frame.minX), y: Int(UIScreen.main.bounds.midY),
                                          width: Int(UIScreen.main.bounds.maxX - self.textField.frame.minX * 2),
                                          height: Int(self.button.frame.height))
            self.button.frame = CGRect(x: Int(self.textField.frame.maxX - self.button.frame.width - 5),
                                       y: Int(UIScreen.main.bounds.midY), width: Int(self.button.frame.width),
                                       height: Int(self.button.frame.height))
            self.button.setImage(UIImage(named: "micro"), for: .highlighted)
            self.timerLabel.frame = CGRect(x: UIScreen.main.bounds.midX - self.timerLabel.frame.width / 2,
                                           y: self.textField.frame.minY - 20,
                                           width: self.timerLabel.frame.width,
                                           height: self.timerLabel.frame.height)
        }
        let nib = UINib(nibName: "CustomView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        view.frame = bounds
        addSubview(view)
    }

    @objc func increaseTimer() {
        timeInterval += 1
        var miliSeconds = Int(timeInterval)
        if miliSeconds == 100 {
            seconds += miliSeconds % 99
            timeInterval = 0
            miliSeconds = 0
        }
        if seconds == 60 {
            minutes += seconds % 59
            seconds = 0
        }
        timerLabel.sizeToFit()
        timerLabel.adjustsFontSizeToFitWidth = true
        timerLabel.text =  String("\(minutes):\(seconds):\(miliSeconds)")
    }

    func timerToZero() {
        seconds = 0
        minutes = 0
        timeInterval = 0.0
    }

    func buttonTouchUp() {
        button.setTitle("", for: .normal)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0.0, 0);
        self.button.frame = CGRect(x: Int(self.textField.frame.maxX - self.button.frame.width - 5),
                                   y: Int(UIScreen.main.bounds.midY), width: Int(self.button.frame.width),
                                   height: Int(self.button.frame.height))
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        timerToZero()
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut], animations: {
            self.timerLabel.center.y += CGFloat(10)
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.timerLabel.isHidden = true
        })

        var infoAboutFinishTimer: String?
        if button.image(for: .highlighted) == UIImage(named: "cancel") {
            infoAboutFinishTimer = "Action cancelled! Time \(timerLabel.text!)"
        } else {
            infoAboutFinishTimer = "Action submitted! Time \(timerLabel.text!)"
        }
        Toast(text: infoAboutFinishTimer, delay: 0, duration: 0.3).show()
    }

    func tapButton() {
        timerToZero()
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self,
                                         selector: #selector(self.increaseTimer),
                                         userInfo: nil, repeats: true)
        }
        timerLabel.isHidden = false
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut], animations: {
            self.timerLabel.center.y -= CGFloat(10)
            self.view.layoutIfNeeded()
        }, completion: nil)
        backViewFirst.isHidden = false
        backViewSeconds.isHidden = false

        backViewFirst.backgroundColor = UIColor.blue
        backViewFirst.alpha = 0.2
        backViewFirst.frame = CGRect(x: Int(button.frame.midX - button.frame.width/2) - 10 , y: Int(UIScreen.main.bounds.midY) - 10, width: Int(button.frame.width) + 20, height: Int(button.frame.height) + 20)
        backViewFirst.layer.masksToBounds = false
        backViewFirst.layer.borderColor = UIColor.black.cgColor
        backViewFirst.layer.cornerRadius = (button.imageView?.frame.height)!/2
        backViewFirst.clipsToBounds = true

        backViewSeconds.frame = CGRect(x: Int(backViewFirst.frame.midX), y: Int(backViewFirst.frame.midY), width: 0, height: 0)
        backViewSeconds.backgroundColor = UIColor.blue
        var secondViewRadius = 0
        UIView.animate(withDuration: 0.3, animations: {
            while Int(self.backViewFirst.frame.height) - secondViewRadius > 5 {
                self.backViewSeconds.frame = CGRect(x: Int(self.backViewFirst.frame.midX) - secondViewRadius / 2, y: Int(self.self.backViewFirst.frame.midY) - secondViewRadius / 2, width: secondViewRadius, height: secondViewRadius)
                secondViewRadius += 1
                self.backViewSeconds.layer.masksToBounds = false
                self.backViewSeconds.layer.borderColor = UIColor.black.cgColor
                self.backViewSeconds.layer.cornerRadius = (self.backViewSeconds.frame.height)/2
                self.backViewSeconds.clipsToBounds = true
            }
        })
    }
}

