import Foundation

// MARK: - TASK 2
class CampusPlace {
    let name: String
    init(name: String) { self.name = name } ///shared property is: name
    
    /// method subclases can customize: visitMessage()
    func visitMessage() -> String {
        "Visiting \(name)"
    }
}

// MARK: - TASK 3
class Classroom: CampusPlace {
    override func visitMessage() -> String {
        "Attend a lesson at \(name)"
    }
}

class Library: CampusPlace {
    override func visitMessage() -> String {
        "Read books at \(name)"
    }
}

class Laboratory: CampusPlace {
    override func visitMessage() -> String {
        "Conduct an experiment at \(name)"
    }
}

    // YOUR TURN
class Cafeteria: CampusPlace {
    override func visitMessage() -> String {
        "Enjoy a meal at \(name)"
    }
}

class SportsHall: CampusPlace {
    override func visitMessage() -> String {
        "Play sports at \(name)"
    }
}
