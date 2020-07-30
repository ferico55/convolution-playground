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

for i in 0 ..< height {
    for j in 0 ..< width {
        let pixelOffset = i * width + j
        let pixel = imageData[pixelOffset]
        
        let average = (R(pixel) + G(pixel) + B(pixel)) / 3
        imageData[pixelOffset] = RGBMake(r: average, g: average, b: average)
    }
}

func processKernel(_ kernel: [Double], imageChunk: [UInt32]) -> UInt32 {
    let result = imageChunk
        .map { G($0) }
        .enumerated()
        .map { (index, pixel) in
            Int32(Double(pixel) * kernel[index])
        }.reduce(0) { $0 + $1 }

    let normalizedResult: UInt32 = UInt32(min(max(0, result), 255))
    return GrayMake(normalizedResult)
}

for row in startingPixel ..< height - startingPixel {
    for column in startingPixel ..< width - startingPixel {
        var window: [UInt32] = []
        window.reserveCapacity(kernelSize * kernelSize)

        for i in -startingPixel ... startingPixel {
            for j in -startingPixel ... startingPixel {
                let pixelOffset = ((row + i) * width) + (column + j)
                window.append(imageData[pixelOffset])
            }
        }
        
        let offset = row * width + column
        imageData[offset] = processKernel(averageKernel, imageChunk: window)
    }
}

if let resultedCGImage = context?.makeImage() {
    let image = UIImage(cgImage: resultedCGImage)
}

//: [Next](@next)
