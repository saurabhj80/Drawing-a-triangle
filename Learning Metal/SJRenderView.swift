//
//  SJRenderView.swift
//  Learning Metal
//
//  Created by Saurabh Jain on 3/15/16.
//  Copyright © 2016 Saurabh Jain. All rights reserved.
//

import Foundation

public protocol SJRenderViewDelegate
{
    func render()
}

public class SJRenderView: UIView
{
    // the metal layer is the base layer
    override class public func layerClass() -> AnyClass {
        return CAMetalLayer.self
    }
    
    public var metalLayer: CAMetalLayer? {
        get {
            return self.layer as? CAMetalLayer
        }
    }
    
    // link
    private var link: CADisplayLink!
    
    // Delegate
    public var delegate: SJRenderViewDelegate?
    
    // MARK:- Init
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initLayer()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.initLayer()
    }
    
    public init() {
        super.init(frame: CGRect.zero)
        self.initLayer()
    }
    
    private func initLayer()
    {
        print("Initializing SJRenderView")
        
        // the display link
        link = CADisplayLink(target: self, selector: "renderLoop")
        
        let device = metalDevice
        metalLayer?.device = device
        metalLayer?.pixelFormat = .BGRA8Unorm
        metalLayer?.framebufferOnly = true
    }
    
    public func aspectRatio() -> Float
    {
        let width = self.bounds.size.width
        let height = self.bounds.size.height
        
        if height.isZero {
            return 0
        }
        
        return Float(width / height)
    }
    
    // MARK:- Game Loop
    
    public func beginLoop()
    {
        link.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
    }
    
    public func endLoop()
    {
        link.invalidate()
    }
    
    @objc private func renderLoop()
    {
        delegate?.render()
    }
    
    public func nextDrawable() -> CAMetalDrawable? {
        return metalLayer?.nextDrawable()
    }
    
}