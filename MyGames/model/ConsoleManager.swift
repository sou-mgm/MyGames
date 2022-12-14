//
//  ConsoleManager.swift
//  MyGames
//
//  Created by Matheus Matias on 22/11/22.
//

import CoreData

class ConsolesManager{
    
    static let shared = ConsolesManager()
    var consoles: [Console] = []
   
    
    func loadConsoles(with context: NSManagedObjectContext){
        let fetchRequest: NSFetchRequest<Console> = Console.fetchRequest()
        let sortDescritor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescritor]
        do{
            consoles = try context.fetch(fetchRequest)
            print(consoles)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func deleteConsole (index: Int, context: NSManagedObjectContext){
        let console = consoles[index]
        context.delete(console)
        do{
            try context.save()
            consoles.remove(at: index) 
        } catch {
            print(error.localizedDescription)
        }
        
      
    }
    
    
    private init(){
        
    }
}
