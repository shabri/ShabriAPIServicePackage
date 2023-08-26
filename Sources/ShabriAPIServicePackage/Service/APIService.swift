//
//  APIService.swift
//  StoresAndSearchApp
//
//  Created by Shabarinath Pabba on 8/24/23.
//

import Foundation

public protocol APIServiceProtocol {
    func make<T: Decodable>(request: GenericServiceRequest<T>, completion: @escaping (Result<T, APIError>) -> ())
}

public protocol URLSessionProtocol {
    func task(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> ())
}

public protocol JSONDecoderProtocol {
    func searchProjectDecode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
}

public final class APIService: APIServiceProtocol {
    let session: URLSessionProtocol
    let decoder: JSONDecoderProtocol
    
    public init(session: URLSessionProtocol = URLSession.shared, decoder: JSONDecoderProtocol = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    public func make<T: Decodable>(request: GenericServiceRequest<T>, completion: @escaping (Result<T, APIError>) -> ()) {
        self.session.task(request: request.urlRequest) { [unowned self] data, response, error in
            if let error = error {
                completion(.failure(.serverError(error)))
                return
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            do {
                let stores = try self.decoder.searchProjectDecode(T.self, from: data)
                completion(.success(stores))
            }
            catch let error {
                completion(.failure(.parsingError(error)))
            }
        }
    }
}

extension URLSession: URLSessionProtocol {
    public func task(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        let task = self.dataTask(with: request) { data, response, error in
            completion(data, response, error)
        }
        task.resume()
    }
}

extension JSONDecoder: JSONDecoderProtocol {
    public func searchProjectDecode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        do {
            let v = try self.decode(type, from: data)
            return v
        }
        catch let error {
            throw error
        }
    }
}
