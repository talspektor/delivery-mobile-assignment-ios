//
//  PickupPointViewModel.swift
//  GettMobileDelivery
//
//  Created by Tal talspektor on 08/05/2021.
//

import Foundation
import Combine

class LocationViewModel {
    private let dataProvider = FileDataPrivider()
    var update = PassthroughSubject<[MyLocation], Never>()
    var dataModel = [MyLocation]() {
        didSet {
            update.send(dataModel)
        }
    }

    func fetchData() {
        do {
            let data = try  dataProvider.readLocalFile(forName: "journey")
            dataModel = try JSONDecoder().decode(jsonData: data, type:[MyLocation].self)
        } catch {
            print(error)
        }
    }

    func updateState(by index: Int, state: MyLocation.State) {
        dataModel[index].state = state
        guard let fileUrl = Bundle.main.url(forResource: FileDataPrivider.sourseFileName,
                                            withExtension: FileDataPrivider.sourseFileExtecsion) else { return }
        dataProvider.writeToFile(location: fileUrl, type: dataModel)
    }

    func updateState(by location: MyLocation, state: MyLocation.State) {
        let location = dataModel.first { $0 == location }
        location?.state = state
        guard let fileUrl = Bundle.main.url(forResource: FileDataPrivider.sourseFileName,
                                            withExtension: FileDataPrivider.sourseFileExtecsion) else { return }
        dataProvider.writeToFile(location: fileUrl, type: dataModel)
        fetchData()
    }
}
