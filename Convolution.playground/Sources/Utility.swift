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
    return (r | (g << 8) | (b << 16) | (0x00 << 24))
}

public func RGBAMake(r: UInt32, g: UInt32, b: UInt32, a: UInt32) -> UInt32 {
    return (r | (g << 8) | (b << 16) | (a << 24))
}
