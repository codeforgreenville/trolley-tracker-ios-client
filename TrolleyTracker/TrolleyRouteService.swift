//
//  TrolleyStopService.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 6/16/15.
//  Copyright (c) 2015 Code For Greenville. All rights reserved.
//

import Foundation
import CoreLocation

private struct CacheItem<T> {
    let timestamp: Date
    let payload: T

    func isNewerThan(_ minutes: Int) -> Bool {
        let allowedSeconds = TimeInterval(minutes * 60)
        return timestamp.timeIntervalSinceNow > -allowedSeconds
    }
}

class TrolleyRouteServiceLive: TrolleyRouteService {

    private let queue: OperationQueue = OperationQueue()
    
    fileprivate var memoryCachedActiveRoutes: CacheItem<[TrolleyRoute]>?
    fileprivate var memoryCachedRoutes = [Int : TrolleyRoute]()

    func loadTrolleyRoutes(_ completion: @escaping LoadTrolleyRouteCompletion) {

        // TODO: Check if time has crossed quarter-hour threshhold
        if let cachedRoutes = memoryCachedActiveRoutes,
            cachedRoutes.isNewerThan(15) {
            DispatchQueue.main.async {
                completion(cachedRoutes.payload)
            }
            return
        }

        let op = FetchActiveRouteIDsOperation()
        op.completionBlock = { [weak op] in
            guard let ids = op?.fetchedRouteIDs else {
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }
            self.fetchActiveRouteIDsFromNetwork(ids, completion: completion)
        }
        queue.addOperation(op)
    }
    
    func loadTrolleyRoute(_ routeID: Int, completion: @escaping LoadTrolleyRouteCompletion) {
        if let route = memoryCachedRoutes[routeID] { completion([route]); return }

        let op = FetchRouteDetailOperation(routeIDs: [routeID])
        op.completionBlock = { [weak op] in

            guard let fetchedRoute = op?.fetchedRoutes.first else {
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }

            self.memoryCachedRoutes[routeID] = fetchedRoute
            DispatchQueue.main.async {
                completion([fetchedRoute])
            }
        }
        queue.addOperation(op)
    }

    private func fetchActiveRouteIDsFromNetwork(_ routeIDs: [Int],
                                                completion: @escaping LoadTrolleyRouteCompletion) {

        let op = FetchRouteDetailOperation(routeIDs: routeIDs)
        op.completionBlock = { [weak op] in

            guard let fetchedRoutes = op?.fetchedRoutes else { completion([]); return }

            self.memoryCachedActiveRoutes = CacheItem(timestamp: Date(), payload: fetchedRoutes)
            completion(fetchedRoutes)
        }
        queue.addOperation(op)
    }
}
