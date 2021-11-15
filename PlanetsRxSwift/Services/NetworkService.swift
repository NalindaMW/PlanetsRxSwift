//
//  NetworkService.swift
//  PlanetsRxSwift
//
//  Created by Nalinda Wickramarathna on 11/14/21.
//

import Foundation
import RxSwift

enum NetworkError: Error {
    case invalidResponse
}

class NetworkService {
    
    static let planetsURL = "https://swapi.dev/api/planets/"
    
    static func getPlanets() -> Observable<[Planet]> {
        
        return Observable.create { observer -> Disposable in
            guard let url = URL(string: planetsURL) else {
                return Disposables.create { }
            }
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else {
                    observer.onError(NetworkError.invalidResponse)
                    return
                }
                do {
                    let planets = try JSONDecoder().decode(Planets.self, from: data)
                    observer.onNext(planets.results)
                }
                catch (let error) {
                    observer.onError(error)
                }
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
