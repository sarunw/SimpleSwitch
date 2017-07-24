//
//  SimpleSwitch.swift
//  Pods
//
//  Created by Sarun Wongpatcharapakorn on 10/5/16.
//
//

import UIKit

private let springDamping: CGFloat = 0.5
private let animationDuration: TimeInterval = 0.6
private let switchThumbMultiplier: CGFloat = 1.3

@IBDesignable
open class SimpleSwitch: UIControl {
    
    open var switchThumb: UIView!
    open var backgroundView: UIView!
    
    private var leadingConstraint: NSLayoutConstraint!
    private var trailingConstraint: NSLayoutConstraint!
    private var topConstraint: NSLayoutConstraint!
    private var bottomConstraint: NSLayoutConstraint!
    private var widthConstraint: NSLayoutConstraint!
    
    private var _isOn: Bool = true
    
    /// A Boolean value that determines the off/on state of the switch.
    @IBInspectable open var isOn: Bool {
        set {
            _isOn = newValue
            
            if newValue == true {
                changeToOn(animated: false)
            } else {
                changeToOff(animated: false)
            }
        }
        
        get {
            return _isOn
        }
    }
    
    /// Insets between thumb and outline
    @IBInspectable open var minimumThumbSpacing: CGFloat = 0 {
        didSet {
            
            print("set constant \(minimumThumbSpacing)")
            trailingConstraint.constant = -minimumThumbSpacing
            leadingConstraint.constant = minimumThumbSpacing
            topConstraint.constant = minimumThumbSpacing
            bottomConstraint.constant = -minimumThumbSpacing
            
//            leadingConstraint.isActive = false
//            leadingConstraint = switchThumb.leadingAnchor.constraint(equalTo: leadingAnchor, constant: minimumThumbSpacing)
//            leadingConstraint.isActive = !isOn
//            
//            trailingConstraint.isActive = false
//            trailingConstraint = switchThumb.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -minimumThumbSpacing)
//            trailingConstraint.isActive = isOn
//            
//            topConstraint.isActive = false
//            topConstraint = switchThumb.topAnchor.constraint(equalTo: topAnchor, constant: minimumThumbSpacing)
//            topConstraint.isActive = true
//            
//            bottomConstraint.isActive = false
//            bottomConstraint = switchThumb.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -minimumThumbSpacing)
//            bottomConstraint.isActive = true
            
            setNeedsLayout()
            updateConstraintsIfNeeded()
            layoutIfNeeded()
        }
    }
    
    /// The color used to tint the appearance of the switch when it is turned on.
    @IBInspectable open var onTintColor: UIColor? {
        didSet {
            updateBackgroundColor()
        }
    }
    
    /// The color used to tint the appearance of the switch when it is turned off.
    @IBInspectable open var offTintColor: UIColor? {
        didSet {
            updateBackgroundColor()
        }
    }
    
    private func updateBackgroundColor() {
        if isOn == true {
            backgroundView.backgroundColor = onTintColor ?? UIColor(red: 76.0/255.0, green: 216.0/255.0, blue: 100.0/255.0, alpha: 1)
        } else {
            backgroundView.backgroundColor = offTintColor ?? UIColor.gray
        }
    }
    
    /// The color used to tint the appearance of the thumb.
    @IBInspectable open var thumbTintColor: UIColor? {
        didSet {
            switchThumb.backgroundColor = thumbTintColor ?? UIColor.white
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public func setOn(_ on: Bool, animated: Bool) {
        _isOn = on
        
        if on {
            changeToOn(animated: animated)
        } else {
            changeToOff(animated: animated)
        }
    }
    
    private func commonInit() {
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.switchAreaTapped(sender:)))
        addGestureRecognizer(singleTap)
        
        backgroundView = UIView(frame: bounds)
        backgroundView.translatesAutoresizingMaskIntoConstraints = true
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundView.isUserInteractionEnabled = false
        backgroundView.layer.masksToBounds = true
        backgroundView.layer.cornerRadius = bounds.size.height / 2
        
        addSubview(backgroundView)
//        
//        backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//        backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//        backgroundView.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        switchThumb = UIView(frame: thumbRect)
        switchThumb.translatesAutoresizingMaskIntoConstraints = false
        switchThumb.layer.masksToBounds = true
        switchThumb.isUserInteractionEnabled = false
        
        addTarget(self, action: #selector(self.switchThumbTapped(sender:)), for: .touchUpInside)
        addTarget(self, action: #selector(self.onTouchDown(sender:)), for: .touchDown)
        
        addTarget(self, action: #selector(self.onShrink(sender:)), for: .touchUpInside)
        addTarget(self, action: #selector(self.onShrink(sender:)), for: .touchUpOutside)
        addTarget(self, action: #selector(self.onShrink(sender:)), for: .touchCancel)
        
        addTarget(self, action: #selector(self.onTouchDragInside(sender:withEvent:)), for: .touchDragInside)
        addTarget(self, action: #selector(self.onTouchUpOutsideOrCanceled(sender:)), for: .touchUpOutside)
        addTarget(self, action: #selector(self.onTouchUpOutsideOrCanceled(sender:)), for: .touchCancel)
        
        addSubview(switchThumb)
        
        leadingConstraint = switchThumb.leadingAnchor.constraint(equalTo: leadingAnchor)
        leadingConstraint.isActive = true
        
        trailingConstraint = switchThumb.trailingAnchor.constraint(equalTo: trailingAnchor)
        trailingConstraint.isActive = false
        
        topConstraint = switchThumb.topAnchor.constraint(equalTo: topAnchor)
        topConstraint.isActive = true
        
        bottomConstraint = switchThumb.bottomAnchor.constraint(equalTo: bottomAnchor)
        bottomConstraint.isActive = true
        
        widthConstraint = switchThumb.widthAnchor.constraint(equalTo: switchThumb.heightAnchor)
        widthConstraint.isActive = true
        
        
        thumbTintColor = nil
        offTintColor = nil
        minimumThumbSpacing = 5
        
        setOn(true, animated: false)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundView.layer.cornerRadius = bounds.size.height / 2
        switchThumb.layer.cornerRadius = thumbRect.size.height / 2
        
//        if isOn == true {
//            switchThumb.frame = thumbOnFrame
//        } else {
//            switchThumb.frame = thumbOffFrame
//        }
    }
    
    open override var isEnabled: Bool {
        didSet {
            if isEnabled {
                backgroundView.alpha = 1
            } else {
                backgroundView.alpha = 0.5
            }
        }
    }
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: 51, height: 31)
    }
    
    // MARK: - Actions
    private var originalValue: Bool?
    private var touchBegin: CGPoint?
    private var alreadyToggle: Bool = false // boolean state that ui already toggle
    
    func onTouchDragInside(sender: UIButton, withEvent event: UIEvent) {
        guard let touch = event.touches(for: sender)?.first else {
            return
        }
        
        let pos = touch.location(in: sender)
        touchBegin = touchBegin ?? pos
        originalValue = originalValue ?? isOn
        guard let prevPos = touchBegin else {
            return
        }
        
        let dx = pos.x - prevPos.x
        
        if abs(dx) > bounds.size.width / 2 {
            alreadyToggle = true
            if dx > 0 {
//                var frame = switchThumb.frame
//                frame.origin.x += abs(dx) * 0.5
//                switchThumb.frame = frame
                
                setOn(true, animated: true)
            } else {
//                var frame = switchThumb.frame
//                frame.origin.x -= abs(dx) * 0.5
//                switchThumb.frame = frame
                
                setOn(false, animated: true)
            }
            touchBegin = pos
        }
    }
    
    func onTouchUpOutsideOrCanceled(sender: AnyObject) {
        toggleThumbState()
    }
    
    func onShrink(sender: AnyObject) {
        shrinkSwitchThumb()
    }
    
    func onTouchDown(sender: AnyObject) {
        expandSwitchThumb()
    }
    
    private func shrinkSwitchThumb() {
        if isOn {
            widthConstraint.isActive = false
            widthConstraint = switchThumb.widthAnchor.constraint(equalTo: switchThumb.heightAnchor, multiplier: 1)
            widthConstraint.isActive = true
            
//            leadingConstraint.constant = self.bounds.size.width - self.thumbRect.size.width - (self.minimumThumbSpacing ?? 0)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.layoutIfNeeded()
            })
        } else {
            widthConstraint.isActive = false
            widthConstraint = switchThumb.widthAnchor.constraint(equalTo: switchThumb.heightAnchor, multiplier: 1)
            widthConstraint.isActive = true
            
            UIView.animate(withDuration: 0.3, animations: {
                self.layoutIfNeeded()
            })
        }
    }
    
    private func expandSwitchThumb() {
        if isOn {
            widthConstraint.isActive = false
            widthConstraint = switchThumb.widthAnchor.constraint(equalTo: switchThumb.heightAnchor, multiplier: switchThumbMultiplier)
            widthConstraint.isActive = true
            
//            leadingConstraint.constant = self.bounds.size.width - self.thumbRect.size.width * 1.5 - (self.minimumThumbSpacing ?? 0)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.layoutIfNeeded()
            })
        } else {
            widthConstraint.isActive = false
            widthConstraint = switchThumb.widthAnchor.constraint(equalTo: switchThumb.heightAnchor, multiplier: switchThumbMultiplier)
            widthConstraint.isActive = true
            
            UIView.animate(withDuration: 0.3, animations: {
                self.layoutIfNeeded()
            })
        }
    }
    
    func switchAreaTapped(sender: AnyObject) {
        // Prevent passing touch to underlying view
        // TODO: find a better way to do this
    }
    
    func switchThumbTapped(sender: AnyObject) {
        toggleThumbState()
    }
    
    private func toggleThumbState() {
        touchBegin = nil
        
        if alreadyToggle {
            alreadyToggle = false
            
            if originalValue != isOn {
                sendActions(for: .valueChanged)
            }
            originalValue = nil
            return
        }
        
        originalValue = nil
        alreadyToggle = false
        
        if isOn == true {
            setOn(false, animated: true)
        } else {
            setOn(true, animated: true)
        }
        
        sendActions(for: .valueChanged)
    }
    
    private func changeToOff(animated: Bool) {
        let animations = {
//            self.leadingConstraint.constant = (self.minimumThumbSpacing ?? 0)            
            self.trailingConstraint.isActive = false
            self.leadingConstraint.isActive = true
            
//            let x = (self.minimumThumbSpacing ?? 0)
//            var frame = self.switchThumb.frame
//            frame.origin.x = x
//            self.switchThumb.frame = frame
            
            self.updateBackgroundColor()
            
            self.setNeedsLayout()
            self.updateConstraintsIfNeeded()
            self.layoutIfNeeded()
        }
        
        let completion: (Bool) -> Void = { _ in
            
        }
        
        if animated {
            UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: springDamping, initialSpringVelocity: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: animations, completion: completion)
        } else {
            animations()
            completion(true)
        }
    }
    
    private func changeToOn(animated: Bool) {
        let animations = {
//            self.leadingConstraint.constant = self.bounds.size.width - self.thumbRect.size.width - (self.minimumThumbSpacing ?? 0)
            self.leadingConstraint.isActive = false
            self.trailingConstraint.isActive = true
            
//            let x = (self.bounds.size.width - self.switchThumb.bounds.size.width) - (self.minimumThumbSpacing ?? 0)
//            var frame = self.switchThumb.frame
//            frame.origin.x = x
//            self.switchThumb.frame = frame
            
            self.updateBackgroundColor()
            
            self.setNeedsLayout()
            self.updateConstraintsIfNeeded()
            self.layoutIfNeeded()
        }
        
        let completion: (Bool) -> Void = { _ in
            
        }
        
        if animated {
            UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: springDamping, initialSpringVelocity: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: animations, completion: completion)
        } else {
            animations()
            completion(true)
        }
    }
    
    private var thumbRect: CGRect {
        let smallestSide = min(bounds.size.height, bounds.size.width)
        let thumbOuterRect = CGRect(x: 0, y: 0, width: smallestSide, height: smallestSide)
        let space = minimumThumbSpacing ?? 0
        let thumbRect = UIEdgeInsetsInsetRect(thumbOuterRect, UIEdgeInsets(top: space, left: space, bottom: space, right: space))
        
        return thumbRect
    }
    
    private var thumbOffFrame: CGRect {
        let x = minimumThumbSpacing
        var frame = thumbRect
        frame.origin.y = (bounds.size.height - frame.size.height) / 2
        frame.origin.x = x
        
        return frame
    }
    
    private var thumbOnFrame: CGRect {
        var frame = thumbRect
        let x = (bounds.size.width - frame.size.width) - minimumThumbSpacing
        frame.origin.y = (bounds.size.height - frame.size.height) / 2
        frame.origin.x = x
        
        return frame
    }
}
