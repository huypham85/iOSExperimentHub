//
//  ViewController.swift
//  iOSExperimentHub
//
//  Created by HuyPT3 on 19/03/2024.
//

import UIKit

class ViewController: UIViewController {
    var animator: UIViewPropertyAnimator!
    
    let slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start Animation", for: .normal)
        button.backgroundColor = UIColor.lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let redBox: UIView = {
        let redBox = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 128))
        redBox.translatesAutoresizingMaskIntoConstraints = false
        redBox.backgroundColor = UIColor.red
        return redBox
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
        
        // create the animation and start later by calling startAnimation()
        animator = UIViewPropertyAnimator(duration: 5, curve: .linear) { [weak self] in
            guard let self else { return }
            self.redBox.frame = CGRect(x: self.redBox.frame.minX,
                                       y: redBox.frame.minY,
                                       width: UIScreen.main.bounds.width,
                                       height: self.redBox.frame.height)
        }
        
        animator.addAnimations ({ [weak self] in
            guard let self else { return }
            self.redBox.transform = CGAffineTransform(rotationAngle: CGFloat.pi).scaledBy(x: 1, y: 1.3)
        }, delayFactor: 0)
        
        
        
    }
    
    @objc func sliderChanged(_ sender: UISlider) {
        animator.fractionComplete = CGFloat(sender.value)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        self.animator.startAnimation()
    }
    
    private func setupView() {
        view.addSubview(slider)
        NSLayoutConstraint.activate([
            slider.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32),
            slider.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: slider.topAnchor, constant: -24),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        redBox.center.y = view.center.y
        view.addSubview(redBox)
    }
    
    /// start the animation immediately after the creation
    private func immediatelyStartAnimation() {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 3, delay: 1, options: .curveEaseInOut) {[weak self] in
            guard let self else { return }
            self.redBox.frame = CGRect(x: self.redBox.frame.minX,
                                       y: redBox.frame.minY,
                                       width: UIScreen.main.bounds.width,
                                       height: self.redBox.frame.height)
        } completion: { UIViewAnimatingPosition in
            print("end animation")
        }
    }
    
}

