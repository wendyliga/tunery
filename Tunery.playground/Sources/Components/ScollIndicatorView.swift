//
//  ScollIndicatorView.swift
//  Tunery
//
//  Created by Wendy Liga on 10/05/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import UIKit

protocol ScrollIndicatorDelegate: AnyObject {
    /**
     Will be triggered when scroll indicator view is panned, and send its percentage value
     */
    func didScroll(to percentage: CGFloat)
    
    /**
     Will be triggered when go to top button tapped
     */
    func scrollToTop()
    
    /**
     Will be triggered when go to buttom button tapped
     */
    func scrollToBottom()
    
    /**
     How far offset scroll content size compare to scroll frame.
     */
    var screenOffset: CGFloat { get }
}

final class ScrollIndicatorView: UIView {
    
    // MARK: - Views
    
    weak var delegate: ScrollIndicatorDelegate?
    
    // MARK: - Values
    
    /**
     current view top padding
     */
    private let topPadding: CGFloat = 12
    
    /**
     Helper variable to safe starting constant before continious pan, so pan value that set to topAnchor not overlapping with next or previous value ( will multiply value like crazy )
     */
    private var topConstantBeforeTranslation: CGFloat = 0
    
    /**
     Minimum slider can go
     */
    private var minTranslation: CGFloat {
        topPadding
    }
    
    /// maximum slider can go
    ///
    /// this will indicate how many space left slider can go, determining by the available rails (parent view height minus other components) substract bottom padding and indicator view height itself and add minTranslation as start point
    private var maxTranslation: CGFloat {
        /// representing other components height, like top button dan bottom button
        let otherComponents = (topButton.frame.maxY + topPadding) * 2
        
        return frame.height - otherComponents - indicatorView.frame.height + minTranslation
    }
    
    // MARK: - Views
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .silverChalice
        view.alpha = 0.5
        
        view.layer.cornerRadius = 18
        view.layer.borderWidth = 6
        view.layer.borderColor = UIColor.laurelGreen.cgColor
        
        return view
    }()
    
    private lazy var topButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.titleLabel?.font = .boldSystemFont(ofSize: 22)
        button.setTitle("▲", for: .normal)
        button.setTitleColor(.laurelGreen, for: .normal)
        button.setTitleColor(UIColor.laurelGreen.withAlphaComponent(0.5), for: .highlighted)
        
        button.layer.cornerRadius = 18
        button.layer.borderWidth = 6
        button.layer.borderColor = UIColor.laurelGreen.cgColor
        
        button.addTarget(self, action: #selector(topTap), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var bottomButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.titleLabel?.font = .boldSystemFont(ofSize: 22)
        button.setTitle("▼", for: .normal)
        button.setTitleColor(.laurelGreen, for: .normal)
        button.setTitleColor(UIColor.laurelGreen.withAlphaComponent(0.5), for: .highlighted)
        
        button.layer.cornerRadius = 18
        button.layer.borderWidth = 6
        button.layer.borderColor = UIColor.laurelGreen.cgColor
        
        button.addTarget(self, action: #selector(buttomTap), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var topIndicatorConstraint = indicatorView.topAnchor.constraint(equalTo: topButton.bottomAnchor, constant: topPadding)
    
    private lazy var indicatorHeight = indicatorView.heightAnchor.constraint(equalTo: indicatorView.widthAnchor)
    
    // MARK: - Life Cycle
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .paleSpringBud
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(indicatorView)
        addSubview(topButton)
        addSubview(bottomButton)
        
        NSLayoutConstraint.activate([
            topButton.topAnchor.constraint(equalTo: topAnchor, constant: topPadding),
            topButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            topButton.widthAnchor.constraint(equalToConstant: 36),
            topButton.heightAnchor.constraint(equalTo: topButton.widthAnchor),
            
            topIndicatorConstraint,
            indicatorView.widthAnchor.constraint(equalToConstant: 36),
            indicatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            bottomButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -topPadding),
            bottomButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            bottomButton.widthAnchor.constraint(equalToConstant: 36),
            bottomButton.heightAnchor.constraint(equalTo: topButton.widthAnchor),
        ])
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan))
        indicatorView.addGestureRecognizer(panGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        calculateIndicatorHeight()
    }
    
    // MARK: - Function
    
    @objc
    private func pan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self)
        
        if sender.state == .began {
            // save start point
            topConstantBeforeTranslation = topIndicatorConstraint.constant
            
            // set slider focus
            indicatorView.alpha = 1
        }
        
        if sender.state == .changed {
            let min = minTranslation
            let max = maxTranslation
            
            animateScrollIndicator(topConstant: translation.y) { [weak self] newConstant in
                let percentage = (newConstant - 12) / (max - min)
                
                // send percentage to delegate
                self?.delegate?.didScroll(to: percentage)
            }
        }
        
        if sender.state == .ended {
            // erase temp start point
            topConstantBeforeTranslation = .zero
            
            // set slider unfocus
            indicatorView.alpha = 0.5
        }
    }
    
    @objc
    private func topTap() {
        delegate?.scrollToTop()
        
        // update scroll indicator
        animateScrollIndicator(withDuration: 0.3, topConstant: minTranslation)
    }
    
    @objc
    private func buttomTap() {
        delegate?.scrollToBottom()
        
        // update scroll indicator
        animateScrollIndicator(withDuration: 0.3, topConstant: maxTranslation)
    }
    
    /**
     Animate Scroll Indicator
     
     - Parameters:
        - withDuration: how long animation run, default none
        - topConstant: top constant the length scroll indicator should go from top anchor, if used on pan gesture, value `topConstantBeforeTranslation` will be a placeholder as start point, and top constant should be filled with additional translation value from pan gesture.if you want to animate normal make sure `topConstantBeforeTranslation` is zero, and set full constraint value
        - completion: will call after refresh the view, will new calculated constant on how far scroll indicator from top.
     */
    private func animateScrollIndicator(
        withDuration duration: TimeInterval = .zero,
        topConstant: CGFloat,
        completion: ((CGFloat) -> Void)? = nil
    ) {
        // if scroll doesnt have offset content size
        guard maxTranslation > minTranslation else { return }
        
        /// newConstant will determine slider position, safe the value to not go outside bounds with clamp
        let newConstant = (topConstantBeforeTranslation + topConstant).clamp(minTranslation...maxTranslation)
        
        // update constraint
        topIndicatorConstraint.constant = newConstant
        
        UIView.animate(withDuration: duration, animations: { [weak self] in
            // update view
            self?.layoutIfNeeded()
        }) { _ in
            completion?(newConstant)
        }
    }
    
    func scrollTo(_ percentage: CGFloat) {
        // if scroll doesnt have offset content size
        guard maxTranslation > minTranslation else { return }
        
        let newConstant = (maxTranslation * percentage).clamp(minTranslation...maxTranslation)
        
        animateScrollIndicator(topConstant: newConstant)
    }
    
    private func calculateIndicatorHeight() {
        // offset need to substract from indicator height
        let offset = abs(delegate?.screenOffset ?? 0)
        
        let startY = (topButton.frame.maxY + topPadding) * 2
        
        /// calculate rest of size for slider
        ///
        /// by substract frame height with bottom padding (topPadding) and starting possible slider at bottom goToTopButton and also how far scroll view offset
        let endY = bounds.height - startY - offset
        
        let height = (endY - startY).clamp(44...bounds.height - startY)

        // applying constraint
        indicatorHeight = indicatorView.heightAnchor.constraint(equalToConstant: height)
        indicatorHeight.isActive = true

        // update layout
        layoutIfNeeded()
    }
    
    func refreshScreenOffset() {
        calculateIndicatorHeight()
    }
}
