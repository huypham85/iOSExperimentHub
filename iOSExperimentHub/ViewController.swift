//
//  ViewController.swift
//  iOSExperimentHub
//
//  Created by HuyPT3 on 19/03/2024.
//

import UIKit

class ViewController: UIViewController {
    var animator: UIViewPropertyAnimator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(slider)
        slider.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32).isActive = true
        slider.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)

        
        let redBox = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 128))
        redBox.translatesAutoresizingMaskIntoConstraints = false
        redBox.backgroundColor = UIColor.red
        redBox.center.y = view.center.y
        view.addSubview(redBox)
        
        animator = UIViewPropertyAnimator(duration: 3, curve: .linear) {
            redBox.frame = CGRect(x: redBox.frame.minX, y: redBox.frame.minY, width: UIScreen.main.bounds.width, height: redBox.frame.height)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.animator.startAnimation()
        })
    }
    
    @objc func sliderChanged(_ sender: UISlider) {
        animator.fractionComplete = CGFloat(sender.value)
    }
    
}

