//
//  APIError.swift
//  StoresAndSearchApp
//
//  Created by Shabarinath Pabba on 8/24/23.
//

import Foundation
public enum APIError: Error {
    case serverError(Error)
    case noData
    case parsingError(Error)
}
