//
//  GenericServiceRequest.swift
//  StoresAndSearchApp
//
//  Created by Shabarinath Pabba on 8/24/23.
//

import Foundation

open class GenericServiceRequest<T: Decodable> {
    var urlRequest: URLRequest
    public init(urlRequest: URLRequest) {
        self.urlRequest = urlRequest
    }
}
