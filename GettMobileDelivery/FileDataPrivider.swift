//
//  FileDataPrivider.swift
//  GettMobileDelivery
//
//  Created by Tal talspektor on 08/05/2021.
//

import Foundation

final class FileDataPrivider {

    static let sourseFileName = "journey"
    static let sourseFileExtecsion = "json"

    func readLocalFile(forName name: String) throws -> Data {
        do {
            guard let bundlePath = Bundle.main.path(forResource: name, ofType: "json") else { throw DataProviderErrors.fileNotFound }
            guard let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) else { throw DataProviderErrors.castStringToDataError }
            return jsonData
        } catch {
            print(error)
            throw DataProviderErrors.otherError
        }
    }

    func writeToFile(location: URL, type: [MyLocation]) {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(type)
            try jsonData.write(to: location)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}
