//
//  ViewController.swift
//  iOSDemo
//
//  Created by EZen on 2021/10/18.
//

import UIKit
import BatteryWidget

class ViewController: UIViewController {

    fileprivate let batterySize = CGSize(width: 120, height: 60)
    
    lazy var battery = Battery(size: batterySize)
    
    lazy var refresh: UIButton = {
        let button = UIButton()
        button.setTitle("刷新", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = .orange
        button.layer.cornerRadius = 10
        button.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        button.addTarget(self, action: #selector(refresh(sender:)), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        view.addSubview(battery)
        view.addSubview(refresh)
        
        battery.translatesAutoresizingMaskIntoConstraints = false
        battery.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        battery.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        battery.heightAnchor.constraint(equalToConstant: batterySize.height).isActive = true
        battery.widthAnchor.constraint(equalToConstant: batterySize.width).isActive = true
        
        refresh.translatesAutoresizingMaskIntoConstraints = false
        refresh.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        refresh.topAnchor.constraint(equalTo: battery.bottomAnchor, constant: 40).isActive = true
        refresh.heightAnchor.constraint(equalToConstant: 40).isActive = true
        refresh.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        /// `Debug log信息`
        battery.debugMode = true
        /// `精准度`
        battery.highAccuracy = true
    }
    
    
    @objc func refresh(sender: UIButton) {
        let progress = CGFloat.random(in: 0...1)
        battery.progress = progress
    }
}

