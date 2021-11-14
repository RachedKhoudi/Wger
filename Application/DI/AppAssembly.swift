//
//  AppAssembly.swift
//  Wger
//
//  Created by Rached Khoudi on 13/11/2021.
//

import Swinject

final class AppAssembly: Assembly {
    func assemble(container: Container) {
        container.register(DataStoreManagerProtocol.self) { r in
            DataStoreManager()
        }.inObjectScope(.container)
        
        container.register(NetworkingManagerProtocol.self) { resolver in
            NetworkingManager()
        }.inObjectScope(.container)
        
        container.register(ExercisesRepositoryProtocol.self) { resolver in
            ExercisesRepository(networkManager: resolver.resolve(NetworkingManagerProtocol.self)!)
        }.inObjectScope(.container)
        
        container.register(ExercisesUseCaseProtocol.self) { resolver in
            ExercisesUseCase(exercisesRepository: resolver.resolve(ExercisesRepositoryProtocol.self)!)
        }
        
        container.register(ExercisesViewModelProtocol.self) { resolver in
            ExercisesViewModel(exercisesUseCase: resolver.resolve(ExercisesUseCaseProtocol.self)!)
        }
    }
}

