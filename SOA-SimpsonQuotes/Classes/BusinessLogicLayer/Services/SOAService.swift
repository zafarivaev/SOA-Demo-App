//
//  SOAService.swift
//  VIPER-SimpsonQuotes
//
//  Created by Zafar on 1/22/20.
//  Copyright © 2020 Zafar. All rights reserved.
//

let ServiceRegistry = ServiceRegistryImplementation()

protocol SOAService {
    var serviceName : String { get }
    func register()
}

extension SOAService {
    internal func register() {
        ServiceRegistry.add(service: self)
    }
}

final class SOALazyService : SOAService {
    internal let serviceName : String

    internal lazy var serviceGetter : (() -> SOAService) = {
        if self.service == nil {
            self.service = self.implementationGetter()
        }
        return self.service!
    }

    private var implementationGetter : (() -> SOAService)

    private var service : SOAService? = nil

    internal init(serviceName : String, serviceGetter : @escaping (() -> SOAService)) {
        self.serviceName = serviceName
        self.implementationGetter = serviceGetter
    }
}

struct ServiceRegistryImplementation {
    private static var serviceDictionary : [String : SOALazyService] = [:]
    
    internal func add(service: SOALazyService) {
        if ServiceRegistryImplementation.serviceDictionary[service.serviceName] != nil {
            print("WARNING: registering service \(service.serviceName) is already registered.")
        }
        ServiceRegistryImplementation.serviceDictionary[service.serviceName] = service
    }
    
    internal func add(service: SOAService) {
        add(service: SOALazyService(serviceName: service.serviceName, serviceGetter: { service }))
    }

    internal func serviceWith(name: String) -> SOAService {
        guard let resolvedService = ServiceRegistryImplementation().get(serviceWithName: name) else {
            fatalError("Error: SOAService \(name) is not registered with the ServiceRegistry.")
        }
        return resolvedService
    }

    private func get(serviceWithName name: String) -> SOAService? {
        return ServiceRegistryImplementation.serviceDictionary[name]?.serviceGetter()
    }
}

