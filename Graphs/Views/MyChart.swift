//
//  MyChart.swift
//  Graphs
//
//  Created by MG on 11.08.2020.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit

class MyChart: UIView {
    
    var modelA: ChartModel?
    private var modelB: ChartModel?
    var modelOnScreen: ChartModel?
    
    private var shapeLayers = [CAShapeLayer]()
    private var horizontalLinesLayer = CAShapeLayer()
    
    private let widthForNumberLabels: CGFloat = 30 // set 0 if you want hide Number Labels
    private var widthForColumn: CGFloat = 10.0
    private let offsetForColumn: CGFloat = 10.0
    private var numberOfColumns: Int { Int.random(in: 5...10) }
    private let maxValuesForColumn: CGFloat = 100
    
    private var widthForGrid: CGFloat { self.bounds.height / 10 }
    
    private var isFirstStart = true
    
    
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        modelA = ChartModel.createRandomChartModelWith(count: numberOfColumns, maxValue: maxValuesForColumn)
        modelB = ChartModel.createRandomChartModelWith(count: numberOfColumns, maxValue: maxValuesForColumn)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - Drawing
    
    override func draw(_ rect: CGRect) {
        if !isFirstStart {
            //Used when screen rotating for smoothly hide columns
            for layer in self.shapeLayers {
                self.addHiddenAnimationForLayer(layer, isHidden: true, from: 1.0, to: 0)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                guard let modelA = self.modelA else { return }
                self.drawHorizontalLines()
                self.drawsChart(model: self.modelOnScreen ?? modelA)
            }
            
        } else {
            guard let modelA = modelA else { return }
            drawHorizontalLines()
            drawsChart(model: modelOnScreen ?? modelA)
        }
    }

}

//MARK: - Drawing functions

private extension MyChart {
    
    func drawsChart(model: ChartModel) {
        
        modelOnScreen = model
        ViewController.modelLabel.text = modelOnScreen == modelA ? "Model A" : "Model B"
        
        for layer in shapeLayers {
            layer.removeFromSuperlayer()
        }
        createColumsFrom(model)
        guard isFirstStart else { return }
        showNextChart()
    }
    
    func drawHorizontalLines() {
        horizontalLinesLayer.removeFromSuperlayer()
        
        let path = UIBezierPath()
        for numberOfLine in 1...10 {
            
            let numberLabel = UILabel(frame: CGRect(x: 0, y: self.bounds.height - widthForGrid * CGFloat(numberOfLine), width: widthForNumberLabels, height: 15))
            numberLabel.text = "\(numberOfLine * 10)"
            self.addSubview(numberLabel)
            
            path.move(to: CGPoint(x: 0, y:Int(self.bounds.height - widthForGrid * CGFloat(numberOfLine))))
            path.addLine(to: CGPoint(x: Int(self.bounds.width), y:Int(self.bounds.height - widthForGrid * CGFloat(numberOfLine))))
        }
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.gray.cgColor
        layer.lineWidth = 0.5
        self.layer.addSublayer(layer)
        horizontalLinesLayer = layer
    }
    
    func createColumsFrom(_ model: ChartModel) {
        
        widthForColumn = ((self.bounds.width - offsetForColumn - widthForNumberLabels) / CGFloat(model.values.count)) - offsetForColumn
        for value in 1...model.values.count {
            
            let path = UIBezierPath()
            let yRatio = Int(self.bounds.height / 100)
            path.move(to: CGPoint(x: Int(offsetForColumn + widthForColumn) * value + Int(widthForNumberLabels - widthForColumn/2), y: Int(self.bounds.height)))
            path.addLine(to: CGPoint(x: Int(offsetForColumn + widthForColumn) * value + Int(widthForNumberLabels - widthForColumn/2), y: Int(model.values[value - 1]) * yRatio))
            
            let layer = CAShapeLayer()
            layer.path = path.cgPath
            layer.fillColor = UIColor.clear.cgColor
            layer.strokeColor = model.colors[value - 1].cgColor
            layer.lineWidth = widthForColumn
            self.layer.addSublayer(layer)
            shapeLayers.append(layer)
            
            addHiddenAnimationForLayer(layer, isHidden: false, from: 0.0, to: 1.0)
        }
    }
    
}

//MARK: - Private

private extension MyChart {
    
    func showNextChart() {
        isFirstStart = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            for layer in self.shapeLayers {
                self.addHiddenAnimationForLayer(layer, isHidden: true, from: 1.0, to: 0)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                guard let modelB = self.modelB else { return }
                self.drawsChart(model: modelB)
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
                self.addGestureRecognizer(tap)
            }
        }
    }
    
    func addHiddenAnimationForLayer(_ layer: CAShapeLayer, isHidden: Bool, from startValue: CGFloat, to endValue: CGFloat) {
        //Stop Gestures
        if let gestureRecognizers = self.gestureRecognizers {
            for gesture in gestureRecognizers {
                gesture.isEnabled = false
                self.gestureRecognizers = gestureRecognizers
            }
            //Start Gestures
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) {
                for gesture in gestureRecognizers {
                    gesture.isEnabled = true
                    self.gestureRecognizers = gestureRecognizers
                }
            }
        }
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 1
        pathAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        pathAnimation.fromValue = startValue
        pathAnimation.toValue = endValue
        pathAnimation.autoreverses = false
        layer.add(pathAnimation, forKey: "strokeEndAnimation")
        
        if isHidden {
            layer.strokeStart = 0
        } else {
            layer.strokeEnd = 1.0
        }
    }
    
}

//MARK: - Gestures

extension MyChart {
    
    @objc func handleTap() {
        
        for layer in self.shapeLayers {
            addHiddenAnimationForLayer(layer, isHidden: true, from: 1.0, to: 0)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            guard let modelB = self.modelB, let modelA = self.modelA else { return }
            if self.modelOnScreen == modelA {
                self.drawsChart(model: modelB)
            } else {
                self.drawsChart(model: modelA)
            }
        }
    }
    
}
