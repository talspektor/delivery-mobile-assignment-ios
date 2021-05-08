//
//  Errors.swift
//  GettMobileDelivery
//
//  Created by Tal talspektor on 08/05/2021.
//

import Foundation

enum DataProviderErrors: Error {
    case castStringToDataError
    case decodingError
    case fileNotFound
    case otherError
}
