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

// PRODUCT (base class) + Phone / Tablet (subclasses)
class Product {
    let id: String
    let manufacturerID: Int
    let seriesName: String
    let releaseYear: Int
    let color: String
    let storage: String
    let specs: String

    init(id: String, manufacturerID: Int, seriesName: String,
         releaseYear: Int, color: String, storage: String, specs: String) {
        self.id = id
        self.manufacturerID = manufacturerID
        self.seriesName = seriesName
        self.releaseYear = releaseYear
        self.color = color
        self.storage = storage
        self.specs = specs
    }

    // Subclasses override this method (polymorphism)
    func getDetails(manufacturerName: String) -> String {
        return "[\(manufacturerName)] \(seriesName) (\(releaseYear)) - \(color), \(storage) | Specs: \(specs)"
    }
}

class Phone: Product {
    let simSlots: Int

    init(id: String, manufacturerID: Int, seriesName: String,
         releaseYear: Int, color: String, storage: String, specs: String,
         simSlots: Int) {
        self.simSlots = simSlots
        super.init(id: id, manufacturerID: manufacturerID, seriesName: seriesName,
                   releaseYear: releaseYear, color: color, storage: storage, specs: specs)
    }

    override func getDetails(manufacturerName: String) -> String {
        return "[Phone] " + super.getDetails(manufacturerName: manufacturerName)
            + " | SIM slots: \(simSlots)"
    }
}

class Tablet: Product {
    let screenSize: Double // inches

    init(id: String, manufacturerID: Int, seriesName: String,
         releaseYear: Int, color: String, storage: String, specs: String,
         screenSize: Double) {
        self.screenSize = screenSize
        super.init(id: id, manufacturerID: manufacturerID, seriesName: seriesName,
                   releaseYear: releaseYear, color: color, storage: storage, specs: specs)
    }

    override func getDetails(manufacturerName: String) -> String {
        return "[Tablet] " + super.getDetails(manufacturerName: manufacturerName)
            + " | Screen: \(screenSize) inch"
    }
}

// IMPORT BATCH (one record per import)
struct ImportBatch {
    let batchID: Int
    let product: Product
    let quantity: Int
    let importDate: Date
}

// INVENTORY ITEM
class InventoryItem {
    let qrCode: String
    let product: Product
    let batchID: Int
    let importDate: Date
    private(set) var status: ItemStatus

    init(product: Product, batchID: Int) {
        self.qrCode = UUID().uuidString
        self.product = product
        self.batchID = batchID
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
    private var batches: [ImportBatch] = []
    private var nextBatchID = 1

    private let manufacturers: [Int: Manufacturer] = [
        1: Manufacturer(id: 1, name: "Apple"),
        2: Manufacturer(id: 2, name: "Samsung"),
        3: Manufacturer(id: 3, name: "Xiaomi")
    ]

    private func manufacturerName(for product: Product) -> String {
        return manufacturers[product.manufacturerID]?.name ?? "Unknown"
    }

    // Import a batch: create one InventoryItem (with its own QR) per unit
    @discardableResult
    func importBatch(product: Product, quantity: Int) -> [String] {
        guard quantity > 0 else {
            print("Error: Quantity must be greater than 0.")
            return []
        }
        guard manufacturers[product.manufacturerID] != nil else {
            print("rror: Manufacturer ID \(product.manufacturerID) does not exist.")
            return []
        }

        let batch = ImportBatch(batchID: nextBatchID, product: product,
                                quantity: quantity, importDate: Date())
        nextBatchID += 1
        batches.append(batch)

        print("\n--- IMPORT BATCH #\(batch.batchID): \(quantity) x \(product.seriesName) ---")
        var qrCodes: [String] = []
        for _ in 0..<quantity {
            let item = InventoryItem(product: product, batchID: batch.batchID)
            inventory[item.qrCode] = item
            qrCodes.append(item.qrCode)
        }
        print("Import successful. Total items in system: \(inventory.count)")
        return qrCodes
    }

    // Scan QR -> sell
    func scanAndSell(qrCode: String) {
        guard let item = inventory[qrCode] else {
            print("Error: QR code not found in the system.")
            return
        }
        if item.markAsSold() {
            print("Success: Item sold. It is no longer in stock.")
        }
    }

    // Scan QR -> report defective
    func reportDefective(qrCode: String) {
        guard let item = inventory[qrCode] else {
            print("Error: QR code not found in the system.")
            return
        }
        if item.markAsDefective() {
            print("Success: Item marked as defective.")
        }
    }

    // Scan QR -> check status and info
    func checkQR(qrCode: String) {
        guard let item = inventory[qrCode] else {
            print("QR not found in the system.")
            return
        }
        let details = item.product.getDetails(manufacturerName: manufacturerName(for: item.product))
        print("Status: \(item.status.rawValue) | Batch #\(item.batchID)")
        print(details)
    }

    func printBatchHistory() {
        print("\n--- IMPORT HISTORY ---")
        if batches.isEmpty {
            print("No batches yet.")
        }
        for b in batches {
            print("Batch #\(b.batchID): \(b.quantity) x \(b.product.seriesName) (\(b.importDate))")
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
                let details = item.product.getDetails(manufacturerName: manufacturerName(for: item.product))
                print("[IN STOCK] QR: \(item.qrCode.prefix(8))... | \(details)")
            case .sold:
                soldCount += 1
            case .defective:
                defectiveCount += 1
            }
        }

        print("\n--- SUMMARY ---")
        print("Total items in system : \(inventory.count) (history is kept)")
        print("In stock              : \(stockCount)")
        print("Sold                  : \(soldCount)")
        print("Defective             : \(defectiveCount)")
        print("=============================================\n")
    }
}

// DEMO & CLI MENU
print("STARTING INVENTORY SYSTEM...")
let manager = InventoryManager()

let iphone15 = Phone(id: "iP15", manufacturerID: 1, seriesName: "iPhone 15 Pro",
                     releaseYear: 2023, color: "Titanium", storage: "256GB",
                     specs: "A17 Pro", simSlots: 1)
let galaxyS24 = Phone(id: "SS24", manufacturerID: 2, seriesName: "Galaxy S24 Ultra",
                      releaseYear: 2024, color: "Black", storage: "512GB",
                      specs: "Snapdragon 8 Gen 3", simSlots: 2)
let ipadPro = Tablet(id: "iPdM4", manufacturerID: 1, seriesName: "iPad Pro M4",
                     releaseYear: 2024, color: "Silver", storage: "1TB",
                     specs: "M4 Chip", screenSize: 13.0)

let iphoneQRs = manager.importBatch(product: iphone15, quantity: 2)
let galaxyQRs = manager.importBatch(product: galaxyS24, quantity: 1)
let ipadQRs = manager.importBatch(product: ipadPro, quantity: 1)

manager.printInventoryReport()

print("--- SAMPLE QR CODES (copy and paste them into the menu) ---")
print("iPhone 15 Pro : \(iphoneQRs.first ?? "-")")
print("Galaxy S24    : \(galaxyQRs.first ?? "-")")
print("iPad Pro M4   : \(ipadQRs.first ?? "-")")

// Menu CLI
var isRunning = true
while isRunning {
    print("""

    ===== MENU =====
    1. Scan QR to sell
    2. Scan QR to report defective
    3. Check a QR
    4. Inventory report
    5. Import history
    0. Exit
    Choose: 
    """, terminator: "")

    guard let choice = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) else { break }

    switch choice {
    case "1", "2", "3":
        print("Enter QR code:")
        let qr = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if choice == "1" {
            manager.scanAndSell(qrCode: qr)
        } else if choice == "2" {
            manager.reportDefective(qrCode: qr)
        } else {
            manager.checkQR(qrCode: qr)
        }
    case "4":
        manager.printInventoryReport()
    case "5":
        manager.printBatchHistory()
    case "0":
        print("Exiting program...")
        isRunning = false
    default:
        print("Invalid choice.")
    }
}
