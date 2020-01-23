//
//  ImageDataService.swift
//  VIPER-SimpsonQuotes
//
//  Created by Zafar on 1/3/20.
//  Copyright © 2020 Zafar. All rights reserved.
//

import UIKit

private let imageDataServiceName = "ImageDataService"

protocol ImageDataService: Service {
    
    func convertToUIImage(from data: Data) -> UIImage
}

extension ImageDataService {
    var serviceName: String {
        get {
            return imageDataServiceName
        }
    }
    
    internal func convertToUIImage(from data: Data) -> UIImage {
        return UIImage(data: data)!
    }
}

internal class ImageDataServiceImplementation: ImageDataService {
    internal static func register() {
        ServiceRegistry.add(service: LazyService(serviceName: imageDataServiceName, serviceGetter: { () -> Service in
            return ImageDataServiceImplementation()
        }))
    }
}

extension ServiceRegistryImplementation {
    var imageDataService: ImageDataService {
        get {
            return serviceWith(name: imageDataServiceName) as! ImageDataService
        }
    }
}
