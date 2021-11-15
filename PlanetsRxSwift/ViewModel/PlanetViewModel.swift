//
//  PlanetViewModel.swift
//  PlanetsRxSwift
//
//  Created by Nalinda Wickramarathna on 11/14/21.
//

import Foundation
import RxSwift

struct PlanetViewModel {
    
    var items = PublishSubject<[Planet]>()
    private var bag = DisposeBag()
    
    func getPlanets() {
        NetworkService.getPlanets().subscribe { planets in
            print("Planets: \(planets)")
            items.onNext(planets)
        } onError: { error in
            print("Error: \(error.localizedDescription)")
        } onCompleted: {
            print("Completed")
        } onDisposed: {
            print("Disposed")
        }.disposed(by: bag)
    }
    
}
