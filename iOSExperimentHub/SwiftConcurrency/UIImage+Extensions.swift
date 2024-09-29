//
//  UIImage+Extensions.swift
//  iOSExperimentHub
//
//  Created by Huy Pham on 28/9/24.
//

import Foundation
import UIKit

extension UIImage {
    var thumbnail: UIImage? {
        get async {
            let size = CGSize(width: 40, height: 40)
            return await self.byPreparingThumbnail(ofSize: size)
        }
    }
}
