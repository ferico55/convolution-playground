//: [Previous](@previous)

import UIKit

let image = UIImage(named: "lenna.png")!
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

let identityKernel: [Double] = [
    0,0,0,
    0,1,0,
    0,0,0
]

let gaussianBlurKernel: [Double] = [
    0.0625, 0.125, 0.0625,
    0.125, 0.25, 0.125,
    0.0625, 0.125, 0.0625,
]

let gaussianBlurKernel5: [Double] = [
    0.00390625, 0.015625, 0.0234375, 0.015625, 0.00390625,
    0.015625, 0.0625, 0.09375, 0.0625, 0.015625,
    0.0234375, 0.09375, 0.140625, 0.09375, 0.0234375,
    0.015625, 0.0625, 0.09375, 0.0625, 0.015625,
    0.00390625, 0.015625, 0.0234375, 0.015625, 0.00390625,
]

let sharpenKernel: [Double] = [
    0, -1, 0,
    -1, 5, -1,
    0, -1, 0
]

let edgeDetection1: [Double] = [
    1, 0, -1,
    0, 0, 0,
    -1, 0, 1
]

let edgeDetection2: [Double] = [
    0, -1, 0,
    -1, 4, -1,
    0, -1, 0
]

let edgeDetection3: [Double] = [
    -1, -1, -1,
    -1, 8, -1,
    -1, -1, -1
]

let sobelHorizontalEdgeDetection: [Double] = [
    1, 0, -1,
    2, 0, -2,
    1, 0, -1
]

let sobelVerticalEdgeDetection: [Double] = [
    1, 2, 1,
    0, 0, 0,
    -1, -2, -1
]

toGrayscale(from: &imageData, width: width, height: height)
let resultedCGImage = context?.makeImage()
convolution(&imageData, kernelSize: 5, width: width, height: height, kernel: averageKernel)

if let resultedCGImage = context?.makeImage() {
    let image = UIImage(cgImage: resultedCGImage)
}

//: [Next](@next)
