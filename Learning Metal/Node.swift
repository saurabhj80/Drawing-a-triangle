//
//  Node.swift
//  Learning Metal
//
//  Created by Saurabh Jain on 3/16/16.
//  Copyright © 2016 Saurabh Jain. All rights reserved.
//

public protocol Node {
    var vertexBuffer: MTLBuffer { get }
    var vertexCount: Int { get }
    var vertexDescriptor: MTLVertexDescriptor? { get }
}

// Store the data related to one vertex
public struct Vertex
{
    var position: float3
    var color: float4
}