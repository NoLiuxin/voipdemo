//
//  CalculatorButton.swift
//  ChartTestDemo
//
//  Created by 刘新 on 2018/9/6.
//  Copyright © 2018年 Liuxin. All rights reserved.
//

import UIKit

class CalculatorButton: UIControl {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    public var value: Int = 0 {
        didSet { label.text = "\(value)"}
    }

    private lazy var label: UILabel = {
        let tempLabel = UILabel.init()
        return tempLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(touchDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchDragExit, .touchCancel])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func touchDown() {
        
    }
    
    @objc private func touchUp() {
        
    }
    
    
}
