//
//  AddressesViewController.swift
//  GettMobileDelivery
//
//  Created by Tal talspektor on 06/05/2021.
//

import UIKit
import Combine

class LocationsViewController: UIViewController {

    @IBOutlet weak var locationsTableView: UITableView!

    private var viewModel = LocationViewModel()
    private var cancelables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default
            .publisher(for: Notification.Name.finishTask)
            .compactMap { $0 }
            .filter { $0.object is MyLocation }
            .map { $0.object as! MyLocation }
            .sink { [weak self] location in
                self?.viewModel.updateState(by: location, state: .unActive)
            }.store(in: &cancelables)
        fetchData()
        registerCell()
        getViewModelUpdates()
    }

    private func getViewModelUpdates() {
        viewModel.update
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
            self?.locationsTableView.reloadData()
        }.store(in: &cancelables)
    }

    private func fetchData() {
        viewModel.fetchData()
    }

    private func registerCell() {
        locationsTableView.register(LocationTableViewCell.nib,
                                    forCellReuseIdentifier: LocationTableViewCell.cellIdentifier)
    }
}

extension LocationsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.cellIdentifier,
                                                       for: indexPath) as? LocationTableViewCell else { return UITableViewCell() }
        let isEnable = indexPath.row == 0 || viewModel.dataModel[indexPath.row - 1].state == .unActive

        cell.config(with: viewModel.dataModel[indexPath.row], isEnable: isEnable)

        cell.setState.sink { state in
            self.viewModel.updateState(by: indexPath.row, state: state)
            tableView.reloadData()
        }.store(in: &cancelables)
        let _ = cell.navigate?.subscribe(on: RunLoop.main).map { [weak self] location in
            guard let self = self else { return }
            guard  let viewController = self.storyboard?.instantiateViewController(identifier: "mapVieController") as? MapViewController else { return }
            viewController.configur(with: MapViewModel(with: self.viewModel.dataModel[indexPath.row]))
            guard self.navigationController?.presentationController != viewController else { return }
            self.navigationController?.pushViewController(viewController, animated: true)
        }
//        cell.navigate.sink { [weak self] location in
//            guard let self = self else { return }
//            guard  let viewController = self.storyboard?.instantiateViewController(identifier: "mapVieController") as? MapViewController else { return }
//            viewController.configur(with: MapViewModel(with: self.viewModel.dataModel[indexPath.row]))
//            guard self.navigationController?.presentationController != viewController else { return }
//            self.navigationController?.pushViewController(viewController, animated: true)
//        }.store(in: &cancelables)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
}


