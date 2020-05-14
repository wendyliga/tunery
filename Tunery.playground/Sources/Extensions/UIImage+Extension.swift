//
//  UIImage+Extension.swift
//  wwdc2020
//
//  Created by Wendy Liga on 12/05/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import UIKit

extension UIImage {
    static func qrcode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
}
