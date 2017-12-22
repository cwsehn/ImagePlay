//
//  Filters.swift
//  ImagePlay
//
//  Created by Chris William Sehnert on 11/19/17.
//  Copyright © 2017 InSehnDesigns. All rights reserved.
//

import Foundation
import UIKit

let allFilters: [Filter] = [
    ScaleIntensityFilter(),
    MixFilter(),
    GreyScaleFilter(),
    InvertFilter(),
    Colors8Filter(),
    Colors16Filter(),
    Dither8Colors(),
    Dither16Colors(),
    HueFilter(),
    SaturationFilter(),
    LightnessFilter(),
    MirrorFilter(),
    FlipFilter()
]

var currentFilters: [Filter] = []

class ScaleIntensityFilter: Filter, LinearAdjustableFilter {
    let name = "Scale Intensity"
    var value: Double
    let min = 0.0
    let max = 1.0
    let defaultValue = 1.0

    init () {
        self.value = self.defaultValue
    }
    
    func apply(input: Image) -> Image {
        return input.transformPixels(transformFunc: { (p1: RGBAPixel) -> RGBAPixel in
            var p = p1
            p.red = UInt8( Double(p.red) * self.value )
            p.green = UInt8( Double(p.green) * self.value )
            p.blue = UInt8( Double(p.blue) * self.value )
            return p
        })
    }
}

class HueFilter: Filter, LinearAdjustableFilter {
    let name = "Hue"
    var value: Double
    let min = 0.0
    let max = 1.0
    let defaultValue = 0.75
    
    init () {
        self.value = self.defaultValue
    }
    
    func apply(input: Image) -> Image {
        return input.transformPixels(transformFunc: { (p: RGBAPixel) -> RGBAPixel in
            
            let uiColorPixel = p.toUIColor()
            var hslPixel = HSLPixel()
            
            uiColorPixel.getHue(
                &hslPixel.h,
                saturation: &hslPixel.s,
                brightness: &hslPixel.l,
                alpha: &hslPixel.alpha)
            
            let newUIColor =  UIColor(
                hue: CGFloat(value),
                saturation: hslPixel.s,
                brightness: hslPixel.l,
                alpha: hslPixel.alpha)
        
            return RGBAPixel(uiColor: newUIColor)
        })
    }
}

class SaturationFilter: Filter, LinearAdjustableFilter {
    let name = "Saturation"
    var value: Double
    let min = 0.0
    let max = 3.0
    let defaultValue = 1.0
    
    init () {
        self.value = self.defaultValue
    }
    
    func apply(input: Image) -> Image {
        return input.transformPixels(transformFunc: { (p: RGBAPixel) -> RGBAPixel in
            
            let uiColorPixel = p.toUIColor()
            var hslPixel = HSLPixel()
            
            uiColorPixel.getHue(
                &hslPixel.h,
                saturation: &hslPixel.s,
                brightness: &hslPixel.l,
                alpha: &hslPixel.alpha)
            
            let newUIColor =  UIColor(
                hue: hslPixel.h,
                saturation: CGFloat(value) * hslPixel.s,
                brightness: hslPixel.l,
                alpha: hslPixel.alpha)
            
            return RGBAPixel(uiColor: newUIColor)
        })
    }
}

class LightnessFilter: Filter, LinearAdjustableFilter {
    let name = "Lightness"
    var value: Double
    let min = 0.0
    let max = 4.0
    let defaultValue = 1.5
    
    init () {
        self.value = self.defaultValue
    }
    
    func apply(input: Image) -> Image {
        return input.transformPixels(transformFunc: { (p: RGBAPixel) -> RGBAPixel in
            
            let uiColorPixel = p.toUIColor()
            var hslPixel = HSLPixel()
            
            uiColorPixel.getHue(
                &hslPixel.h,
                saturation: &hslPixel.s,
                brightness: &hslPixel.l,
                alpha: &hslPixel.alpha)
            
            let newUIColor =  UIColor(
                hue: hslPixel.h,
                saturation: hslPixel.s,
                brightness: CGFloat(value) * hslPixel.l,
                alpha: hslPixel.alpha)
            
            return RGBAPixel(uiColor: newUIColor)
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

let palette16: [RGBAPixel] = [
    RGBAPixel(r: 0, g: 0, b: 0),
    RGBAPixel(r: 0xFF, g: 0x0, b: 0x0),
    RGBAPixel(r: 0x0, g: 0xFF, b: 0x0),
    RGBAPixel(r: 0x0, g: 0x0, b: 0xFF),
    RGBAPixel(r: 0xFF, g: 0xFF, b: 0x0),
    RGBAPixel(r: 0xFF, g: 0x0, b: 0xFF),
    RGBAPixel(r: 0x0, g: 0xFF, b: 0xFF),
    RGBAPixel(r: 0xFF, g: 0xFF, b: 0xFF),
    
    RGBAPixel(r: 0x3F, g: 0x3F, b: 0x3F),
    RGBAPixel(r: 0x7F, g: 0x0, b: 0x0),
    RGBAPixel(r: 0x0, g: 0x7F, b: 0x0),
    RGBAPixel(r: 0x0, g: 0x0, b: 0x7F),
    RGBAPixel(r: 0x7F, g: 0x7F, b: 0x0),
    RGBAPixel(r: 0x7F, g: 0x0, b: 0x7F),
    RGBAPixel(r: 0x0, g: 0x7F, b: 0x7F),
    RGBAPixel(r: 0x7F, g: 0x7F, b: 0x7F)
]

class Colors8Filter: Filter {
    let name = "8 Colors Only"
    func apply(input: Image) -> Image {
        return input.transformPixels(transformFunc: { (p1: RGBAPixel) -> RGBAPixel in
            return p1.matchClosestColor(palette: palette8)
        })
    }
}

class Colors16Filter: Filter {
    let name = "16 Colors Only"
    func apply(input: Image) -> Image {
        return input.transformPixels(transformFunc: { (p1: RGBAPixel) -> RGBAPixel in
            return p1.matchClosestColor(palette: palette16)
        })
    }
}

class Dither8Colors: Filter {
    let name = "Dither 8 Colors"
    func apply(input: Image) -> Image {
        var delta = PixelDelta(rDelta: 0, gDelta: 0, bDelta: 0)
        return input.transformPixels(transformFunc: { (requestedPixel: RGBAPixel) -> RGBAPixel in
            delta = delta.add(p: requestedPixel)
            let newPixel = delta.asPixel().matchClosestColor(palette: palette8)
            delta = delta.subtract(p: newPixel)
            
            return newPixel
        })
    }
}

class Dither16Colors: Filter {
    let name = "Dither 16 Colors"
    func apply(input: Image) -> Image {
        var delta = PixelDelta(rDelta: 0, gDelta: 0, bDelta: 0)
        return input.transformPixels(transformFunc: { (requestedPixel: RGBAPixel) -> RGBAPixel in
            delta = delta.add(p: requestedPixel)
            let newPixel = delta.asPixel().matchClosestColor(palette: palette16)
            delta = delta.subtract(p: newPixel)
            
            return newPixel
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

class MirrorFilter: Filter {
    let name = "Left-Right Mirror"
    func apply(input: Image) -> Image {
        
        let newImage = Image(width: input.width, height: input.height)
        for y in 0 ..< input.height {
            for x in 0 ..< input.width {
                let p = input.getPixel(x: input.width-x-1, y: y)
                newImage.setPixel(value: p, x: x, y: y)
            }
        }
        return newImage
    }
}

class FlipFilter: Filter {
    let name = "Top-Bottom Mirror"
    func apply(input: Image) -> Image {
        
        let newImage = Image(width: input.width, height: input.height)
        for y in 0 ..< input.height {
            for x in 0 ..< input.width {
                let p = input.getPixel(x: x, y: y)
                newImage.setPixel(value: p, x: x, y: input.height-y-1)
            }
        }
        return newImage
    }
}













