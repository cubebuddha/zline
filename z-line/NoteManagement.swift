//
//  NoteManagement.swift
//  z-line
//
//  Created by Aaron Markey on 1/13/17.
//  Copyright © 2017 Aaron Markey. All rights reserved.
//

import UIKit
import CoreData

func getDelegate() -> AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
}

func getContext(_ appDelegate: AppDelegate) -> NSManagedObjectContext {
    return appDelegate.persistentContainer.viewContext
}

func getNotes() -> [NSManagedObject] {
    let context = getContext(getDelegate())
    let request = NSFetchRequest<NSManagedObject>(entityName: "Note")
    let sort = NSSortDescriptor(key: "updated_at", ascending: false)
    request.sortDescriptors = [sort]
    
    do {
        let notes = try context.fetch(request)
        return notes
    } catch _ as NSError {
        print("Cannot load notes.")
        return [NSManagedObject]()
    }
}

func getLatestUpToDateNote() -> NSManagedObject {
    let context = getContext(getDelegate())
    let request = NSFetchRequest<NSManagedObject>(entityName: "Note")
    let sort = NSSortDescriptor(key: "updated_at", ascending: false)
    request.sortDescriptors = [sort]
    request.fetchLimit = 1
    
    do {
        let notes = try context.fetch(request)
        return notes[0]
    } catch _ as NSError {
        print("Cannot load latest updated first note.")
        return NSManagedObject()
    }
}

func storeNote(content: String, date: NSDate) {
    let context = getContext(getDelegate())
    let entity = NSEntityDescription.entity(forEntityName: "Note", in: context)!
    let store = NSManagedObject(entity: entity, insertInto: context)
    
    store.setValue(content, forKey: "content")
    store.setValue(date, forKey: "created_at")
    store.setValue(date, forKey: "updated_at")
    
    do {
        try context.save()
    } catch _ as NSError {
        print("Cannot save new note.")
    }
}

func updateNote(content: String, date: NSDate, note: NSManagedObject) {
    if(content.isEmpty) {
        deleteNote(note: note)
    } else {
        let context = getContext(getDelegate())
        note.setValue(content, forKey: "content")
        note.setValue(date, forKey: "updated_at")
        
        do {
            try context.save()
        } catch _ as NSError {
            print("Cannot update existing note.")
        }
    }
    
}

func deleteNote(note: NSManagedObject) {
    let delegate = getDelegate()
    let context = getContext(delegate)
    
    context.delete(note)
    delegate.saveContext()
}
