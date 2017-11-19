//
//  Filters.swift
//  ImagePlay
//
//  Created by Chris William Sehnert on 11/19/17.
//  Copyright © 2017 InSehnDesigns. All rights reserved.
//

import Foundation

class ScaleIntensityFilter: Filter {
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
