import Foundation

// STATUS & MANUFACTURER
enum ItemStatus: String {
    case inStock = "In Stock"
    case sold = "Sold"
    case defective = "Defective"
}

class Manufacturer {
    let id: Int
    let name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

// PRODUCT BASE CLASS & SUBCLASSES
class Product {
    let id: String
    let manufacturerID: Int
    let seriesName: String
    let releaseYear: Int
    let color: String
    let storage: String
    let specs: String
    
    init(id: String, manufacturerID: Int, seriesName: String, releaseYear: Int, color: String, storage: String, specs: String) {
        self.id = id
        self.manufacturerID = manufacturerID
        self.seriesName = seriesName
        self.releaseYear = releaseYear
        self.color = color
        self.storage = storage
        self.specs = specs
    }
    
    func getDetails(manufacturerName: String) -> String {
        return "[\(manufacturerName)] \(seriesName) (\(releaseYear)) - \(color), \(storage) | Specs: \(specs)"
    }
}

class Phone: Product {
    override func getDetails(manufacturerName: String) -> String {
        return "[Phone] " + super.getDetails(manufacturerName: manufacturerName)
    }
}

class Tablet: Product {
    override func getDetails(manufacturerName: String) -> String {
        return "[Tablet] " + super.getDetails(manufacturerName: manufacturerName)
    }
}

// ENCAPSULATION
class InventoryItem {
    let qrCode: String
    let product: Product
    let importDate: Date
    private(set) var status: ItemStatus
    
    init(product: Product) {
        self.qrCode = UUID().uuidString
        self.product = product
        self.importDate = Date()
        self.status = .inStock
    }
    
    func markAsSold() -> Bool {
        guard status == .inStock else {
            print("Error: Cannot sell. Item is currently \(status.rawValue).")
            return false
        }
        status = .sold
        return true
    }
    
    func markAsDefective() -> Bool {
        guard status == .inStock else {
            print("Error: Cannot report defective. Item is currently \(status.rawValue).")
            return false
        }
        status = .defective
        return true
    }
}

// INVENTORY MANAGER
class InventoryManager {
    private var inventory: [String: InventoryItem] = [:]
    
    private let manufacturers: [Int: Manufacturer] = [
        1: Manufacturer(id: 1, name: "Apple"),
        2: Manufacturer(id: 2, name: "Samsung"),
        3: Manufacturer(id: 3, name: "Xiaomi")
    ]
    
    @discardableResult
    func importBatch(product: Product, quantity: Int) -> [String] {
        print("\n--- IMPORTING BATCH: \(quantity) units of \(product.seriesName) ---")
        var generatedQRCodes: [String] = []
        
        for _ in 0..<quantity {
            let newItem = InventoryItem(product: product)
            inventory[newItem.qrCode] = newItem
            generatedQRCodes.append(newItem.qrCode) // Lưu lại mã QR để trả về
        }
        print("Import successful. Total items in system: \(inventory.count)")
        return generatedQRCodes
    }
    
    func scanAndSell(qrCode: String) {
        guard let item = inventory[qrCode] else {
            print("Error: QR Code not found in the system.")
            return
        }
        
        if item.markAsSold() {
            print("Success: Item sold successfully. Removed from active stock.")
        }
    }
    
    func printInventoryReport() {
        print("\n=============================================")
        print("           CURRENT INVENTORY REPORT          ")
        print("=============================================")
        
        var stockCount = 0
        var soldCount = 0
        var defectiveCount = 0
        
        for (_, item) in inventory {
            switch item.status {
            case .inStock:
                stockCount += 1
                let manuName = manufacturers[item.product.manufacturerID]?.name ?? "Unknown"
                let details = item.product.getDetails(manufacturerName: manuName)
                print("[IN STOCK] QR: \(item.qrCode.prefix(8))... | \(details)")
            case .sold:
                soldCount += 1
            case .defective:
                defectiveCount += 1
            }
        }
        
        print("\n--- SUMMARY ---")
        print("Total Items in System : \(inventory.count) (History is preserved)")
        print("Items In Stock        : \(stockCount)")
        print("Items Sold            : \(soldCount)")
        print("Items Defective       : \(defectiveCount)")
        print("=============================================\n")
    }
}

// DEMO & SCANNER SIMULATION
print("STARTING INVENTORY SYSTEM...")
let manager = InventoryManager()

let iphone15 = Phone(id: "iP15", manufacturerID: 1, seriesName: "iPhone 15 Pro", releaseYear: 2023, color: "Titanium", storage: "256GB", specs: "A17 Pro")
let galaxyS24 = Phone(id: "SS24", manufacturerID: 2, seriesName: "Galaxy S24 Ultra", releaseYear: 2024, color: "Black", storage: "512GB", specs: "Snapdragon 8 Gen 3")
let ipadPro = Tablet(id: "iPdM4", manufacturerID: 1, seriesName: "iPad Pro M4", releaseYear: 2024, color: "Silver", storage: "1TB", specs: "M4 Chip")

let iphoneQRCodes = manager.importBatch(product: iphone15, quantity: 2)
manager.importBatch(product: galaxyS24, quantity: 1)
manager.importBatch(product: ipadPro, quantity: 1)

var sampleQRCode = ""
if let firstIphoneQR = iphoneQRCodes.first {
    sampleQRCode = firstIphoneQR
}

print("\n--- QR CODE SCANNER SIMULATION ---")
print("To test, copy the sample QR code below paste it into the next step:")
print("Sample QR code: \(sampleQRCode)")
print("------------------------------------")

var isRunning = true
while isRunning {
    print("\nEnter QR code to sell (or type 'exit' to quit):")
    
    if let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) {
        
        if input.lowercased() == "exit" {
            isRunning = false
            print("Exiting program...")
            break
        } else {
            manager.scanAndSell(qrCode: input)
        }
    }
}
