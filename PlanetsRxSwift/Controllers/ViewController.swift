//
//  ViewController.swift
//  PlanetsRxSwift
//
//  Created by Nalinda Wickramarathna on 11/14/21.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var viewModel = PlanetViewModel()
    private var bag = DisposeBag()
    var selectedPlanet: Planet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindTableData()
    }

    func bindTableData() {
        viewModel.items.bind(to: tableView.rx.items(cellIdentifier: Constants.planetCell,
                                                    cellType: PlanetCell.self)) { row, planet, cell in
            cell.lblPlanetName.text = planet.name
            cell.lblClimate.text = "\(UIConstants.climateIs) \(planet.climate)"
        }.disposed(by: bag)
        
        tableView.rx.modelSelected(Planet.self).bind { (planet) in
            print("Product Tapped: \(planet.name)")
            self.selectedPlanet = planet
            self.performSegue(withIdentifier: Constants.planetDetailsSegue, sender: nil)
        }.disposed(by: bag)
        
        viewModel.getPlanets()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.planetDetailsSegue {
            if let destinationVC = segue.destination as? PlanetDetailsViewController {
                destinationVC.planet = self.selectedPlanet
            }
        }
    }
}

