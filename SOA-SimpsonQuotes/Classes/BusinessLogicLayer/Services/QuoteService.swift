//
//  QuoteService.swift
//  VIPER-SimpsonQuotes
//
//  Created by Zafar on 1/2/20.
//  Copyright © 2020 Zafar. All rights reserved.
//

import ObjectMapper

private let quoteServiceName = "QuoteService"

extension ServiceRegistryImplementation {
    var quoteService: QuoteService {
        get {
            return serviceWith(name: quoteServiceName) as! QuoteService
        }
    }
}

protocol QuoteService: SOAService {
    func getQuotes(count: Int, success: @escaping (Int, [Quote]) -> (), failure: @escaping (Int) -> ())
}

extension QuoteService {
    var serviceName: String {
        get {
            return quoteServiceName
        }
    }
    
    func getQuotes(count: Int, success: @escaping (Int, [Quote]) -> (), failure: @escaping (Int) -> ()) {
        
        let urlString = SimpsonsRequestConfigurator.configureURLString(Endpoints.QUOTES, "count", "\(count)")
        let client = NetworkClient(baseUrl: BaseURLs.simpsons)

        client.getArray(urlString: urlString, success: { (code, arrayOfQuotes) in
            success(code, arrayOfQuotes)

        }) { (code) in
            failure(code)
        }
    }
}

internal class QuoteServiceImplementation: QuoteService {
    internal static func register() {
        ServiceRegistry.add(service: SOALazyService(serviceName: quoteServiceName, serviceGetter: {
            QuoteServiceImplementation()
        }))
    }
}
