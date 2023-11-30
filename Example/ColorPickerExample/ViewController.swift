//
//  ViewController.swift
//  ColorPickerExample
//
//  Created by Soumen Bhuin on 20/11/23.
//  Copyright (c) 2023 smbhuin. All rights reserved.

import UIKit
import SBColorPicker

class ViewController: UIViewController, SBColorPickerViewControllerDelegate {
    @IBAction func btnPickColorPressed(_ sender: UIButton) {
        let picker = SBColorPickerViewController()
        picker.selectedColor = .black
        picker.modalPresentationStyle = .popover
        picker.popoverPresentationController?.sourceView = sender
        picker.delegate = self
        present(picker, animated: true)
    }
    func colorPickerViewControllerDidFinish(_ viewController: SBColorPickerViewController) {
        debugPrint("Picker Closed!")
    }
    func colorPickerViewController(_ viewController: SBColorPickerViewController,
                                   didSelect color: UIColor, continuously: Bool) {
        debugPrint("Color Picked:\(color)")
        if continuously {
            self.view.backgroundColor = color
        } else {
            self.view.backgroundColor = color
        }
    }
}
