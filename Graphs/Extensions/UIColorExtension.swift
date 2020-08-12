//
//  UIColorExtension.swift
//  Graphs
//
//  Created by MG on 12.08.2020.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func random() -> UIColor {
        
        let r = Float.random(in: 0...1)
        let g = Float.random(in: 0...1)
        let b = Float.random(in: 0...1)
        
        return UIColor (red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1.0)
    }
    
}
