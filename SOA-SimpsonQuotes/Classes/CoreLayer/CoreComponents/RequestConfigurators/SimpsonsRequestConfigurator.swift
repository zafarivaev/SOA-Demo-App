//
//  SimpsonsRequestConfigurator.swift
//  VIPER-SimpsonQuotes
//
//  Created by Zafar on 1/23/20.
//  Copyright © 2020 Zafar. All rights reserved.
//

import Foundation

struct SimpsonsRequestConfigurator {
    
    static func configureURLString(_ baseURL: String, _ parameter: String, _ value: String) -> String {
        return baseURL + "?" + parameter + "=" + value
    }
}
