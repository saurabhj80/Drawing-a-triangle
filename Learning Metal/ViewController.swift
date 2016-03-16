//
//  ViewController.swift
//  Learning Metal
//
//  Created by Saurabh Jain on 3/12/16.
//  Copyright © 2016 Saurabh Jain. All rights reserved.
//

import UIKit
import Metal
import QuartzCore

/*
    Steps for rendering a triangle to the screen
    
    1. Create a MTLDevice
    2. Create a CAMetalLayer
    3. Create a render pipeline
    4. Set up a CADisplayLink for a game loop
    5. Each instruction for rendering
        - MTLRenderPassDescriptor (Used for setting all the data for one render pass)
        - Using the above object, create a Command Encoder
        - The command encoder goes into the command buffer
        - The command buffer is created from the command queue, which is created from the MTLDevice

*/

class ViewController: UIViewController, SJRenderViewDelegate {

    // Shader
    private var shader: Shader?
    
    // Matrix Buffer
    private var matrixBuffer: MTLBuffer?
    
    // Our root view
    private var metalView: SJRenderView { get { return self.view as! SJRenderView } }
    
    // the command queue
    private var commandQueue: MTLCommandQueue?

    // Triangle
    private var triangle: Triangle!
    
    // MARK:- Overrides
    override func loadView() {
        let view = SJRenderView()
        view.delegate = self
        self.view = view
    }

    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(metalDevice != nil, "Could not get the metal device")
        
        if let device = metalDevice {
            
            // Triangle
            triangle = Triangle(device: device)

            // init the shader
            shader = Shader(vertexShader: "basic_vertex", fragmentShader: "basic_fragment", vertexDescriptor: triangle.vertexDescriptor)
            shader?.configure { [unowned self] error in
                if error != nil {
                    print("Error init shader")
                } else {
                    print("Success init shader")
                    self.commandQueue = device.newCommandQueue()
                    self.metalView.beginLoop()
                }
            }
        }
    }
    
    
    // We want the view to lay itself out, so that we can grab the aspect ratio of the view
    // it is imp, to keep in mind that the game loop might have started before we
    // set the matrices in the buffer
    override func viewDidLayoutSubviews() {
        
        // Model View Matrix
        let modelView = Matrix4()
        modelView.translate(0, y: 0, z: -5)

        // Perspective matrix
        let pers = Matrix4.makePerspectiveViewAngle(Matrix4.degreesToRad(60), aspectRatio: metalView.aspectRatio(), nearZ: 0.3, farZ: 100)
        
        // create the buffer
        let length = Matrix4.numberOfElements() * sizeof(Float)
        matrixBuffer = metalDevice!.newBufferWithLength(length * 2, options: .CPUCacheModeWriteCombined)
        
        //Upload the data directly
        if let pointer = matrixBuffer?.contents() {
            memcpy(pointer, modelView.raw(), length)
            memcpy(pointer + length, pers.raw(), length)
        }
    }
    
    // MARK:- SJRenderView Delegate
    
    lazy private var renderPassDescriptor: MTLRenderPassDescriptor = {
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].loadAction = .Clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 1.0, green: 1, blue: 1, alpha: 1.0)
        return renderPassDescriptor
    }()
    
    func render() {
        
        let drawable = metalView.nextDrawable()
        renderPassDescriptor.colorAttachments[0].texture = drawable?.texture
        
        if let commandBuffer = commandQueue?.commandBuffer() {
            
            let renderEncoderOpt = commandBuffer.renderCommandEncoderWithDescriptor(renderPassDescriptor)
            renderEncoderOpt.setRenderPipelineState(shader!.getPipelineProgram()!)
            renderEncoderOpt.setVertexBuffer(triangle.vertexBuffer, offset: 0, atIndex: 0)
            renderEncoderOpt.setVertexBuffer(matrixBuffer, offset: 0, atIndex: 1)
            renderEncoderOpt.drawPrimitives(.Triangle, vertexStart: 0, vertexCount: triangle.vertexCount, instanceCount: 1)
            renderEncoderOpt.endEncoding()
            
            commandBuffer.presentDrawable(drawable!)
            commandBuffer.commit()
        }
    }

}
