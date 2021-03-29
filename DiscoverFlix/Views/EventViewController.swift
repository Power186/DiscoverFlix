//
//  EventViewController.swift
//  DiscoverFlix
//
//  Created by Scott on 3/28/21.
//

import SwiftUI
import EventKitUI

struct EventView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var movieTitle: String
    @Binding var movieUrlString: String
    @Binding var movieVoteAverage: Double
    
    class Coordniator: NSObject,
                       EKEventViewDelegate,
                       UINavigationControllerDelegate,
                       EKEventEditViewDelegate {
        
        func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
            controller.dismiss(animated: true, completion: nil)
        }

        func eventViewController(_ controller: EKEventViewController, didCompleteWith action: EKEventViewAction) {
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        let parent: EventView
        
        init(_ parent: EventView) {
            self.parent = parent
        }
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let store = EKEventStore()
//        let eventController = EKEventViewController()
//        let navController = UINavigationController(rootViewController: eventController)
        
        let eventEditVC = EKEventEditViewController()
        
        store.requestAccess(to: .event, completion: { success, error in
            if success, error == nil {
                DispatchQueue.main.async {
                    let newEvent = EKEvent(eventStore: store)
                    newEvent.title = movieTitle
                    newEvent.startDate = Date()
                    newEvent.endDate = Date()
                    
                    guard let movieUrl = URL(string: movieUrlString) else { return }
                    newEvent.url = movieUrl
                    newEvent.notes = "\(movieTitle) has a \(movieVoteAverage) / 10 average rating."
                    
                    eventEditVC.eventStore = store
                    eventEditVC.event = newEvent
                    eventEditVC.editViewDelegate = context.coordinator
                    
//                    eventController.delegate = context.coordinator
//                    eventController.event = newEvent
                    
                }
            }
        })
        return eventEditVC
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
    
    func makeCoordinator() -> Coordniator {
        Coordniator(self)
    }
    
}
