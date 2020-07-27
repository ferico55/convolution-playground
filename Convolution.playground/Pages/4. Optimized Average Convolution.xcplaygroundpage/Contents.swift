//: [Previous](@previous)

import UIKit

let image = UIImage(named: "smallLenna.png")!
let cgImage = image.cgImage!

let width = Int(image.size.width)
let height = Int(image.size.height)

let bytesPerPixel = 4
let bytesPerRow = width * 4
let bitsPerComponent = 8
let kernelSize = 3
let startingPixel = kernelSize / 2

var imageData = UnsafeMutablePointer<UInt32>.allocate(capacity: width * height)
let colorSpace = CGColorSpaceCreateDeviceRGB()
let bitmapInfo = CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue
let context = CGContext(data: imageData, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

let averageKernel: [Double] = [
    0.11, 0.11, 0.11,
    0.11, 0.11, 0.11,
    0.11, 0.11, 0.11
]

toGrayscale(from: &imageData, width: width, height: height)
convolution(&imageData, kernelSize: 3, width: width, height: height, kernel: averageKernel)

if let resultedCGImage = context?.makeImage() {
    let image = UIImage(cgImage: resultedCGImage)
}

//: [Next](@next)
