//
//  ImageResizer.swift
//  ImagePlay
//
//  Created by Chris William Sehnert on 11/29/17.
//  Copyright © 2017 InSehnDesigns. All rights reserved.
//

import UIKit

class ImageResizer {
    let maxDimension: Int
    
    init(maxDimension: Int) {
        self.maxDimension = maxDimension
    }
    
    func isSmallEnough(w: Int, h: Int) -> Bool {
        return (w < maxDimension && h < maxDimension)
    }
    
    func resizeImage(original: UIImage) -> UIImage {
        
        var w = Int(original.size.width)
        var h = Int(original.size.height)
        if (isSmallEnough(w: w, h: h) ) {
            return original
        }
        while (!isSmallEnough(w: w, h: h)) {
            w = w/2
            h = h/2
        }
        return scaleToNewSize(image: original, w: w, h: h)
    }
}

private func scaleToNewSize( image: UIImage, w: Int, h: Int ) -> UIImage {
    if let cgImage = image.cgImage {
        let bitsPerComponent = cgImage.bitsPerComponent
        let bytesPerRow = cgImage.bytesPerRow
        let colorSpace = cgImage.colorSpace
        let bitMapInfo = cgImage.bitmapInfo
        let imageContext = CGContext.init(
            data: nil,
            width: w,
            height: h,
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: colorSpace ?? CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: bitMapInfo.rawValue
        )
        imageContext?.interpolationQuality = .high
        imageContext?.draw(cgImage, in: CGRect(origin: .zero, size: CGSize(width: CGFloat(w), height: CGFloat(h) )))
        
        if let scaledCGImage = imageContext?.makeImage() {
            return UIImage(cgImage: scaledCGImage)
        }
    }
    return image
}











