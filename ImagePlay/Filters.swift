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
    InvertFilter()
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




















