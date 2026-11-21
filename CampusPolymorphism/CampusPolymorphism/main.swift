import Foundation

// MARK: - TASK 4: RUNTIME POLYMORPHISM
print("=== TASK 4: RUNTIME POLYMORPHISM ===")

let places: [CampusPlace] = [
    Classroom(name: "Room A101"),
    Library(name: "Central Library"),
    Laboratory(name: "Physics Lab"),
    Cafeteria(name: "Green Canteen"),     // YOUR TURN 1
    SportsHall(name: "Main Sports Hall")  // YOUR TURN 2
]

for place in places {
    print(place.visitMessage())
}

// MARK: - TASK 5: PROTOCOL-BASED POLYMORPHISM
print("\n=== TASK 5: PROTOCOL-BASED POLYMORPHISM ===")

print("[MockLocationProvider]")
let demo = LocationController(provider: MockLocationProvider())
demo.showLocation()

print("[UnavailableLocationProvider]")
let offline = LocationController(provider: UnavailableLocationProvider())
offline.showLocation()

// YOUR TURN: third provider
print("[HanoiTestLocationProvider]")
let hanoi = LocationController(provider: HanoiTestLocationProvider())
hanoi.showLocation()
