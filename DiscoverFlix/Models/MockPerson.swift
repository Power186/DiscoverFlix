//
//  Person.swift
//  DiscoverFlix
//
//  Created by Scott on 3/26/21.
//

import Foundation
import Contacts

struct Person: Identifiable {
    let name: String
    let id: String
    let source: CNContact
    let email: [CNLabeledValue<NSString>]
    let phoneNumber: [CNLabeledValue<CNPhoneNumber>]
}

extension Person {
    var emailAddress: String {
        var result = ""
        for address in email {
            result = address.value as String
        }
        return result
    }
    
    var phoneNumbers: String {
        var result = ""
        for number in phoneNumber {
            result = number.value.stringValue
        }
        return result
    }
}
