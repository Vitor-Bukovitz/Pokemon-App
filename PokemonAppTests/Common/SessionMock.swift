//
//  SessionMock.swift
//  PokemonAppTests
//
//  Created by PremierSoft on 15/08/21.
//

import Foundation
import XCTest

class URLProtocolMock: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let requestHandler = Self.requestHandler else {
            XCTFail("You forgot to set the mock protocol request handler")
            return
        }
        do {
            let (response, data) = try requestHandler(request)
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            self.client?.urlProtocol(self, didLoad: data)
            self.client?.urlProtocolDidFinishLoading(self)
        } catch {
            self.client?.urlProtocol(self, didFailWithError:error)
        }
    }
    
    override func stopLoading() {}
}
