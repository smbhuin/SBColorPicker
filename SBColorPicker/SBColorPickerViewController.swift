//
//  SBColorPickerViewController.swift
//  SBColorPicker
//
//  Created by Soumen Bhuin on 20/11/23.
//  Copyright © 2023 smbhuin. All rights reserved.
//

import UIKit

@available(iOS 12.0, *)
@MainActor @objc public protocol SBColorPickerViewControllerDelegate: NSObjectProtocol {
    @objc optional func colorPickerViewController(_ viewController: SBColorPickerViewController,
                                                  didSelect color: UIColor, continuously: Bool)
    @objc optional func colorPickerViewControllerDidFinish(_ viewController: SBColorPickerViewController)
}

@available(iOS 12.0, *)
@MainActor @objc public class SBColorPickerViewController: UIViewController {
    private let titleLabel = UILabel()
    private let sliderView = SBRGBSliderView()
    private let closeButton = UIButton()
    private let colorView = UIView()
    private let rgbHexLabel = UILabel()
    private let rgbHexInput = UITextField()
    @objc public var delegate: SBColorPickerViewControllerDelegate?
    @objc public var supportsAlpha: Bool = false
    @objc public var selectedColor: UIColor = .black {
        didSet {
            let hexString = selectedColor.hexString
            updateSelectedColor(from: hexString)
            rgbHexInput.text = hexString
        }
    }
    public override var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    public init() {
        super.init(nibName: nil, bundle: nil)
        preferredContentSize = .init(width: 360, height: 400)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layoutTitleLabel()
        layoutCloseButton()
        layoutRGBSlider()
        layoutColorView()
        layoutRGBHexLabel()
        layoutRGBHexInput()
        sliderView.delegate = self
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(self.viewPressed(sender:)))
        view.addGestureRecognizer(gesture)
    }
    func layoutTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.text = self.title ?? "Color"
        let topConstraint = titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24.0)
        let centerXConstraint = titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0)
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([topConstraint, centerXConstraint])
    }
    func layoutCloseButton() {
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.backgroundColor = .lightGray
        closeButton.setTitle("✕", for: .normal)
        closeButton.layer.cornerRadius = 8.0
        closeButton.addTarget(self, action: #selector(self.closePressed(sender:)), for: .touchUpInside)
        let rightConstraint = closeButton.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0)
        let centerYConstraint = closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor, constant: 0.0)
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([centerYConstraint, rightConstraint])
    }
    func layoutRGBSlider() {
        let topConstraint = sliderView.topAnchor.constraint(
            equalTo: titleLabel.bottomAnchor, constant: 48.0)
        let leftConstraint = sliderView.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16.0)
        let rightConstraint = sliderView.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0)
        view.addSubview(sliderView)
        NSLayoutConstraint.activate([topConstraint, leftConstraint, rightConstraint])
    }
    func layoutColorView() {
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.backgroundColor = selectedColor
        colorView.layer.cornerRadius = 8.0
        colorView.layer.borderColor = UIColor(white: 0.0, alpha: 0.2).cgColor
        colorView.layer.borderWidth = 1.0
        let topConstraint = colorView.topAnchor.constraint(
            equalTo: sliderView.bottomAnchor, constant: 32.0)
        let leftConstraint = colorView.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16.0)
        let widthConstraint = colorView.widthAnchor.constraint(equalToConstant: 64.0)
        let heightConstraint = colorView.heightAnchor.constraint(equalToConstant: 64.0)
        view.addSubview(colorView)
        NSLayoutConstraint.activate([topConstraint, leftConstraint, widthConstraint, heightConstraint])
    }
    func layoutRGBHexLabel() {
        rgbHexLabel.translatesAutoresizingMaskIntoConstraints = false
        rgbHexLabel.textAlignment = .center
        rgbHexLabel.text = "sRGB Hex Code"
        rgbHexLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        let topConstraint = rgbHexLabel.topAnchor.constraint(equalTo: sliderView.bottomAnchor, constant: 32.0)
        let leftConstraint = rgbHexLabel.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 32.0)
        view.addSubview(rgbHexLabel)
        NSLayoutConstraint.activate([topConstraint, leftConstraint])
    }
    func layoutRGBHexInput() {
        rgbHexInput.translatesAutoresizingMaskIntoConstraints = false
        rgbHexInput.textAlignment = .center
        rgbHexInput.text = selectedColor.hexString
        rgbHexInput.borderStyle = .roundedRect
        rgbHexInput.returnKeyType = .done
        rgbHexInput.delegate = self
        let topConstraint = rgbHexInput.topAnchor.constraint(equalTo: rgbHexLabel.bottomAnchor, constant: 8.0)
        let leftConstraint = rgbHexInput.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 32.0)
        let widthConstraint = rgbHexInput.widthAnchor.constraint(equalToConstant: 128.0)
        view.addSubview(rgbHexInput)
        NSLayoutConstraint.activate([topConstraint, leftConstraint, widthConstraint])
    }
    @objc func viewPressed(sender: Any) {
        rgbHexInput.resignFirstResponder()
    }
    @objc func closePressed(sender: Any) {
        rgbHexInput.resignFirstResponder()
        self.delegate?.colorPickerViewControllerDidFinish?(self)
        self.dismiss(animated: true)
    }
    func updateSelectedColor(from: String) {
        let color = UIColor(hexString: from)
        colorView.backgroundColor = color
        sliderView.color = color
    }
}

extension SBColorPickerViewController: UITextFieldDelegate {
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if let txt = textField.text {
            updateSelectedColor(from: txt)
        }
    }
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        if updatedText.count <= 7 {
            let customSet = CharacterSet(charactersIn: "#0123456789ABCDEFabcdef")
            if string.rangeOfCharacter(from: customSet.inverted) == nil {
                updateSelectedColor(from: updatedText)
                return true
            }
        }
        return false
    }
}

extension SBColorPickerViewController: SBRGBSliderViewDelegate {
    func sliderView(_ slider: SBRGBSliderView, didSelect color: UIColor, continuously: Bool) {
        colorView.backgroundColor = color
        rgbHexInput.text = color.hexString
        self.delegate?.colorPickerViewController?(self, didSelect: color, continuously: continuously)
    }
}
