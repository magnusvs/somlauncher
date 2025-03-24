//
//  ImageSaver.swift
//  SomLauncher
//
//  Created by Magnus von Scheele on 2024-10-29.
//
import SwiftUI

extension NSBitmapImageRep {
    var png: Data? { representation(using: .png, properties: [:]) }
}
extension Data {
    var bitmap: NSBitmapImageRep? { NSBitmapImageRep(data: self) }
}
extension NSImage {
    var png: Data? { tiffRepresentation?.bitmap?.png }
}

class ImageSaver {

    static func writeImage(image: NSImage) {
        let size = Int(image.size.width)
        let imageURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!.appendingPathComponent("icon-\(size).png")
        if let png = image.png {
            do {
                try png.write(to: imageURL)
                print("PNG image saved")
            } catch {
                print(error)
            }
        }
    }
}
