//
//  ClickCounter.swift
//  Swift Custom Control
//
//  Created by William Waggoner on 2/21/17.
//  Copyright © 2017 William C Waggoner. Available under the MIT License.
//

import Cocoa

/// Test class to demonstrate an embedded custom designable view
@IBDesignable
class ClickCounter: NSView {
    
    /// The highest level view in the XIB. This is actually not used within the app
    @IBOutlet var topView: NSView!
    
    /// The topmost subview in the XIB. It's easier but not necessary to have only one
    @IBOutlet weak var stackView: NSStackView!
    
    /// A reference to an interior view we want to affect
    @IBOutlet weak var counterView: NSTextField!
    
    /// Our data
    var clickCounter = 0 {
        didSet {
            counterView.stringValue = String(clickCounter)
        }
    }
    
    /// An action
    ///
    /// - parameter sender: The NSButton that was clicked
    @IBAction func pushed(_ sender: NSButton) {
        clickCounter += 1
    }
    
    /// Called when drawing the topmost view (us)
    /// We set the background to brown for visibility
    ///
    /// - parameter dirtyRect: The NSRect area that needs to be redrawn
    ///   We fill it with brown
    override func draw(_ dirtyRect: NSRect) {
        NSColor.brown.setFill()
        dirtyRect.fill()
        super.draw(dirtyRect)
    }
    
    /// The initializer
    ///
    /// The setup work goes here
    required public init?(coder: NSCoder) {
        
        /// Call the superview's init. In this case it doesn't do much for us
        super.init(coder: coder)
        
        /// Extract our name string from the multi-level class name. We need it to reference the NIB name
        /// This is just Best Practice. The NIB may be named anything you like but makes sense to be named
        /// the same as the class that drives it.
        guard let myName = type(of: self)
                .className()
                .components(separatedBy: ".")
                .last else {
            return nil
        }
        
        /// Log the name for reference
        wwLog("I am \(myName)")
        
        /// Get our NIB. This should never fail but it always pays to be careful
        /// In this case it gets the main Bundle but if this code is in a Framework then it might be another one,
        /// that's why we use that form of Bundle call
        if let nib = NSNib(nibNamed: myName,
                           bundle: Bundle(for: type(of: self))) {
            
            /// You must instantiate a new view from the NIB attached to you as the owner,
            /// this will replace the one originally built at app start-up
            nib.instantiate(withOwner: self, topLevelObjects: nil)
            
            /// Now create a new array of constraints by copying the old ones.
            /// We replace ourself as either the first or second item as appropriate in place of topView.
            /// We grab these now to apply after we add our sub-views
            wwLog("Recreating \(topView.constraints.count) constraints")
            
            var newConstraints: [NSLayoutConstraint] = []
            
            for oldConstraint in topView.constraints {
                let firstItem = oldConstraint.firstItem === topView ? self : oldConstraint.firstItem
                let secondItem = oldConstraint.secondItem === topView ? self : oldConstraint.secondItem
                
                newConstraints.append(
                    NSLayoutConstraint(item: firstItem as Any,
                                       attribute: oldConstraint.firstAttribute,
                                       relatedBy: oldConstraint.relation,
                                       toItem: secondItem,
                                       attribute: oldConstraint.secondAttribute,
                                       multiplier: oldConstraint.multiplier,
                                       constant: oldConstraint.constant)
                )
            }
            
            /// Steal subviews from the original NSView which will not be used.
            /// Adding it to the new view removes it from the older one
            for newView in topView.subviews {
                self.addSubview(newView)
            }
            
            /// Add the constraints
            /// Note that we add them to ourself. They must be added at or above the views mentioned in the constraints
            self.addConstraints(newConstraints)
            
            
        } else {
            /// Oops
            wwLog("init couldn't load nib")
        }
    }
    
}
