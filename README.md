# SBColorPicker

A Color Picker similar to UIColorPickerViewController but has support from iOS 12.0.

## HOW TO USE?

```swift
    @IBAction func btnPickColorPressed(_ sender: UIButton) {
        let picker = SBColorPickerViewController()
        picker.selectedColor = .black
        picker.modalPresentationStyle = .popover
        picker.popoverPresentationController?.sourceView = sender
        picker.delegate = self
        present(picker, animated: true)
    }
    
    // Delegate Implementation
    
    func colorPickerViewControllerDidFinish(_ viewController: SBColorPickerViewController) {
        debugPrint("Color Picker Closed!")
    }
    func colorPickerViewController(_ viewController: SBColorPickerViewController,
                                   didSelect color: UIColor, continuously: Bool) {
        debugPrint("Color Picked:\(color)")
    }
```

## LICENSE

This library is licensed under MIT. Full license text is available in [LICENSE](https://github.com/smbhuin/SBColorPicker/blob/master/LICENSE).
