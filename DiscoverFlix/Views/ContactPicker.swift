//
//  ContactPicker.swift
//  DiscoverFlix
//
//  Created by Scott on 3/26/21.
//

import ContactsUI
import SwiftUI

struct ContactPicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
//    @Binding var persons: [Person]
    
    @Environment(\.managedObjectContext) var moc
    
    final class Coordinator: NSObject,
                             CNContactPickerDelegate,
                             UINavigationControllerDelegate {
        
        let parent: ContactPicker
        
        init(_ parent: ContactPicker) {
            self.parent = parent
        }
        
        func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
            let name = "\(contact.givenName) \(contact.familyName)"
            let identifier = contact.identifier
            let emails = contact.emailAddresses
            let phoneNumbers = contact.phoneNumbers
            
            var emailAddresses: [CNLabeledValue<NSString>] {
                var result = [CNLabeledValue<NSString>]()
                for email in emails {
                    result.append(email)
                }
                return result
            }
            
            var emailAddress: String {
                var result = ""
                for address in emailAddresses {
                    result = address.value as String
                }
                return result
            }
            
            var cnPhoneNumbers: [CNLabeledValue<CNPhoneNumber>] {
                var result = [CNLabeledValue<CNPhoneNumber>]()
                for number in phoneNumbers {
                    result.append(number)
                }
                return result
            }
            
            var phoneNumber: String {
                var result = ""
                for number in cnPhoneNumbers {
                    result = number.value.stringValue
                }
                return result
            }
            
            let buddy = Buddy(context: parent.moc)
            buddy.name = name
            buddy.id = identifier
            buddy.email = emailAddress
            buddy.phone = phoneNumber
            PersistenceController.shared.save()
            
//            let model = Person(name: name, id: identifier, source: contact, email: emails, phoneNumber: phoneNumbers)
//            self.parent.persons.append(model)
            parent.presentationMode.wrappedValue.dismiss()
        }
        
    }
    
    func makeUIViewController(context: Context) -> some UINavigationController {
        let navController = UINavigationController()
        let vc = CNContactPickerViewController()
        
        vc.delegate = context.coordinator
        navController.isNavigationBarHidden = true
        navController.present(vc, animated: true, completion: nil)
        return navController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
}
