//
//  ViewController.swift
//  Graphs
//
//  Created by MG on 11.08.2020.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private let offsetForChartView: CGFloat = 10.0
    
    private var chartView = MyChart()
    static var modelLabel = UILabel()
    
    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        addDrawingView()
        addModelLabel()
    }
    
}

//MARK: - UIContentContainer

extension ViewController {
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
        }) { _ in
            self.chartView.draw(CGRect(x: 0, y: 0, width: self.chartView.bounds.width, height: self.chartView.bounds.height))
        }
    }
    
}

//MARK: - Private

private extension ViewController {
    
    func addDrawingView() {
        
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.backgroundColor = .blue
        view.addSubview(chartView)
        
        NSLayoutConstraint.activate([
            chartView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: offsetForChartView),
            chartView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -offsetForChartView),
            chartView.heightAnchor.constraint(equalToConstant: min(view.bounds.width - offsetForChartView*2, view.bounds.height)),
            chartView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func addModelLabel() {
        
        ViewController.modelLabel = UILabel(frame: CGRect(x: 65, y: 50, width: 100, height: 30))
        ViewController.modelLabel.text = MyChart().modelOnScreen == MyChart().modelA ? "Model A" : "Model B"
        ViewController.modelLabel.backgroundColor = UIColor(white: 1, alpha: 0.5)
        ViewController.modelLabel.textAlignment = .center
        ViewController.modelLabel.textColor = .orange
        view.addSubview(ViewController.modelLabel)
        
    }
    
}

