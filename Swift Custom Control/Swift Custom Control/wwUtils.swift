//
//  wwUtils.swift
//  Swift Custom Control
//
//  Created by William Waggoner on 2/21/17.
//  Copyright © 2017 William C Waggoner. All rights reserved.
//
// Just a couple of useful utility functions
//

import Foundation

/**
 Get the last path component in a file or URL string

 - parameters:
   * path: The string representing a file path or URL

 - returns: The last path component or the original input path
 */
fileprivate func lastPath(_ path: String) -> String {
    return path.components(separatedBy: "/").last!
}

/**
 Log message prepending the requesting file and function names

 - parameters:
   * myMsg: The string to log
   * myFile: The originating file name
   * myFunc: The originating function name
   * myLine: The current line number within the source file

 - note: *myFile* and *myFunc* are usually not specified and are allowed to default

 */
public func wwLog(_ myMsg: String = "Entry", myFile: String = #file, myFunc: String = #function, myLine: UInt = #line) {
    NSLog("%@(%u):%@ %@", lastPath(myFile), myLine, myFunc, myMsg)
//    print("\(lastPath(myFile))(\(myLine)):\(myFunc) \(myMsg)")
}
