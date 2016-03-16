//
//  Shader.swift
//  Learning Metal
//
//  Created by Saurabh Jain on 3/15/16.
//  Copyright © 2016 Saurabh Jain. All rights reserved.
//

import Foundation

public class Shader: NSObject {
    
    private(set) var vertexShader: String?
    private(set) var fragmentShader: String?
    private(set) var vertexDescriptor: MTLVertexDescriptor?
    
    public typealias configurationBlock = (NSError?) -> ()

    private(set) var renderPipeline: MTLRenderPipelineState?
    
    // MARK:- Init
    
    public init?(vertexShader: String?, fragmentShader: String?, vertexDescriptor: MTLVertexDescriptor? = nil) {
        super.init()
        
        // if the shaders are nil, then return nil
        if vertexShader == nil || fragmentShader == nil {
            return nil
        }
        
        self.vertexShader = vertexShader!;
        self.fragmentShader = fragmentShader!;
        self.vertexDescriptor = vertexDescriptor
    }
    
    
    // MARK:- Interface
    
    /*!
    @abstract: Should be called once
    */
    public func configure(block: configurationBlock)
    {
        let library = metalDevice?.newDefaultLibrary()
        let vFunc = library?.newFunctionWithName(vertexShader!)
        let fFunc = library?.newFunctionWithName(fragmentShader!)

        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.vertexFunction = vFunc
        descriptor.fragmentFunction = fFunc
        descriptor.colorAttachments[0].pixelFormat = .BGRA8Unorm
        descriptor.vertexDescriptor = vertexDescriptor
        
        // create the program asynchronously
        metalDevice?.newRenderPipelineStateWithDescriptor(descriptor) { [unowned self] (state, error) in
            if let err = error {
                block(err)
                return
            }
            self.renderPipeline = state
            block(nil)
        }
        
    }
    
    /*!
    @abstract: Returns the pipeline program
    */
    public func getPipelineProgram() -> MTLRenderPipelineState?
    {
        return renderPipeline
    }
        
}