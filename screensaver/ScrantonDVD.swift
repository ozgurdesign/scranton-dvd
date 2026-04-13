import ScreenSaver
import AppKit

let defaultsKey = "ca.ozgur.scranton-dvd"


class ScrantonDVD: ScreenSaverView {

    private var x: CGFloat = 0
    private var y: CGFloat = 0
    private var dx: CGFloat = 2.0
    private var dy: CGFloat = 2.0

    private static var sharedFracX: CGFloat?
    private static var sharedFracY: CGFloat?
    private static var sharedDXSign: CGFloat?
    private static var sharedDYSign: CGFloat?
    private static var sharedColourIndex: Int?
    private static let sheetController = SheetController()
    private var logoWidth: CGFloat = 400
    private var logoHeight: CGFloat = 204
    private var needsPositionInit = true
    private var lastBoundsSize: NSSize = .zero

    private let colours: [(CGFloat, CGFloat, CGFloat)] = [
        (0.0, 0.455, 0.522),
        (0.910, 0.263, 0.576),
        (0.424, 0.361, 0.906),
        (0.0, 0.722, 0.580),
        (0.992, 0.796, 0.431),
        (0.882, 0.439, 0.333),
        (0.035, 0.518, 0.890),
        (0.839, 0.188, 0.192),
        (0.0, 0.808, 0.788),
        (0.635, 0.608, 0.996),
        (0.333, 0.937, 0.769),
        (0.980, 0.694, 0.627),
        (0.455, 0.725, 1.0),
        (1.0, 0.463, 0.463),
        (0.992, 0.475, 0.659)
    ]
    private var colourIndex: Int = 0
    private var mode: Int = 0
    private var cachedPath: NSBezierPath?
    private var cachedLogoColours: [NSColor] = []
    private var cachedBgColours: [NSColor] = []

    private static let defaults: UserDefaults = {
        return UserDefaults(suiteName: defaultsKey) ?? .standard
    }()

    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        animationTimeInterval = 1.0 / 60.0
        mode = ScrantonDVD.defaults.integer(forKey: "mode")

        cachedLogoColours = colours.map { NSColor(red: $0.0, green: $0.1, blue: $0.2, alpha: 1.0) }
        cachedBgColours = colours.map { NSColor(red: 1.0 - $0.0, green: 1.0 - $0.1, blue: 1.0 - $0.2, alpha: 1.0) }

        needsPositionInit = true
    }

    private func initPositionIfNeeded() {
        guard needsPositionInit || lastBoundsSize != bounds.size else { return }

        let oldMaxX = max(lastBoundsSize.width - logoWidth, 1)
        let oldMaxY = max(lastBoundsSize.height - logoHeight, 1)
        let hadPriorBounds = lastBoundsSize.width > 0

        if bounds.width < 500 || bounds.height < 300 {
            logoWidth = 80
            logoHeight = 41
            dx = copysign(1.0, dx)
            dy = copysign(1.0, dy)
        } else {
            logoWidth = 400
            logoHeight = 204
            dx = copysign(2.0, dx)
            dy = copysign(2.0, dy)
        }

        cachedPath = dvdBezierPath(in: NSRect(x: 0, y: 0, width: logoWidth, height: logoHeight))

        let maxX = max(bounds.width - logoWidth, 1)
        let maxY = max(bounds.height - logoHeight, 1)

        if needsPositionInit {
            if let fx = ScrantonDVD.sharedFracX, let fy = ScrantonDVD.sharedFracY,
               let sdx = ScrantonDVD.sharedDXSign, let sdy = ScrantonDVD.sharedDYSign,
               let sci = ScrantonDVD.sharedColourIndex {
                x = fx * maxX
                y = fy * maxY
                dx = copysign(abs(dx), sdx)
                dy = copysign(abs(dy), sdy)
                colourIndex = sci % colours.count
            } else {
                colourIndex = Int.random(in: 0..<colours.count)
                x = CGFloat.random(in: 0...maxX)
                y = CGFloat.random(in: 0...maxY)
                if Bool.random() { dx = -dx }
                if Bool.random() { dy = -dy }
            }
        } else if hadPriorBounds {
            x = (x / oldMaxX) * maxX
            y = (y / oldMaxY) * maxY
        }

        x = min(max(x, 0), maxX)
        y = min(max(y, 0), maxY)

        lastBoundsSize = bounds.size
        needsPositionInit = false
    }

    override func startAnimation() {
        super.startAnimation()
        hideSystemOverlays()
    }

    private func hideSystemOverlays() {
        func hideLabels(in view: NSView) {
            for sub in view.subviews where sub !== self {
                if sub is NSTextField || sub is NSTextView {
                    sub.isHidden = true
                }
                hideLabels(in: sub)
            }
        }
        if let sv = superview { hideLabels(in: sv) }
        if let w = window?.contentView { hideLabels(in: w) }
    }

    override func animateOneFrame() {
        initPositionIfNeeded()

        let maxX = bounds.width - logoWidth
        let maxY = bounds.height - logoHeight
        var hit = false

        x += dx
        y += dy

        if x <= 0 { x = 0; dx = abs(dx); hit = true }
        if x >= maxX { x = maxX; dx = -abs(dx); hit = true }
        if y <= 0 { y = 0; dy = abs(dy); hit = true }
        if y >= maxY { y = maxY; dy = -abs(dy); hit = true }

        if hit {
            colourIndex = (colourIndex + 1 + Int.random(in: 0..<(colours.count - 1))) % colours.count
        }

        let fracMaxX = max(bounds.width - logoWidth, 1)
        let fracMaxY = max(bounds.height - logoHeight, 1)
        ScrantonDVD.sharedFracX = x / fracMaxX
        ScrantonDVD.sharedFracY = y / fracMaxY
        ScrantonDVD.sharedDXSign = dx > 0 ? 1.0 : -1.0
        ScrantonDVD.sharedDYSign = dy > 0 ? 1.0 : -1.0
        ScrantonDVD.sharedColourIndex = colourIndex

        setNeedsDisplay(bounds)
    }

    override func draw(_ rect: NSRect) {
        guard let path = cachedPath else { return }
        let ci = colourIndex

        if mode == 1 {
            cachedBgColours[ci].setFill()
        } else {
            NSColor.black.setFill()
        }
        bounds.fill()

        guard let ctx = NSGraphicsContext.current?.cgContext else { return }
        ctx.saveGState()
        ctx.translateBy(x: x, y: y + logoHeight)
        ctx.scaleBy(x: 1, y: -1)

        if mode == 2 {
            NSColor.white.setFill()
        } else {
            cachedLogoColours[ci].setFill()
        }
        path.fill()

        ctx.restoreGState()
    }

    override var hasConfigureSheet: Bool { true }

    override var configureSheet: NSWindow? {
        ScrantonDVD.sheetController.getSheet(mode: ScrantonDVD.defaults.integer(forKey: "mode"))
    }

    private func dvdBezierPath(in rect: NSRect) -> NSBezierPath {
        let sx = rect.width / 210.0
        let sy = rect.height / 107.0
        let path = NSBezierPath()

        func pt(_ x: CGFloat, _ y: CGFloat) -> NSPoint {
            NSPoint(x: x * sx, y: y * sy)
        }

        path.move(to: pt(118.895, 20.346))
        path.curve(to: pt(105.855, 38.347), controlPoint1: pt(118.895, 20.346), controlPoint2: pt(105.152, 37.268))
        path.curve(to: pt(100.921, 20.161), controlPoint1: pt(106.830, 37.268), controlPoint2: pt(100.921, 20.161))
        path.curve(to: pt(95.819, 4.774), controlPoint1: pt(100.921, 20.161), controlPoint2: pt(99.688, 16.564))
        path.line(to: pt(81.81, 4.774))
        path.line(to: pt(47.812, 4.774))
        path.line(to: pt(22.175, 4.774))
        path.line(to: pt(19.615, 15.842))
        path.line(to: pt(38.914, 15.842))
        path.line(to: pt(43.493, 15.842))
        path.curve(to: pt(61.371, 30.067), controlPoint1: pt(55.908, 15.842), controlPoint2: pt(63.488, 20.974))
        path.curve(to: pt(36.706, 44.195), controlPoint1: pt(59.084, 39.968), controlPoint2: pt(48.248, 44.195))
        path.line(to: pt(32.39, 44.195))
        path.line(to: pt(37.942, 19.987))
        path.line(to: pt(18.647, 19.987))
        path.line(to: pt(10.455, 55.355))
        path.line(to: pt(37.853, 55.355))
        path.curve(to: pt(81.545, 30.067), controlPoint1: pt(58.465, 55.355), controlPoint2: pt(78.019, 44.288))
        path.curve(to: pt(80.491, 17.014), controlPoint1: pt(82.162, 27.453), controlPoint2: pt(82.075, 20.882))
        path.curve(to: pt(80.313, 16.477), controlPoint1: pt(80.491, 16.921), controlPoint2: pt(80.400, 16.743))
        path.curve(to: pt(80.491, 15.663), controlPoint1: pt(80.226, 16.384), controlPoint2: pt(80.135, 15.755))
        path.curve(to: pt(81.016, 16.021), controlPoint1: pt(80.663, 15.571), controlPoint2: pt(81.016, 15.934))
        path.curve(to: pt(81.367, 16.834), controlPoint1: pt(81.016, 16.021), controlPoint2: pt(81.195, 16.477))
        path.line(to: pt(98.807, 67.149))
        path.line(to: pt(143.211, 15.933))
        path.line(to: pt(161.972, 15.841))
        path.line(to: pt(166.551, 15.841))
        path.curve(to: pt(184.52, 30.066), controlPoint1: pt(178.975, 15.841), controlPoint2: pt(186.641, 20.973))
        path.curve(to: pt(159.77, 44.194), controlPoint1: pt(182.23, 39.967), controlPoint2: pt(171.315, 44.194))
        path.line(to: pt(155.365, 44.194))
        path.line(to: pt(161.0, 19.987))
        path.line(to: pt(141.713, 19.987))
        path.line(to: pt(133.515, 55.355))
        path.line(to: pt(160.913, 55.355))
        path.curve(to: pt(204.517, 30.067), controlPoint1: pt(181.524, 55.355), controlPoint2: pt(201.256, 44.288))
        path.curve(to: pt(172.627, 4.774), controlPoint1: pt(207.864, 15.842), controlPoint2: pt(193.416, 4.774))
        path.line(to: pt(154.484, 4.774))
        path.line(to: pt(131.757, 4.774))
        path.curve(to: pt(118.895, 20.346), controlPoint1: pt(120.923, 17.823), controlPoint2: pt(118.895, 20.346))
        path.close()

        path.move(to: pt(99.424, 67.329))
        path.curve(to: pt(5.0, 81.012), controlPoint1: pt(47.281, 67.329), controlPoint2: pt(5.0, 73.449))
        path.curve(to: pt(99.424, 94.69), controlPoint1: pt(5.0, 88.57), controlPoint2: pt(47.281, 94.69))
        path.curve(to: pt(193.949, 81.012), controlPoint1: pt(151.663, 94.69), controlPoint2: pt(193.949, 88.57))
        path.curve(to: pt(99.424, 67.329), controlPoint1: pt(193.949, 73.449), controlPoint2: pt(151.664, 67.329))
        path.close()

        path.move(to: pt(96.078, 85.873))
        path.curve(to: pt(74.498, 81.278), controlPoint1: pt(84.098, 85.873), controlPoint2: pt(74.498, 83.801))
        path.curve(to: pt(96.078, 76.688), controlPoint1: pt(74.498, 78.755), controlPoint2: pt(84.077, 76.688))
        path.curve(to: pt(117.576, 81.278), controlPoint1: pt(107.966, 76.688), controlPoint2: pt(117.576, 78.754))
        path.curve(to: pt(96.078, 85.873), controlPoint1: pt(117.576, 83.801), controlPoint2: pt(107.966, 85.873))
        path.close()

        path.move(to: pt(182.843, 94.635))
        path.line(to: pt(182.843, 93.653))
        path.line(to: pt(177.098, 93.653))
        path.line(to: pt(176.859, 94.635))
        path.line(to: pt(179.251, 94.635))
        path.line(to: pt(178.286, 102.226))
        path.line(to: pt(179.49, 102.226))
        path.line(to: pt(180.445, 94.635))
        path.close()

        path.move(to: pt(191.453, 102.226))
        path.line(to: pt(191.453, 93.653))
        path.line(to: pt(190.504, 93.653))
        path.line(to: pt(187.384, 99.534))
        path.line(to: pt(185.968, 93.653))
        path.line(to: pt(185.013, 93.653))
        path.line(to: pt(182.36, 102.226))
        path.line(to: pt(183.337, 102.226))
        path.line(to: pt(185.475, 95.617))
        path.line(to: pt(186.917, 102.226))
        path.line(to: pt(190.276, 95.617))
        path.line(to: pt(190.504, 102.226))
        path.close()

        return path
    }
}

class SheetController: NSObject {
    var window: NSWindow?

    func getSheet(mode: Int) -> NSWindow {
        if let w = window {
            if let popup = w.contentView?.viewWithTag(1) as? NSPopUpButton {
                popup.selectItem(at: min(mode, 2))
            }
            return w
        }

        let w = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 260, height: 100),
            styleMask: [.titled],
            backing: .buffered,
            defer: false
        )
        w.title = "Scranton DVD"
        w.isReleasedWhenClosed = false

        let container = NSView(frame: NSRect(x: 0, y: 0, width: 260, height: 100))

        let popup = NSPopUpButton(frame: NSRect(x: 20, y: 55, width: 220, height: 25), pullsDown: false)
        popup.addItems(withTitles: ["Classic", "Colorful", "Monochrome"])
        popup.selectItem(at: min(mode, 2))
        popup.tag = 1
        container.addSubview(popup)

        let okButton = NSButton(title: "OK", target: self, action: #selector(configOK(_:)))
        okButton.frame = NSRect(x: 150, y: 12, width: 80, height: 30)
        okButton.keyEquivalent = "\r"
        container.addSubview(okButton)

        let cancelButton = NSButton(title: "Cancel", target: self, action: #selector(configCancel(_:)))
        cancelButton.frame = NSRect(x: 60, y: 12, width: 80, height: 30)
        cancelButton.keyEquivalent = "\u{1b}"
        container.addSubview(cancelButton)

        w.contentView = container
        window = w
        return w
    }

    private func dismiss(_ w: NSWindow) {
        if let parent = w.sheetParent {
            parent.endSheet(w)
        } else {
            w.orderOut(nil)
        }
    }

    @objc func configOK(_ sender: NSButton) {
        guard let w = sender.window else { return }
        if let popup = w.contentView?.viewWithTag(1) as? NSPopUpButton {
            let mode = popup.indexOfSelectedItem
            let defaults = UserDefaults(suiteName: defaultsKey) ?? .standard
            defaults.set(mode, forKey: "mode")
            defaults.synchronize()

        }
        dismiss(w)
    }

    @objc func configCancel(_ sender: NSButton) {
        guard let w = sender.window else { return }
        dismiss(w)
    }
}
