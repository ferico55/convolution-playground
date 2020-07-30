//: [Previous](@previous)

import UIKit

let image = UIImage(named: "lenna.png")!
let cgImage = image.cgImage!

let width = Int(image.size.width)
let height = Int(image.size.height)

let bytesPerPixel = 4
let bytesPerRow = width * 4
let bitsPerComponent = 8

var imageData = UnsafeMutablePointer<UInt32>.allocate(capacity: width * height)
let colorSpace = CGColorSpaceCreateDeviceRGB()
let bitmapInfo = CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue
let context = CGContext(data: imageData, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

for i in 0 ..< height {
    for j in 0 ..< width {
        let pixelOffset = i * width + j
        let pixel = imageData[pixelOffset]
        
        let average = (R(pixel) + G(pixel) + B(pixel)) / 3
        imageData[pixelOffset] = RGBMake(r: average, g: average, b: average)
    }
}

if let resultedCGImage = context?.makeImage() {
    let image = UIImage(cgImage: resultedCGImage)
}

//: [Next](@next)
