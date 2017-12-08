//
//  Image.swift
//  ImagePlay
//
//  Created by Chris William Sehnert on 11/18/17.
//  Copyright © 2017 InSehnDesigns. All rights reserved.
//
import UIKit


public class Image {
    
    //class pictureMemory {
    
        let rawdata: UnsafeMutablePointer<RGBAPixel>
    
    
    
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
        let pixelCount = height * width
        rawdata = UnsafeMutablePointer<RGBAPixel>.allocate(capacity: pixelCount)
        let ptr = rawdata[0]
        rawdata.initialize(to: ptr, count: pixelCount) // this is still in question...
        bytesPerRow = 4 * width
        
        let imageContext = CGContext.init(
            data: rawdata,
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo)
        
        imageContext!.draw(image.cgImage!, in: CGRect(origin: .zero, size: image.size))
        
        pixels = UnsafeMutableBufferPointer<RGBAPixel>(start: rawdata, count: width * height)
    }
    
    public init(width: Int, height: Int) {
        self.height = height
        self.width = width
        let pixelCount = height * width
        rawdata = UnsafeMutablePointer<RGBAPixel>.allocate(capacity: pixelCount)
        let ptr = rawdata.pointee
        rawdata.initialize(to: ptr, count: pixelCount)
        bytesPerRow = 4 * width
        pixels = UnsafeMutableBufferPointer<RGBAPixel>(start: rawdata, count: pixelCount)
    }
    
    // rawdata.deallocate(capacity: width*height)
    
    public func getPixel( x:Int, y: Int ) -> RGBAPixel {
        return pixels[x+y*width]
    }
    
    public func setPixel( value: RGBAPixel, x: Int, y: Int ) {
        pixels[x+y*width] = value
    }
    
    //  should this be seperate class with its own rawdata....???
    
    public func toUIImage() -> UIImage {
        let outContext = CGContext.init(
            data: rawdata,
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









