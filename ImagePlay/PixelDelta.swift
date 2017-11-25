//
//  PixelDelta.swift
//  ImagePlay
//
//  Created by Chris William Sehnert on 11/24/17.
//  Copyright © 2017 InSehnDesigns. All rights reserved.
//

import Foundation

public struct PixelDelta {
    init(rDelta: Int, gDelta: Int, bDelta: Int) {
        self.rDelta = rDelta
        self.gDelta = gDelta
        self.bDelta = bDelta
    }
    func add( p: RGBAPixel ) -> PixelDelta {
        return PixelDelta( rDelta: self.rDelta+Int(p.red), gDelta: self.gDelta+Int(p.green), bDelta: self.bDelta+Int(p.blue) )
    }
    func subtract( p: RGBAPixel ) -> PixelDelta {
        return PixelDelta( rDelta: self.rDelta-Int(p.red), gDelta: self.gDelta-Int(p.green), bDelta: self.bDelta-Int(p.blue) )
    }
    func asPixel() -> RGBAPixel {
        return RGBAPixel(
            r: limitToLegalColorChannelRange( delta: rDelta ),
            g: limitToLegalColorChannelRange( delta: gDelta ),
            b: limitToLegalColorChannelRange( delta: bDelta )
        )
    }
    
    func limitToLegalColorChannelRange( delta: Int ) -> UInt8 {
        if (delta < 0) {
            return UInt8(0)
        } else if ( delta > 0xFF ) {
            return UInt8(0xFF)
        } else {
            return UInt8(delta)
        }
    }
    
    let rDelta: Int
    let gDelta: Int
    let bDelta: Int
}
