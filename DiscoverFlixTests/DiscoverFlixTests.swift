//
//  DiscoverFlixTests.swift
//  DiscoverFlixTests
//
//  Created by Scott on 3/29/21.
//

import XCTest
import CoreData

@testable import DiscoverFlix
class BaseTestCase: XCTestCase {

    var dataController: PersistenceController!
    var managedObjectContext: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        dataController = PersistenceController(inMemory: true)
        managedObjectContext = dataController.container.viewContext
    }

}
