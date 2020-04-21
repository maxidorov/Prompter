//
//  CoreDataManager.swift
//  Prompter
//
//  Created by Maxim Sidorov on 21.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import CoreData

final class CoreDataManager {
    static func saveContext(_ context: NSManagedObjectContext) {
        context.performAndWait {
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
}
