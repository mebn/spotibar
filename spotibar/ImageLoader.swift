//
//  ImageLoader.swift
//  spotibar
//
//  Created by Marcus Nilszén on 2020-12-28.
//

import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    @Published var downloadImage: UIImage?
}
