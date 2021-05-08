//
//  PickupPoint.swift
//  GettMobileDelivery
//
//  Created by Tal talspektor on 07/05/2021.
//

import Foundation

struct PickupPoint: Codable {
    enum Action: String, Codable {
        case navigateToPickup
        case pickup
        case navigateToDropOff
        case dropOff
    }
    enum State: String, Codable {
        case active
        case unActive

        var isActive: Bool {
            switch self {
            case .active:
                return true
            case .unActive:
                return false
            }
        }

        var getValue: String {
            switch self {
            case .active:
                return "Active"
            case .unActive:
                return "Not Active"
            }
        }
    }
    let type: String
    let state: State
    let geo: Geo
    let parcels: [Parcels]?
}

struct Geo: Codable {
    let address: String
    let latitue: Double
    let longitude: Double
}

struct Parcels: Codable {
    let barcode: String
    let display_identifier: String
}
