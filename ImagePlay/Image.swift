//
//  Image.swift
//  ImagePlay
//
//  Created by Chris William Sehnert on 11/18/17.
//  Copyright © 2017 InSehnDesigns. All rights reserved.
//
import UIKit


public class Image {
    
    private class ImageBuffer {
        let rawdata: UnsafeMutablePointer<RGBAPixel>
        let capacity: Int
        init (capacity: Int) {
            self.capacity = capacity
            self.rawdata = UnsafeMutablePointer<RGBAPixel>.allocate(capacity: capacity)
            // let ptr = rawdata[0]
            // rawdata.initialize(to: ptr, count: capacity) // this is still in question...
        }
        deinit {
            rawdata.deallocate(capacity: capacity)
        }
    }
    private let imageBuffer: ImageBuffer
    let pixels: UnsafeMutableBufferPointer<RGBAPixel>
    let height: Int
    let width: Int
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue
    let bitsPerComponent = 8
    let bytesPerRow: Int
    
    
    public init( image: UIImage) {
        height = Int(image.size.height)
        width = Int(image.size.width)
        let capacity = height * width
        imageBuffer = ImageBuffer(capacity: capacity)
        bytesPerRow = 4 * width
        
        let imageContext = CGContext.init(
            data: imageBuffer.rawdata,
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo)
        
        imageContext!.draw(image.cgImage!, in: CGRect(origin: .zero, size: image.size))
        
        pixels = UnsafeMutableBufferPointer<RGBAPixel>(start: imageBuffer.rawdata, count: capacity)
    }
    
    public init(width: Int, height: Int) {
        self.height = height
        self.width = width
        let capacity = height * width
        imageBuffer = ImageBuffer(capacity: capacity)
        bytesPerRow = 4 * width
        pixels = UnsafeMutableBufferPointer<RGBAPixel>(start: imageBuffer.rawdata, count: capacity)
    }
    
    
    public func getPixel( x:Int, y: Int ) -> RGBAPixel {
        return pixels[x+y*width]
    }
    
    public func setPixel( value: RGBAPixel, x: Int, y: Int ) {
        pixels[x+y*width] = value
    }
        
    public func toUIImage() -> UIImage {
        //let capacity = height*width
        //let outBuffer = ImageBuffer(capacity: capacity)
        let outContext = CGContext.init(
            data: imageBuffer.rawdata,
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo,
            releaseCallback: nil,
            releaseInfo: nil)
        let outputImage = UIImage(cgImage: outContext!.makeImage()!)
        
        return outputImage
    }
    
    public func transformPixels( transformFunc: (RGBAPixel)->RGBAPixel ) -> Image {
        let newImage = Image(width: self.width, height: self.height)
        for y in 0 ..< height {
            for x in 0 ..< width {
                let p1 = getPixel(x: x, y: y)
                let p2 = transformFunc(p1)
                newImage.setPixel(value: p2, x: x, y: y)
            }
        }
        return newImage
    }
}









