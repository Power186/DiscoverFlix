//
//  MessageViewController.swift
//  DiscoverFlix
//
//  Created by Scott on 3/30/21.
//

import SwiftUI
import MessageUI

struct MessageView: UIViewControllerRepresentable {
    @ObservedObject var userSettings = UserDefaultsController()
    @Binding var phoneNumber: String
    
    class Coordinator: NSObject,
                       MFMessageComposeViewControllerDelegate,
                       UINavigationControllerDelegate {
        
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            controller.dismiss(animated: true, completion: nil)
        }
        
        let parent: MessageView
        
        init(_ parent: MessageView) {
            self.parent = parent
        }
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = MFMessageComposeViewController()
        
        guard MFMessageComposeViewController.canSendText(),
              MFMessageComposeViewController.canSendAttachments() else {
            print("SMS Services not available")
            return UIViewController()
        }
        controller.messageComposeDelegate = context.coordinator
        controller.recipients = [phoneNumber]
        controller.subject = "Let's watch \(userSettings.movieTitle)"
        controller.body = "\(userSettings.movieTitle) has a rating of \(userSettings.movieVoteAverage) / 10."
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
}
