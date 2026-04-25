import AppKit
import CoreGraphics

// Usage: generate_thumbnail <output.png>
// Single high-res PNG sized for the macOS Sonoma+ Wallpaper picker tile.
// Apple's legacy 90x58 thumbnails (with @2x sibling) render blurry in the new
// picker; Fliqlo ships a single 267x162 file, which the picker accepts as-is.
let width = 540
let height = 340
let logoViewBox = CGSize(width: 210, height: 107)

func dvdLogoPath(in rect: CGRect) -> CGPath {
    let sx = rect.width / logoViewBox.width
    let sy = rect.height / logoViewBox.height

    func pt(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        CGPoint(x: rect.origin.x + x * sx, y: rect.origin.y + (107.0 - y) * sy)
    }

    let path = CGMutablePath()

    path.move(to: pt(118.895, 20.346))
    path.addCurve(to: pt(105.855, 38.347), control1: pt(118.895, 20.346), control2: pt(105.152, 37.268))
    path.addCurve(to: pt(100.921, 20.161), control1: pt(106.830, 37.268), control2: pt(100.921, 20.161))
    path.addCurve(to: pt(95.819, 4.774), control1: pt(100.921, 20.161), control2: pt(99.688, 16.564))
    path.addLine(to: pt(81.81, 4.774))
    path.addLine(to: pt(47.812, 4.774))
    path.addLine(to: pt(22.175, 4.774))
    path.addLine(to: pt(19.615, 15.842))
    path.addLine(to: pt(38.914, 15.842))
    path.addLine(to: pt(43.493, 15.842))
    path.addCurve(to: pt(61.371, 30.067), control1: pt(55.908, 15.842), control2: pt(63.488, 20.974))
    path.addCurve(to: pt(36.706, 44.195), control1: pt(59.084, 39.968), control2: pt(48.248, 44.195))
    path.addLine(to: pt(32.39, 44.195))
    path.addLine(to: pt(37.942, 19.987))
    path.addLine(to: pt(18.647, 19.987))
    path.addLine(to: pt(10.455, 55.355))
    path.addLine(to: pt(37.853, 55.355))
    path.addCurve(to: pt(81.545, 30.067), control1: pt(58.465, 55.355), control2: pt(78.019, 44.288))
    path.addCurve(to: pt(80.491, 17.014), control1: pt(82.162, 27.453), control2: pt(82.075, 20.882))
    path.addCurve(to: pt(80.313, 16.477), control1: pt(80.491, 16.921), control2: pt(80.400, 16.743))
    path.addCurve(to: pt(80.491, 15.663), control1: pt(80.226, 16.384), control2: pt(80.135, 15.755))
    path.addCurve(to: pt(81.016, 16.021), control1: pt(80.663, 15.571), control2: pt(81.016, 15.934))
    path.addCurve(to: pt(81.367, 16.834), control1: pt(81.016, 16.021), control2: pt(81.195, 16.477))
    path.addLine(to: pt(98.807, 67.149))
    path.addLine(to: pt(143.211, 15.933))
    path.addLine(to: pt(161.972, 15.841))
    path.addLine(to: pt(166.551, 15.841))
    path.addCurve(to: pt(184.52, 30.066), control1: pt(178.975, 15.841), control2: pt(186.641, 20.973))
    path.addCurve(to: pt(159.77, 44.194), control1: pt(182.23, 39.967), control2: pt(171.315, 44.194))
    path.addLine(to: pt(155.365, 44.194))
    path.addLine(to: pt(161.0, 19.987))
    path.addLine(to: pt(141.713, 19.987))
    path.addLine(to: pt(133.515, 55.355))
    path.addLine(to: pt(160.913, 55.355))
    path.addCurve(to: pt(204.517, 30.067), control1: pt(181.524, 55.355), control2: pt(201.256, 44.288))
    path.addCurve(to: pt(172.627, 4.774), control1: pt(207.864, 15.842), control2: pt(193.416, 4.774))
    path.addLine(to: pt(154.484, 4.774))
    path.addLine(to: pt(131.757, 4.774))
    path.addCurve(to: pt(118.895, 20.346), control1: pt(120.923, 17.823), control2: pt(118.895, 20.346))
    path.closeSubpath()

    path.move(to: pt(99.424, 67.329))
    path.addCurve(to: pt(5.0, 81.012), control1: pt(47.281, 67.329), control2: pt(5.0, 73.449))
    path.addCurve(to: pt(99.424, 94.69), control1: pt(5.0, 88.57), control2: pt(47.281, 94.69))
    path.addCurve(to: pt(193.949, 81.012), control1: pt(151.663, 94.69), control2: pt(193.949, 88.57))
    path.addCurve(to: pt(99.424, 67.329), control1: pt(193.949, 73.449), control2: pt(151.664, 67.329))
    path.closeSubpath()

    path.move(to: pt(96.078, 85.873))
    path.addCurve(to: pt(74.498, 81.278), control1: pt(84.098, 85.873), control2: pt(74.498, 83.801))
    path.addCurve(to: pt(96.078, 76.688), control1: pt(74.498, 78.755), control2: pt(84.077, 76.688))
    path.addCurve(to: pt(117.576, 81.278), control1: pt(107.966, 76.688), control2: pt(117.576, 78.754))
    path.addCurve(to: pt(96.078, 85.873), control1: pt(117.576, 83.801), control2: pt(107.966, 85.873))
    path.closeSubpath()

    path.move(to: pt(182.843, 94.635))
    path.addLine(to: pt(182.843, 93.653))
    path.addLine(to: pt(177.098, 93.653))
    path.addLine(to: pt(176.859, 94.635))
    path.addLine(to: pt(179.251, 94.635))
    path.addLine(to: pt(178.286, 102.226))
    path.addLine(to: pt(179.49, 102.226))
    path.addLine(to: pt(180.445, 94.635))
    path.closeSubpath()

    path.move(to: pt(191.453, 102.226))
    path.addLine(to: pt(191.453, 93.653))
    path.addLine(to: pt(190.504, 93.653))
    path.addLine(to: pt(187.384, 99.534))
    path.addLine(to: pt(185.968, 93.653))
    path.addLine(to: pt(185.013, 93.653))
    path.addLine(to: pt(182.36, 102.226))
    path.addLine(to: pt(183.337, 102.226))
    path.addLine(to: pt(185.475, 95.617))
    path.addLine(to: pt(186.917, 102.226))
    path.addLine(to: pt(190.276, 95.617))
    path.addLine(to: pt(190.504, 102.226))
    path.closeSubpath()

    return path
}

let colorSpace = CGColorSpaceCreateDeviceRGB()
guard let ctx = CGContext(
    data: nil,
    width: width,
    height: height,
    bitsPerComponent: 8,
    bytesPerRow: 0,
    space: colorSpace,
    bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
) else {
    fatalError()
}

ctx.setFillColor(CGColor(red: 0, green: 0, blue: 0, alpha: 1))
ctx.fill(CGRect(x: 0, y: 0, width: width, height: height))

let logoW: CGFloat = CGFloat(width) * 0.55
let logoH: CGFloat = logoW * (logoViewBox.height / logoViewBox.width)
let logoRect = CGRect(
    x: (CGFloat(width) - logoW) / 2,
    y: (CGFloat(height) - logoH) / 2,
    width: logoW,
    height: logoH
)

ctx.setFillColor(CGColor(red: 0, green: 0.455, blue: 0.522, alpha: 1))
ctx.addPath(dvdLogoPath(in: logoRect))
ctx.fillPath()

guard let image = ctx.makeImage() else { fatalError() }
let rep = NSBitmapImageRep(cgImage: image)
guard let png = rep.representation(using: .png, properties: [:]) else { fatalError() }

let outputPath = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "thumbnail.png"
try! png.write(to: URL(fileURLWithPath: outputPath))
print("Generated: \(outputPath)")
