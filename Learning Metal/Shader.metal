//
//  VertexShader.metal
//  Learning Metal
//
//  Created by Saurabh Jain on 3/13/16.
//  Copyright © 2016 Saurabh Jain. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn
{
    float3 position [[attribute(0)]];
    float4 color [[attribute(1)]];
};

struct Uniforms
{
    float4x4 mv;
    float4x4 pm;
};

struct VertexOut
{
    float4 position [[position]];
    float4 color;
};

vertex VertexOut basic_vertex (
                            const device VertexIn * vertexArray [[ buffer(0) ]],
                            constant Uniforms& uniform [[ buffer(1) ]],
                            unsigned int vid [[ vertex_id ]]
                            )
{
    VertexIn in = vertexArray[vid];
    float4x4 modelView = uniform.mv;
    float4x4 perspectiveMatrix = uniform.pm;
    
    VertexOut v;
    v.position = perspectiveMatrix * modelView * float4(in.position, 1);
    v.color = in.color;
    return v;
}

fragment half4 basic_fragment(VertexOut v [[ stage_in ]])
{
    return half4(v.color);
}