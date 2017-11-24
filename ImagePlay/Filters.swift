//
//  Filters.swift
//  ImagePlay
//
//  Created by Chris William Sehnert on 11/19/17.
//  Copyright © 2017 InSehnDesigns. All rights reserved.
//

import Foundation

let allFilters: [Filter] = [
    ScaleIntensityFilter(scale: 0.5),
    MixFilter(),
    GreyScaleFilter(),
    InvertFilter(),
    Colors8Filter()
]

class ScaleIntensityFilter: Filter {
    let name = "Scale Intensity"
    let scale: Double
    init(scale: Double) {
        self.scale = scale
    }
    func apply(input: Image) -> Image {
        return input.transformPixels(transformFunc: { (p1: RGBAPixel) -> RGBAPixel in
            var p = p1
            p.red = UInt8( Double(p.red) * self.scale )
            p.green = UInt8( Double(p.green) * self.scale )
            p.blue = UInt8( Double(p.blue) * self.scale )
            return p
        })
    }
}

let palette8: [RGBAPixel] = [
    RGBAPixel(r: 0, g: 0, b: 0),
    RGBAPixel(r: 0xFF, g: 0x0, b: 0x0),
    RGBAPixel(r: 0x0, g: 0xFF, b: 0x0),
    RGBAPixel(r: 0x0, g: 0x0, b: 0xFF),
    RGBAPixel(r: 0xFF, g: 0xFF, b: 0x0),
    RGBAPixel(r: 0xFF, g: 0x0, b: 0xFF),
    RGBAPixel(r: 0x0, g: 0xFF, b: 0xFF),
    RGBAPixel(r: 0xFF, g: 0xFF, b: 0xFF)
]

class Colors8Filter: Filter {
    let name = "8 Colors Only"
    func apply(input: Image) -> Image {
        return input.transformPixels(transformFunc: { (p1: RGBAPixel) -> RGBAPixel in
            return p1.matchClosestColor(palette: palette8)
        })
    }
}

class Dither8Colors: Filter {
    let name = "Dither 8 Colors"
    func apply(input: Image) -> Image {
        let delta = PixelDelta(rDelta: 0, gDelta: 0, bDelta: 0)
        return input.transformPixels(transformFunc: { (p1: RGBAPixel) -> RGBAPixel in
            let newDelta = delta.add(p: p1)
            return p1.matchClosestColor(palette: palette8)
        })
    }
}

class MixFilter: Filter {
    let name = "Mix Filter"
    func apply(input: Image) -> Image {
        return input.transformPixels(transformFunc: { (p1: RGBAPixel) -> RGBAPixel in
            var p = p1
            let r = p.red
            p.red = p.blue
            p.blue = p.green
            p.green = r
            return p
        })
    }
}

class GreyScaleFilter: Filter {
    let name = "Grey Scale Filter"
    func apply(input: Image) -> Image {
        return input.transformPixels(transformFunc: { (p1: RGBAPixel) -> RGBAPixel in
            let i = p1.avgerageIntensity
            return RGBAPixel(r: i, g: i, b: i)
        })
    }
}

class InvertFilter: Filter {
    let name = "Color Invert Filter"
    func apply(input: Image) -> Image {
        return input.transformPixels(transformFunc: { (p1: RGBAPixel) -> RGBAPixel in
            
            return RGBAPixel(r: 0xFF-p1.red, g: 0xFF-p1.green, b: 0xFF-p1.blue)
        })
    }
}




















