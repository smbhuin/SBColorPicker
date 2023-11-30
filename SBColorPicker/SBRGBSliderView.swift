//
//  SBRGBSlidersView.swift
//  SBColorPicker
//
//  Created by Soumen Bhuin on 20/11/23.
//  Copyright © 2023 smbhuin. All rights reserved.
//

import UIKit

protocol SBRGBSliderViewDelegate: NSObjectProtocol {
    func sliderView(_ slider: SBRGBSliderView, didSelect color: UIColor, continuously: Bool)
}

class SBRGBSliderView: UIView {
    var redLabel = UILabel(), greenLabel = UILabel(), blueLabel = UILabel()
    var redSlider = SBColorSlider(), greenSlider = SBColorSlider(), blueSlider = SBColorSlider()
    var redValue = UILabel(), greenValue = UILabel(), blueValue = UILabel()
    var delegate: SBRGBSliderViewDelegate?
    var color: UIColor = .black {
        didSet {
            var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0
            color.getRed(&red, green: &green, blue: &blue, alpha: nil)
            redSlider.value = Float(red)
            greenSlider.value = Float(green)
            blueSlider.value = Float(blue)
            redValue.text = "\(Int(red*255.0))"
            greenValue.text = "\(Int(green*255.0))"
            blueValue.text = "\(Int(blue*255.0))"
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupSubviews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var intrinsicContentSize: CGSize {
        return .init(width: UIView.noIntrinsicMetric, height: 164.0)
    }
    func buildColorSliderStack(label: String, color: UIColor, colorLabel: UILabel,
                               colorSlider: SBColorSlider, colorValue: UILabel) -> UIStackView {
        let rstack = UIStackView()
        rstack.axis = .horizontal
        colorLabel.text = label
        rstack.addArrangedSubview(colorLabel)
        colorLabel.widthAnchor.constraint(equalToConstant: 64.0).isActive = true
        colorSlider.trackStartColor = .black
        colorSlider.trackEndColor = color
        colorSlider.thumbTintColor = .white
        colorSlider.addTarget(self, action: #selector(self.sliderValueChanged(sender:)), for: .valueChanged)
        colorSlider.addTarget(self, action: #selector(self.sliderEndDragging(sender:)),
                              for: [.touchUpInside, .touchUpOutside])
        rstack.addArrangedSubview(colorSlider)
        colorValue.textAlignment = .center
        rstack.addArrangedSubview(colorValue)
        colorValue.widthAnchor.constraint(equalToConstant: 64.0).isActive = true
        return rstack
    }
    func setupSubviews() {
        let vstack = UIStackView()
        vstack.translatesAutoresizingMaskIntoConstraints = false
        vstack.axis = .vertical
        vstack.alignment = .fill
        vstack.distribution = .equalSpacing
        let red = buildColorSliderStack(
            label: "Red",
            color: .red,
            colorLabel: redLabel,
            colorSlider: redSlider,
            colorValue: redValue
        )
        vstack.addArrangedSubview(red)
        let green = buildColorSliderStack(
            label: "Green",
            color: .green,
            colorLabel: greenLabel,
            colorSlider: greenSlider,
            colorValue: greenValue
        )
        vstack.addArrangedSubview(green)
        let blue = buildColorSliderStack(
            label: "Blue",
            color: .blue,
            colorLabel: blueLabel,
            colorSlider: blueSlider,
            colorValue: blueValue
        )
        vstack.addArrangedSubview(blue)
        addSubview(vstack)
        let topConstraint = vstack.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0)
        let leftConstraint = vstack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0)
        let rightConstraint = vstack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0)
        let bottomConstraint = vstack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0)
        NSLayoutConstraint.activate([topConstraint, leftConstraint, rightConstraint, bottomConstraint])
    }
    override class var requiresConstraintBasedLayout: Bool { true }
    @objc func sliderValueChanged(sender slider: UISlider) {
        let value = Int(slider.value*255.0)
        switch slider {
        case self.redSlider:
            redValue.text = "\(value)"
        case self.greenSlider:
            greenValue.text = "\(value)"
        case self.blueSlider:
            blueValue.text = "\(value)"
        default:
            break
        }
        delegate?.sliderView(self, didSelect: UIColor(red: CGFloat(redSlider.value),
                                                      green: CGFloat(greenSlider.value),
                                                      blue: CGFloat(blueSlider.value), alpha: 1.0),
                                                        continuously: true)
    }
    @objc func sliderEndDragging(sender slider: UISlider) {
        delegate?.sliderView(self, didSelect: UIColor(red: CGFloat(redSlider.value),
                                                      green: CGFloat(greenSlider.value),
                                                      blue: CGFloat(blueSlider.value), alpha: 1.0),
                                                        continuously: false)
    }
}
