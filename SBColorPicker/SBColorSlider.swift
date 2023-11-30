//
//  SBColorSlider.swift
//  SBColorPicker
//
//  Created by Soumen Bhuin on 27/11/23.
//  Copyright © 2023 smbhuin. All rights reserved.
//

import UIKit

@available(iOS 12.0, *)
class SBColorSlider: UISlider {
    var trackStartColor: UIColor = .clear {
        didSet {
            self.setNeedsDisplay()
        }
    }
    var trackEndColor: UIColor = .black {
        didSet {
            self.setNeedsDisplay()
        }
    }
    private var background: UIImage?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    private func setup() {
        self.maximumTrackTintColor = .clear
        self.minimumTrackTintColor = .clear
        self.tintColor = .clear
        self.maximumValue = 1.0
        self.minimumValue = 0.0
        let context = CIContext()
        let scale = UIScreen.main.scale
        let filter = CIFilter(name: "CICheckerboardGenerator",
                              parameters: ["inputColor0": CIColor.white,
                            "inputColor1": CIColor.gray, "inputCenter": CIVector(x: 0, y: 0), "inputWidth": 5*scale])
        guard let outputImage = filter?.outputImage else { return }
        guard let image = context.createCGImage(outputImage,
                        from: CGRect(x: bounds.minX * scale,
                                     y: bounds.minY * scale,
                                     width: (bounds.width) * scale,
                                     height: bounds.height * scale
                                    )
        )
        else { return }
        background = UIImage(cgImage: image, scale: scale, orientation: .up)
        setNeedsDisplay()
    }
    override func tintColorDidChange() {
        self.maximumTrackTintColor = .clear
        self.minimumTrackTintColor = .clear
        self.tintColor = .clear
    }
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: rect.width, height: rect.height),
                                cornerRadius: rect.height/2)
        let context = UIGraphicsGetCurrentContext()!
        let colors = [trackStartColor.cgColor, trackEndColor.cgColor]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        context.addPath(path.cgPath)
        context.clip()
        if let bgd = background {
            bgd.draw(at: .zero)
        }
        let colorLocations: [CGFloat] = [0.0, 1.0]
        let gradient = CGGradient(colorsSpace: colorSpace,
                                       colors: colors as CFArray,
                                    locations: colorLocations)!
        let startPoint = CGPoint(x: 0, y: 0)
        let endPoint = CGPoint(x: bounds.width, y: 0)
        context.drawLinearGradient(gradient,
                            start: startPoint,
                              end: endPoint,
                              options: [.drawsAfterEndLocation])
        context.setStrokeColor(UIColor.init(white: 0, alpha: 0.2).cgColor)
        path.lineWidth = 1
        path.stroke()
    }
}
