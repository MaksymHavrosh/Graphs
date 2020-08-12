//
//  ChartModel.swift
//  Graphs
//
//  Created by MG on 12.08.2020.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit

struct ChartModel: Equatable {
    
    var values: [CGFloat]
    let colors: [UIColor]
    
    
    static func createRandomChartModelWith(count: Int, maxValue: CGFloat) -> ChartModel {
        
        var values = [CGFloat]()
        var colors = [UIColor]()
        for _ in 0..<count {
            
            let value = CGFloat.random(in: 0...maxValue)
            values.append(value)
            colors.append(.random())
        }
        return ChartModel(values: values, colors: colors)
    }
    
}


