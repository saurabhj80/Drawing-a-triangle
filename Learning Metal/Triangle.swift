//
//  Triangle.swift
//  Learning Metal
//
//  Created by Saurabh Jain on 3/16/16.
//  Copyright © 2016 Saurabh Jain. All rights reserved.
//


public class Triangle: Node {
    
    private var _vertexBuffer: MTLBuffer
    private var _vertexCount: Int
    private var _vertexDescriptor: MTLVertexDescriptor?
    private var _metalDevice: MTLDevice
    
    private let triangleData = [
        Vertex(position: float3(0, 1, 0), color: float4(1, 0, 0, 1)),
        Vertex(position: float3(-1, -1, 0), color: float4(0, 1, 0, 1)),
        Vertex(position: float3(1, -1, 0), color: float4(0, 0, 1, 1))
    ]
    
    public init(device: MTLDevice)
    {
        _metalDevice = device
        
        // set the vertex buffer
        let size = sizeofValue(triangleData[0]) * triangleData.count
        _vertexBuffer = device.newBufferWithBytes(triangleData, length: size, options: .CPUCacheModeDefaultCache)
        
        // the number of vertices
        _vertexCount = triangleData.count
        
        // set the vertex descriptor
        _vertexDescriptor = initVertexDescriptor()
    }
    
    private func initVertexDescriptor() -> MTLVertexDescriptor
    {
        let vertexDescriptor = MTLVertexDescriptor()
        
        let vertexAttributes = vertexDescriptor.attributes[0]
        vertexAttributes.format = MTLVertexFormat.Float3
        vertexAttributes.bufferIndex = 0
        vertexAttributes.offset = 0
        
        let colorAttributes = vertexDescriptor.attributes[1]
        colorAttributes.format = MTLVertexFormat.Float4
        colorAttributes.bufferIndex = 0
        colorAttributes.offset = 3 * sizeof(float3)
        
        vertexDescriptor.layouts[0].stride = 3 * sizeof(float3) + 4 * sizeof(float4)
        vertexDescriptor.layouts[0].stepFunction = .PerVertex
        
        return vertexDescriptor
    }
    
    // MARK:- Node Protocol
    
    public var vertexBuffer: MTLBuffer { get { return _vertexBuffer } }
    public var vertexCount: Int { get { return _vertexCount } }
    public var vertexDescriptor: MTLVertexDescriptor? { get { return _vertexDescriptor } }
}
