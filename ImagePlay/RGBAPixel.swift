//
//  RGBAPixel.swift
//  ImagePlay
//
//  Created by Chris William Sehnert on 11/18/17.
//  Copyright © 2017 InSehnDesigns. All rights reserved.
//

import UIKit


public struct RGBAPixel {
    public init( rawVal : UInt32 ) {
        raw = rawVal
    }
    public init( r: UInt8, g: UInt8, b: UInt8 ) {
        raw = 0xFF000000 | UInt32(r) | UInt32(g)<<8 | UInt32(b)<<16
    }
    public init(uiColor: UIColor) {
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 0.0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        r = r < 1 ? r : 1
        g = g < 1 ? g : 1
        b = b < 1 ? b : 1
        r = r > 0 ? r : 0
        g = g > 0 ? g : 0
        b = b > 0 ? b : 0
        
        self.init(r: UInt8(r*255), g: UInt8(g*255), b: UInt8(b*255))
    }
    public var raw: UInt32
    
    public var red: UInt8 {
        get { return UInt8(raw & 0xFF) }
        set { raw = UInt32(newValue) | (raw & 0xFFFFFF00) }
    }
    public var green: UInt8 {
        get { return UInt8( (raw & 0xFF00) >> 8) }
        set { raw = (UInt32(newValue) << 8) | (raw & 0xFFFF00FF) }
    }
    public var blue: UInt8 {
        get { return UInt8( (raw & 0xFF0000) >> 16) }
        set { raw = (UInt32(newValue) << 16) | (raw & 0xFF00FFFF) }
    }
    public var alpha: UInt8 {
        get { return UInt8( (raw & 0xFF000000) >> 24) }
        set { raw = (UInt32(newValue) << 24) | (raw & 0x00FFFFFF) }
    }
    public var avgerageIntensity: UInt8 {
        get { return UInt8((UInt32(red)+UInt32(green)+UInt32(blue))/3) }
    }
    
    public func matchClosestColor(palette: [RGBAPixel]) -> RGBAPixel {
        var closestMatch: RGBAPixel = palette[0]
        var bestMatchSoFar: Int = palette[0].pixelDelta(otherPixel: self)
        for pixel in palette {
            let delta: Int = pixel.pixelDelta(otherPixel: self)
            if ( delta < bestMatchSoFar ) {
                closestMatch = pixel
                bestMatchSoFar = delta
            }
        }
        return closestMatch
    }
    
    public func pixelDelta (otherPixel: RGBAPixel) -> Int {
        let deltaRed = abs(Int(self.red) - Int(otherPixel.red))
        let deltaGreen = abs(Int(self.green) - Int(otherPixel.green))
        let deltaBlue = abs(Int(self.blue) - Int(otherPixel.blue))
        
        return (deltaRed + deltaGreen + deltaBlue)
    }
    
    public func toUIColor() -> UIColor {
        let divisor = CGFloat(255.0)
        return UIColor(
            red: CGFloat(self.red)/divisor,
            green: CGFloat(self.green)/divisor,
            blue: CGFloat(self.blue)/divisor,
            alpha: CGFloat(self.alpha)/divisor)
    }
}























