//
//  ScheduleViewController+SortByRoute.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 10/25/15.
//  Copyright © 2015 Code For Greenville. All rights reserved.
//

import UIKit

extension ScheduleViewController {
 
    func itemsForSchedulesSortedByRoute(schedules: [RouteSchedule]) -> [ScheduleSection] {
        
        var groupedSchedules = [GroupedRouteSchedule]()
        
        for schedule in schedules {
            
            var groupedTimes = [GroupedRouteTime]()
            
            for time in schedule.times {
                // Check to see if we have handled this day
                if groupedTimes.filter({ $0.day == time.day }).count > 0 { continue }
                
                // Find all matching times
                let matchingTimes = schedule.times.filter { $0.day == time.day }
                
                // Convert them to an array of strings
                let timeStrings = matchingTimes.map { $0.time }
                
                // Create a GroupedRouteTime object
                groupedTimes.append(GroupedRouteTime(day: time.day, times: timeStrings))
            }
            
            groupedSchedules.append(GroupedRouteSchedule(routeName: schedule.name, groupedTimes: groupedTimes))
        }
        
        
        var scheduleSections = [ScheduleSection]()
        
        for groupedSchedule in groupedSchedules {
            
            var scheduleItems = [ScheduleItem]()
            
            for groupedRouteTime in groupedSchedule.groupedTimes {
                var scheduleTimes = [String]()
                for time in groupedRouteTime.times {
                    scheduleTimes.append(time)
                }
                scheduleItems.append(ScheduleItem(title: groupedRouteTime.day, times: scheduleTimes))
            }
            scheduleSections.append(ScheduleSection(title: groupedSchedule.routeName, items: scheduleItems))
        }
        
        return scheduleSections
    }
}

private struct GroupedRouteSchedule {
    let routeName: String
    var groupedTimes: [GroupedRouteTime]
}

private struct GroupedRouteTime {
    let day: String
    var times: [String]
}