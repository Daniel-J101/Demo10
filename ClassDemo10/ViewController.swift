//
//  ViewController.swift
//  ClassDemo10
//
//  Created by Joe Miller on 7/22/22.
//

import UIKit
import EventKit

class ViewController: UIViewController {
    @IBOutlet weak var eventLabel: UILabel!
    
    var savedEventId:String = ""
    var eventStore = EKEventStore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func addEventSelected(_ sender: Any) {
        let startDate = NSDate()
        let endDate = startDate.addingTimeInterval(60*60)
        if EKEventStore.authorizationStatus(for: .event) != .authorized {
            eventStore.requestAccess(to: .event) {
                (granted, error) in
                self.createEvent(title: "Polish my bowling trophies", startDate: startDate, endDate: endDate)
            }
        } else {
            self.createEvent(title: "Polish my bowling trophies", startDate: startDate, endDate: endDate)
        }
    }
    
    @IBAction func removeEventSelected(_ sender: Any) {
        if(EKEventStore.authorizationStatus(for: .event) != .authorized) {
            eventStore.requestAccess(to: .event) {
                (granted, error) in
                self.deleteEvent(eventIdentifier: self.savedEventId)
            }
        } else {
            self.deleteEvent(eventIdentifier: self.savedEventId)
        }
        
    }
    
    
    func deleteEvent(eventIdentifier:String) {
        let eventToRemove = eventStore.event(withIdentifier: eventIdentifier)
        if (eventToRemove != nil) {
            do {
                try eventStore.remove(eventToRemove!, span: .thisEvent)
                eventLabel.text = "Event removed from calender"
            } catch {
                print("Error removing event from calender")
            }
        }
    }
    
    func createEvent(title:String, startDate:NSDate, endDate:NSDate) {
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.startDate = startDate as Date
        event.endDate = endDate as Date
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        do {
            try eventStore.save(event, span: .thisEvent)
            savedEventId = event.eventIdentifier
            eventLabel.text = "Event added to calender"
        } catch {
            print("Error adding to calender")
        }
    }
}

