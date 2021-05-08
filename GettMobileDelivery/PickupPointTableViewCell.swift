//
//  PickupPointTableViewCell.swift
//  GettMobileDelivery
//
//  Created by Tal talspektor on 07/05/2021.
//

import UIKit

class PickupPointTableViewCell: UITableViewCell {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var stateSwitch: UISwitch!

    private var pickupPoint: PickupPoint?

    static let cellIdentifier = "PickupPointTableViewCell"
    static let nib = UINib(nibName: cellIdentifier, bundle: nil)

    func config(with pickupPoint: PickupPoint) {
        self.pickupPoint = pickupPoint
        setupUI()
    }

    private func setupUI() {
        guard let pickupPoint = self.pickupPoint else { return }//TODO: show alert
        typeLabel.text = pickupPoint.type
        addressLabel.text = pickupPoint.geo.address
        stateSwitch.isOn = pickupPoint.state.isActive
    }

    @IBAction func didSwitch(_ sender: UISwitch) {
    }
    
}
