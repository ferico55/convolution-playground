import Foundation

func Mask8(_ x: UInt32) -> UInt32 {
    (x) & 0xFF
}

public func R(_ x: UInt32) -> UInt32 {
    Mask8(x)
}

public func G(_ x: UInt32) -> UInt32 {
    Mask8(x >> 8)
}

public func B(_ x: UInt32) -> UInt32 {
    Mask8(x >> 16)
}

public func A(_ x: UInt32) -> UInt32 {
    Mask8(x >> 24)
}

public func RGBMake(r: UInt32, g: UInt32, b: UInt32) -> UInt32 {
    return (r | (g << 8) | (b << 16) | (0xFF << 24))
}

public func RGBAMake(r: UInt32, g: UInt32, b: UInt32, a: UInt32) -> UInt32 {
    return (r | (g << 8) | (b << 16) | (a << 24))
}

public func GrayMake(_ x: UInt32) -> UInt32 {
    return (x | (x << 8) | (x << 16) | (0xFF << 24))
}

public func toGrayscale(from imageData: inout UnsafeMutablePointer<UInt32>, width: Int, height: Int) {
    for i in 0 ..< height {
        for j in 0 ..< width {
            let pixelOffset = i * width + j
            let pixel = imageData[pixelOffset]
            
            let average = (R(pixel) + G(pixel) + B(pixel)) / 3
            imageData[pixelOffset] = RGBMake(r: average, g: average, b: average)
        }
    }
}

public func convolution(_ imageData: inout UnsafeMutablePointer<UInt32>, kernelSize: Int, width: Int, height: Int, kernel: [Double]) {
    let result = UnsafeMutablePointer<UInt32>.allocate(capacity: width * height)
    for i in 0 ..< width * height {
        result[i] = imageData[i]
    }
    let startingPixel = kernelSize / 2

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
            result[offset] = processKernel(kernel, imageChunk: window)
        }
    }
    
    for i in 0 ..< width * height {
        imageData[i] = result[i]
    }
}

func processKernel(_ kernel: [Double], imageChunk: [UInt32]) -> UInt32 {
    let result = imageChunk
        .map { R($0) }
        .enumerated()
        .map { (index, pixel) in
            Int32(Double(pixel) * kernel[index])
        }.reduce(0) { $0 + $1 }

    let normalizedResult: UInt32 = UInt32(min(max(0, result), 255))
    return GrayMake(normalizedResult)
}
