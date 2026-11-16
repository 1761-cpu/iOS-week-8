import Foundation

// MARK: - TASK 5 / STEP 1
struct Coordinate {
    let latitude: Double
    let longitude: Double
}

protocol LocationProvider {
    func currentLocation() -> Coordinate?
}

//  MARK: - TASK 5 / STEP 2
class MockLocationProvider: LocationProvider {
    func currentLocation() -> Coordinate? {
        Coordinate(latitude: 10.8705, longitude: 106.8039)
    }
}

class UnavailableLocationProvider: LocationProvider {
    func currentLocation() -> Coordinate? { nil }
}

// YOUR TURN
class HanoiTestLocationProvider: LocationProvider {
    func currentLocation() -> Coordinate? {
        Coordinate(latitude: 21.0285, longitude: 105.8542)
    }
}

//  MARK: - TASK 5 / STEP 3
class LocationController {
    private let provider: any LocationProvider
    
    init(provider: any LocationProvider) {
        self.provider = provider
    }
    
    func showLocation() {
        guard let location = provider.currentLocation() else {
            print("Location unavailable")
            return
        }
        print("Lat: \(location.latitude), Lon: \(location.longitude)")
    }
}
