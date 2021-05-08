//
//  Decode.swift
//  GettMobileDelivery
//
//  Created by Tal talspektor on 08/05/2021.
//

import Foundation

extension JSONDecoder {

    func decode<T: Decodable>(jsonData: Data, type: T.Type) throws -> T {
        do {
            let decodedData = try decode(T.self, from: jsonData)
            return decodedData
        } catch {
            debugPrint(error.localizedDescription)
            throw DataProviderErrors.decodingError
        }
    }
}
