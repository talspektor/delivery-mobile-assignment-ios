//
//  AddressesViewController.swift
//  GettMobileDelivery
//
//  Created by Tal talspektor on 06/05/2021.
//

import UIKit

class PickupPointsViewController: UIViewController {

    @IBOutlet weak var pickupPointsTableView: UITableView!
    private let dataProvider = FileDataPrivider()

    var dataModel = [PickupPoint]()

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            let data = try  dataProvider.readLocalFile(forName: "journey")
            dataModel = try JSONDecoder().decode(jsonData: data, type:[PickupPoint].self)
        } catch {
            print(error)
        }
        registerCell()
    }

    private func registerCell() {
        pickupPointsTableView.register(PickupPointTableViewCell.nib, forCellReuseIdentifier: PickupPointTableViewCell.cellIdentifier)
    }
}

extension PickupPointsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PickupPointTableViewCell.cellIdentifier,
                                                       for: indexPath) as? PickupPointTableViewCell else { return UITableViewCell() }
        cell.config(with: dataModel[indexPath.row])
        return cell
    }


}
