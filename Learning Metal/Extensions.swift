//
//  Extensions.swift
//  Learning Metal
//
//  Created by Saurabh Jain on 3/16/16.
//  Copyright © 2016 Saurabh Jain. All rights reserved.
//

// Every sublass has access to the metal device
extension NSObject {
    var metalDevice: MTLDevice? {
        get {
            return MTLCreateSystemDefaultDevice()
        }
    }
}