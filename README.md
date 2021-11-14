
# requirements: 
- make pod install to get all dependencies

## Architecture
This app is implemented with **Clean Architecture** and **MVVM**; including *Swinject* for dependency injection,  *RxSwift* and *Observables* for databindings.
The main purpose of using clean archtiecture is not to have dependencies from inner layers to outers layers (Dependency inversion Protocol of the SOLID principles). Such separation eases the project scalability/maintability as well as the test process.
MVVM is used for the presentation layer.

## Layers

**Domain layer**
(Business logic): This layer is totatlly isolated from the other layers. it contains *Entities* (Models) and *Use cases*. 
A use case defines "input ports" and "output ports" to invert dependencies. It organizes the flow of data to and from entities. Its role may be not clear enough in this app since we are not handling multiple data and use cases, but I tried to implement a scalable and maintainable app architecture.

**Data layer**:
This layer contains *Repositories* and one or many data sources. The repository is responsible for coordinating data from remote or local data sources (remote server or persistent database for example).

**Presentation layer (MVVM)**
This layer contains all UI related classes. *Views* are coordinated by *ViewModels* which execute one or many use cases.

## Networking
*Alamofire* is used for networking implementation.

## Exercises list
In this feature, the exercises list is fetched from the server and then displayed on the screen.
A *stateNotifier* is used to notify the view when data is received. When "StateNotifier" receives a new event, the view's state is set to "done" and the loader is hidden and the collections is reloading data.

I used a collectionView cell to show the exercise main image and name. 
I used OperationQueu to fetch exercise image tasks with *maxConcurrentOperationCount* equals to 2. I used custom class *AsyncOperation* as asynchrounis wrapper to class *Operation* to get notified when operation has finished.

## Exercise details
In this feature, I fetshed the exercises Info. I populate the first section with images from the server response, and use OperationQueu again to fetch variations ,with the same max of operation count concurrent to always minmize CPU and mermory consumption, and populate the second section.
In case of no images and variations are exist, I display label with note "Exercise with no images nor variations".

## Variations details
In this feature, I used the same viewController of the last feature *ExercisesViewController* because we impliment the same logic/display.

## Base view controller
I user this object to handle  the view state (error views and loader (show / hide) )
