//
//  SOAService.swift
//  VIPER-SimpsonQuotes
//
//  Created by Zafar on 1/22/20.
//  Copyright © 2020 Zafar. All rights reserved.
//

let ServiceRegistry = ServiceRegistryImplementation()

protocol Service {
    var serviceName : String { get }
    func register()
}

extension Service {
    func register() {
        ServiceRegistry.add(service: self)
    }
}

final class LazyService : Service {
    let serviceName : String

    lazy var serviceGetter : (() -> Service) = {
        if self.service == nil {
            self.service = self.implementationGetter()
        }
        return self.service!
    }

    private var implementationGetter : (() -> Service)

    private var service : Service? = nil

    init(serviceName : String, serviceGetter : @escaping (() -> Service)) {
        self.serviceName = serviceName
        self.implementationGetter = serviceGetter
    }
}

struct ServiceRegistryImplementation {
    private static var serviceDictionary : [String : LazyService] = [:]
    
    func add(service: LazyService) {
        if ServiceRegistryImplementation.serviceDictionary[service.serviceName] != nil {
            print("WARNING: service \(service.serviceName) is already registered.")
        }
        ServiceRegistryImplementation.serviceDictionary[service.serviceName] = service
    }
    
    func add(service: Service) {
        add(service: LazyService(serviceName: service.serviceName, serviceGetter: { service }))
    }

    func serviceWith(name: String) -> Service {
        guard let resolvedService = ServiceRegistryImplementation().get(serviceWithName: name) else {
            fatalError("Error: SOAService \(name) is not registered via ServiceRegistry.")
        }
        return resolvedService
    }

    private func get(serviceWithName name: String) -> Service? {
        return ServiceRegistryImplementation.serviceDictionary[name]?.serviceGetter()
    }
}

