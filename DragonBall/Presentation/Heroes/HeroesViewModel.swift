//
//  HeroesViewModel.swift
//  DragonBall
//
//  Created by Pablo Márquez Marín on 16/10/23.
//

import CoreData
import UIKit

class HeroesViewModel: HeroesViewControllerDelegate {

    // MARK: - Dependencies -
    private let apiProvider: ApiProviderProtocol
    private let secureDataProvider: SecureDataProviderProtocol
    private let coreDataProvider: CoreDataProvider
    
    // MARK: - Properties -
    var viewState: ((HeroesViewState) -> Void)?
    var heroesCount: Int {
        heroes.count
    }
    private var heroes: Heroes = []
    
    // MARK: - Initializers -
    init(apiProvider: ApiProviderProtocol, 
         secureDataProvider: SecureDataProviderProtocol,
         coreDataProvider: CoreDataProvider
    ) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
        self.coreDataProvider = coreDataProvider
    }
    
    // MARK: - Public functions -
    func onViewappear() {
        viewState?(.loading(true))
        
        DispatchQueue.global().async {
            defer { self.viewState?(.loading(false)) }
            guard let token = self.secureDataProvider.get() else { return }
            
            if self.heroes.isEmpty {
                self.apiProvider.getHeroes(by: nil,
                                           token: token) { heroes in
                    self.coreDataProvider.createHeroes(heroes: heroes)
                    self.heroes = self.coreDataProvider.loadHeroes()
                    self.viewState?(.updateData)
                }
            } else {
                self.viewState?(.updateData)
            }
            }
        }
    
    func heroBy(index: Int)  -> Hero? {
        if index >= 0 && index < heroesCount {
            heroes[index]
        } else {
            nil
        }
    }

    func heroDetailViewModel(index: Int) -> HeroesDetailViewControllerDelegate?  {
        guard let selectedHero = heroBy(index: index) else { return nil }
    
        return HeroDetailViewModel(
            hero: selectedHero,
            apiProvider: apiProvider,
            secureDataProvider: secureDataProvider
        )
    }
    
    func splashViewModel() -> SplashViewControllerDelegate? {
        return SplashViewModel(secureDataProvider: secureDataProvider, apiProvider: apiProvider, coreDataProvider: coreDataProvider)
    }
    
    func logout() {
        secureDataProvider.delete()
        coreDataProvider.countHeroes()
        coreDataProvider.deleteHeroes()
        DispatchQueue.main.async {
            self.viewState?(.logoutAndExit)
        }
    }
}
