//
//  BaseView.swift
//  WeatherApp
//
//  Created by Vlad Kolesnykov on 11.07.17.
//  Copyright © 2017 Vladyslav Kolesnykov. All rights reserved.
//

import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }

    private func xibSetup() {
        guard let view = viewFromNib() else {
            return
        }
        
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addBlurEffect(style: UIBlurEffect.Style.dark)
        self.initializeProperties()
        
        addSubview(view)
    }
    
    private func viewFromNib() -> UIView? {
        guard let nibName = NSStringFromClass(type(of: self)).components(separatedBy: ".").last else {
            fatalError("No class name")
        }
        
        let nib = UINib(nibName: nibName, bundle: Bundle(for: type(of: self)))
        let nibs = nib.instantiate(withOwner: self, options: nil)
        
        return nibs.first as? UIView
    }
    
    
    func initializeProperties() {
    }
}
