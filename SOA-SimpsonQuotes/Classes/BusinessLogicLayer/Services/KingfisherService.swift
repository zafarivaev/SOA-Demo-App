import UIKit
import Kingfisher

private let kingfisherServiceName = "KingfisherService"

protocol KingfisherService: Service {
    func loadImageFrom(urlString: String, success: @escaping (Data) -> (), failure: @escaping (KingfisherError) -> ())
}

extension KingfisherService {
    var serviceName: String {
        get {
            kingfisherServiceName
        }
    }
    
    internal func loadImageFrom(urlString: String, success: @escaping (Data) -> (), failure: @escaping (KingfisherError) -> ()) {
        
        guard let url = URL(string: urlString) else {
            return
        }

        ImageDownloader.default.downloadImage(with: url, options: nil, progressBlock: nil) { result in
            switch result {
            case .success(let value):
                print("Data: \(value.originalData)")
                success(value.originalData)
            case .failure(let error):
                print("Error: \(error)")
                failure(error)
            }
        }
    }
    
}

internal class KingfisherServiceImplementation: KingfisherService {
    internal static func register() {
        ServiceRegistry.add(service: LazyService(serviceName: kingfisherServiceName, serviceGetter: { () -> Service in
            return KingfisherServiceImplementation()
        }))
    }
}

extension ServiceRegistryImplementation {
    var kingfisherService: KingfisherService {
        get {
            return serviceWith(name: kingfisherServiceName) as! KingfisherService
        }
    }
}
