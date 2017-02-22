//
//  ClickCounter.swift
//  Swift Custom Control
//
//  Created by William Waggoner on 2/21/17.
//  Copyright © 2017 William C Waggoner. All rights reserved.
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
        NSRectFill(dirtyRect)
        super.draw(dirtyRect)
    }

    /// The initilizer
    ///
    /// The setup work goes here
    required public init?(coder: NSCoder) {

        /// Call the superview's init. In this case it doesn't do much for us
        super.init(coder: coder)

        /// Extract our name string from the multi-level class name. We nned it to reference the NIB name
        /// This is just Best Practice. The NIB may be named anything you like but makes sense to be named
        /// the same as the class that drives it.
        let myName = type(of: self).className().components(separatedBy: ".").last!

        /// Log the name for reference
        wwLog(myName)

        /// Get our NIB. This should never fail but it always pays to be careful
        /// In this case it gets the main Bundle but if this code is in a Framework then it might be another one,
        /// that's why we use that form of Bundle call
        if let nib = NSNib(nibNamed: myName, bundle: Bundle(for: type(of: self))) {

            /// A place to hold a bunch of constraints
            var constraints: [NSLayoutConstraint]

            /// You must instantiate a new view from the NIB attached to your as the owner, this will replace the one originally built
            nib.instantiate(withOwner: self, topLevelObjects: nil)

            /// Steal the stackView and all other subviews from the original NSView which will not be used.
            /// Adding it to the new view removes it from the older one
            addSubview(stackView)

            /// Build the set of constraints
            /// The ones you established in the XIB design were destroyed when we stole the view
            /// It's probably a good idea to use the same set of constraints that you used in the XIB
            /// but it isn't necessary
            constraints = [
                NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 4.0),
                NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: stackView, attribute: .bottom, multiplier: 1.0, constant: 4.0),
                NSLayoutConstraint(item: stackView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 4.0),
                NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: stackView, attribute: .right, multiplier: 1.0, constant: 4.0),
            ]

            /// Add the constraints
            /// Note that we add them to ourself. They must be added at or above the views mentioned in the constraints
            self.addConstraints(constraints)


        } else {
            /// Oops
            Swift.print("init couldn't load nib")
        }
    }

}
