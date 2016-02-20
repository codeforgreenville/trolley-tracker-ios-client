//
//  ScheduleViewController+SortByDay.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 10/25/15.
//  Copyright © 2015 Code For Greenville. All rights reserved.
//

import UIKit

extension ScheduleViewController {
    
    func itemsForSchedulesByDay(schedules: [RouteSchedule]) -> [ScheduleSection] {
        
        // Create a dictionary of all the days we might show
        var days = [Day : [Route]]()
        for day in Day.allDays {
            days[day] = [Route]()
        }
        
        // Create a list of all Routes and add them to the days dictionary
        for schedule in schedules {
            // Get the route name
            let routeName = schedule.name
            
            for time in schedule.times {
                guard let newDay = Day(rawValue: time.day) else { continue }
                days[newDay]?.append(Route(name: routeName, time: time.time))
            }
        }
        
        // Group the routes into GroupedRoute objects
        var flattenedDays = [Day : [GroupedRoute]]()
        for day in Day.allDays {
            flattenedDays[day] = [GroupedRoute]()
        }
        
        for (day, routes) in days {
            for route in routes {
                // Check to see if we have already handled this route
                if let matching = flattenedDays[day]?.filter({ $0.name == route.name }) where matching.count > 0 { continue }
                
                // Find all matching routes
                let matchingRoutes = routes.filter { $0.name == route.name }
                
                // Convert them into an array of strings
                let times = matchingRoutes.map { $0.time }
                
                // Create a GroupedRoute object
                flattenedDays[day]?.append(GroupedRoute(name: route.name, times: times))
            }
        }
        
        
        // Create Schedule Display items
        
        var scheduleSections = [ScheduleSection]()
        
        for day in Day.sortedDays {
            
            // Don't display days with no routes
            guard let routes = flattenedDays[day] where routes.count > 0 else { continue }
            
            var scheduleItems = [ScheduleItem]()
            
            for route in routes {
                var scheduleTimes = [String]()
                for time in route.times {
                    scheduleTimes.append(time)
                }
                scheduleItems.append(ScheduleItem(title: route.name, times: scheduleTimes))
            }
            scheduleSections.append(ScheduleSection(title: day.rawValue, items: scheduleItems))
        }
        
        return scheduleSections
    }
}

private enum Day: String {
    case Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
    
    static var allDays: [Day] {
        get { return [.Monday, .Tuesday, .Wednesday, .Thursday, .Friday, .Saturday, .Sunday] }
    }
    
    static var sortedDays: [Day] {
        get { return Day.allDays }
    }
}

private struct GroupedRoute {
    private let name: String
    private var times: [String]
}

private struct Route: Hashable {
    private let name: String
    private let time: String
    var hashValue: Int { get { return name.hashValue } }
}

private func ==(lhs: Route, rhs: Route) -> Bool {
    return lhs.name == rhs.name
}