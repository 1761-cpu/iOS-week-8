# Practice Polymorphism

**Student ID:** SESEIU24001

**Full name:** Võ Châu Anh

## E1 - Class hierarchy 
Base class **CampusPlace**, five subclasses (Classroom, Library, Laboratory + my own Cafeteria and SportsHall), and the overridden method **visitMessage()**. 

```swift
class CampusPlace {
    let name: String
    init(name: String) { self.name = name }
    func visitMessage() -> String { "Visiting \(name)" }
}

class Classroom: CampusPlace {
    override func visitMessage() -> String { "Attend a lesson at \(name)" }
}

class Library: CampusPlace {
    override func visitMessage() -> String { "Read books at \(name)" }
}

class Laboratory: CampusPlace {
    override func visitMessage() -> String { "Conduct an experiment at \(name)" }
}

class Cafeteria: CampusPlace {
    override func visitMessage() -> String { "Enjoy a meal at \(name)" }
}

class SportsHall: CampusPlace {
    override func visitMessage() -> String { "Play sports at \(name)" }
}
```

**Task 2:** The shared property is **name**. The method subclasses can customize is **visitMessage()**. 

**Task 3 (my types):** Cafeteria predicted "Enjoy a meal at <name>"; SportsHall predicted "Play sports at <name>". 

## E2 - Runtime dispatch (Task 4) 
<img width="330" height="118" alt="Screenshot 2026-11-21 at 12 44 53" src="https://github.com/user-attachments/assets/48bc7a52-ad2c-4b8c-af86-e6d08e1c5e0e" />

## E3 - Provider switching (Task 5) 
<img width="370" height="133" alt="Screenshot 2026-11-21 at 12 45 43" src="https://github.com/user-attachments/assets/483da666-0e4a-4fc4-98e6-374e34ac9790" />

**How the controller selects the implementation:** The provider is chosen when the controller is created, for example `LocationController(provider: MockLocationProvider())`. The controller only stores an `any LocationProvider` and calls `currentLocation()`. To switch, we only change the object passed to the initializer. 

## E4 - Explanations 

### Task 4: The array has type [CampusPlace]. Why does each element call a different implementation? 
Because of dynamic dispatch. The array type is the superclass, but each object is a subclass. Swift picks the overridden method at runtime from the object's actual type. 

### Task 4: What happens if override is removed from Library? 
If only the keyword is removed, the code gives a compile error because Swift requires `override`. If the whole method is removed, Library uses the base method and prints "Visiting Central Library". 

### REFLECTION QUESTIONS

#### 1. Why is the call place.visitMessage() polymorphic? 
The same method name is used on many object types, and each type gives its own result. The method that runs is decided at runtime by the object's real class, not by the variable type. 

#### 2. How is method overriding different from method overloading? 
**Overriding:** a subclass replaces a superclass method with the same name and signature (uses `override`, decided at runtime). 
**Overloading:** the same method name with different parameters in the same scope (decided at compile time). 

#### 3. How does LocationController know whether it uses a mock or unavailable provider? 
It does not know and does not need to. The provider is injected through the initializer (dependency injection) and the controller only calls `currentLocation()` from the protocol. 

#### 4. What changes are needed to obtain a real device location with Core Location? 
Import CoreLocation and use `CLLocation` instead of `Coordinate`. Create a `CoreLocationProvider` with a `CLLocationManager` and a delegate. Request authorization and add `NSLocationWhenInUseUsageDescription` to Info.plist. Call `startUpdatingLocation()` and save the latest location in `didUpdateLocations`. `currentLocation()` returns the saved location, or nil if no fix has arrived yet. The controller does not change.
