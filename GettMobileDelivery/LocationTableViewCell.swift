//
//  PickupPointTableViewCell.swift
//  GettMobileDelivery
//
//  Created by Tal talspektor on 07/05/2021.
//

import UIKit
import Combine

class LocationTableViewCell: UITableViewCell {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var stateSwitch: UISwitch!
    @IBOutlet weak var navigateButton: UIButton!
    
    static let cellIdentifier = "LocationTableViewCell"
    static let nib = UINib(nibName: cellIdentifier, bundle: nil)

    var setState = PassthroughSubject<MyLocation.State, Never>()
    var navigate: Just<MyLocation>?//PassthroughSubject<MyLocation, Never>()

    private var myLocation: MyLocation?

    override func prepareForReuse() {
        super.prepareForReuse()
        setupUI()
    }

    func config(with pickupPoint: MyLocation, isEnable: Bool) {
        self.myLocation = pickupPoint
        navigateButton.isEnabled = isEnable
        setupUI()
    }

    private func setupUI() {
        guard let pickupPoint = self.myLocation else { return }//TODO: show alert
        typeLabel.text = pickupPoint.type
        addressLabel.text = pickupPoint.geo.address
        stateSwitch.isOn = pickupPoint.state.isActive
    }

    @IBAction func didSwitch(_ sender: UISwitch) {
        if sender.isOn {
            setState.send(MyLocation.State.active)
        } else {
            setState.send(MyLocation.State.unActive)
        }
    } 
    @IBAction func didTapNavigateButton(_ sender: UIButton) {
        guard stateSwitch.isOn, let location = myLocation else { return }
        navigate = Just(location)
//        navigate.send(pickupPoint)
    }
}
