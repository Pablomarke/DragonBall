//
//  CoreDataProvider.swift
//  DragonBall
//
//  Created by Pablo Márquez Marín on 23/10/23.
//

import Foundation
import CoreData

class CoreDataProvider {
    private var moc: NSManagedObjectContext? {
        (
            CoreDataStack.shared.persistentContainer.viewContext
        )
    }
    
    func createHeroes(heroes: Heroes) {
        guard let moc,
                let entityHero = NSEntityDescription.entity(
                    forEntityName: HeroDAO.entityName,
                    in: moc
                ) else { return }
        for hero in heroes {
            let heroDAO = HeroDAO(entity: entityHero, insertInto: moc)
            heroDAO.setValue(hero.name, forKey:  "name")
            heroDAO.setValue(hero.description, forKey: "heroDescription")
            heroDAO.setValue(hero.photo, forKey: "photo" )
            heroDAO.setValue(hero.id, forKey: "id")
            heroDAO.setValue(hero.isFavorite, forKey: "favorite")
            try? moc.save()
        }
    }
    
    func loadHeroes() -> Heroes {
        let fetchHero = NSFetchRequest<HeroDAO>(entityName: "HeroDAO")
        guard let moc,
              let myHeros = try? moc.fetch(fetchHero)
                 else { return [] }
        var heroesSaved: Heroes = []
        
        for hero in myHeros {
            let myNewHero = hero.toModel()!
            heroesSaved.append(myNewHero)
        }
        return heroesSaved
    }
    
    func countHeroes() -> Int {
        let fetchHero = NSFetchRequest<HeroDAO>(entityName: "HeroDAO")
        guard let moc,
        let myHeroes = try? moc.fetch(fetchHero)
        else {
            return 0
        }
        print("Heroes en base de datos: \(myHeroes.count )")
        return myHeroes.count
    }
    
    func deleteHeroes() {
        let fetchHero = NSFetchRequest<HeroDAO>(entityName: "HeroDAO")
        guard let moc,
              let myHeroes = try? moc.fetch(fetchHero)
        else {
            return
        }
        myHeroes.forEach { moc.delete($0)}
        try? moc.save()
        print("Heroes en base de datos despues del borrado: \(myHeroes.count )")
    }
    
    func getAllIds() -> [String] {
        let fetchHero = NSFetchRequest<HeroDAO>(entityName: "HeroDAO")
        guard let moc,
              let myHeros = try? moc.fetch(fetchHero)
                 else { return [] }
        var heroesIds: [String] = []
        
        for hero in myHeros {
            let myHeroId = hero.id ?? ""
            heroesIds.append(myHeroId)
        }
        return heroesIds
    }
    
    func createLocations(locations: HeroLocations) {
        guard let moc,
                let entityHero = NSEntityDescription.entity(
                    forEntityName: LocationDAO.entityName,
                    in: moc
                ) else { return }
        for location in locations {
            let locationDAO = LocationDAO(entity: entityHero, insertInto: moc)
            locationDAO.setValue(location.id, forKey: "id")
            locationDAO.setValue(location.date , forKey: "date")
            locationDAO.setValue(location.latitude , forKey: "latitude")
            locationDAO.setValue(location.longitude , forKey: "longitude")
           //locationDAO.setValue(location.hero , forKey: "hero")
            try? moc.save()
        }
    }
    
    func loadLocations() -> HeroLocations {
        let fetchLocation = NSFetchRequest<LocationDAO>(entityName: "LocationDAO")
        guard let moc,
              let myLocations = try? moc.fetch(fetchLocation)
                 else { return [] }
        var locationsSaved: HeroLocations = []
        
        for location in myLocations {
            let newLocation = location.toModel()
            locationsSaved.append(newLocation!)
        }
        return locationsSaved
    }
}
