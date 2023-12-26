//
//  Image.swift
//  ProjectMemes
//
//  Created by Mahmud CIKRIK on 3.11.2023.
//

import UIKit

class Image: NSObject {
    
    var image: String?
    var savedImage: UIImage?
    
    init(image: String? = nil , savedImage: UIImage? = nil ) {
        
        self.image = image
        self.savedImage = savedImage
    }

}
