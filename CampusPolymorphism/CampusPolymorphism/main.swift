import Foundation

// MARK: - TASK 4
print("=== TASK 4: RUNTIME POLYMORPHISM ===")

// Step 1
let places: [CampusPlace] = [
    Classroom(name: "Room A101"),
    Library(name: "Central Library"),
    Laboratory(name: "Physics Lab"),
    
    // YOUR TURN
    Cafeteria(name: "Green Canteen"),
    SportsHall(name: "Main Sports Hall")
]

// Step 2
for place in places {
    print(place.visitMessage())
}

// Step 3
print("\n--- Answer for task 4 ---")
print("Q: The array has type [CampusPlace]. Why does each element call a different implementation?")
print("A: Due to dynamic dispatch. Although the array type is the superclass, the actual objects are subclasses. Swift determines which overridden method to execute at runtime based on the object's actual type.")
print("\n")
print("Q: What happens if 'override' is removed from Library?")
print("A: If only the keyword 'override' is deleted, it will cause a compile-time error (Swift requires the 'override' keyword). If the entire method is deleted, Library will inherit the base class's behavior and print: 'Visiting Central Library'.\n")
print("\n")

// MARK: - TASK 5 / STEP 4
print("=== TASK 5: PROTOCOL-BASED POLYMORPHISM ===")

print("[MockLocationProvider]")
let demo = LocationController(provider: MockLocationProvider())
demo.showLocation()

print("[UnavailableLocationProvider]")
let offline = LocationController(provider: UnavailableLocationProvider())
offline.showLocation()

// YOUR TURN: Using the 3rd Provider
print("[HanoiTestLocationProvider]")
let hanoi = LocationController(provider: HanoiTestLocationProvider())
hanoi.showLocation()

// MARK: - Reflection questions
print("\n--- Reflection questions ---")
print("Q. Why is the call place.visitMessage() polymorphic?")
print("A: It uses a single interface (the method name) but behaves differently depending on the object's runtime class. The method is resolved at runtime, not at compile time.")
print("\n")
print("Q. How is method overriding different from method overloading?")
print("A: Overriding replaces a superclass method with the exact same name and signature (resolved at runtime). Overloading creates multiple methods with the same name but different parameters (resolved at compile time).")
print("\n")
print("Q. How does LocationController know whether it uses a mock or unavailable provider?")
print("A: It doesn't need to know. It relies on Dependency Injection. The specific provider is passed into the initializer, and the controller just calls currentLocation().")
print("\n")
print("Q. What changes are needed to obtain a real device location with Core Location?")
print("A: Import CoreLocation, replace Coordinate with CLLocation, use CLLocationManager, request authorization, implement CLLocationManagerDelegate for asynchronous updates, and add the NSLocationWhenInUseUsageDescription key to Info.plist.")
print("\n")
