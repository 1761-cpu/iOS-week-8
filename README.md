# Practice 2: Inventory Management System

A small console program for a phone/tablet store to manage its **warehouse** (not sales). Every device gets its own QR code. When a device is sold, we scan the QR and its status changes. Nothing is ever deleted, so we keep the full history.

## What the program does

- Keeps a list of manufacturers (Apple, Samsung, Xiaomi).
- Keeps product versions (series, release year, color, storage, specs).
- Imports products in **batches** (each batch has a quantity and a date).
- Creates one QR code for every single device.
- Scan QR to **sell** or to report **defective**.
- Each item has a status: `In Stock`, `Sold`, `Defective`.
- Prints an inventory report and the import history.

## Classes

| Class / Type | Purpose |
|---|---|
| `ItemStatus` (enum) | The 3 statuses of an item |
| `Manufacturer` | Brand info (id, name) |
| `Product` | Base class: one specific version of a series (e.g. iPhone 15 Pro, Titanium, 256GB) |
| `Phone`, `Tablet` | Subclasses of `Product` with their own extra info |
| `ImportBatch` | One import record (batch id, product, quantity, date) |
| `InventoryItem` | One real device with its own QR code and status |
| `InventoryManager` | Main logic: import, sell, report defective, check, report |

## Where each OOP concept is used

| OOP concept | Where | Explanation |
|---|---|---|
| **Inheritance** | `Phone` and `Tablet` inherit from `Product` | They reuse `id`, `seriesName`, `color`, `storage`, etc. and only add what is different (`simSlots` for phone, `screenSize` for tablet). |
| **Polymorphism** | `getDetails(manufacturerName:)` | `Phone` and `Tablet` override this method. In `InventoryManager` we call `item.product.getDetails(...)` on a `Product` and Swift runs the correct version (Phone or Tablet) automatically. |
| **Encapsulation** | `InventoryItem.status` is `private(set)` | Outside code can read the status but cannot change it directly. It can only change through `markAsSold()` or `markAsDefective()`, which check the rules first (only an In Stock item can be sold or marked defective). |
| **Encapsulation** | `InventoryManager.inventory`, `batches`, `manufacturers` are `private` | Other code cannot edit the data directly. It must use methods like `importBatch` or `scanAndSell`. |
| **Abstraction** | `InventoryManager` | The user only calls simple methods like `scanAndSell(qrCode:)`. They do not need to know the data is stored in a dictionary. |
| **Composition** | `InventoryItem` has a `Product`, `ImportBatch` has a `Product` | Objects are built from other objects ("has-a" relationship). |

## Rules from the requirements

- **One QR per item:** `importBatch` creates `quantity` items and each one gets `UUID().uuidString` as its QR.
- **No deleting:** items stay in the dictionary forever. Only `status` changes. The report shows total items, so history is kept.
- **QR and stock must match:** if a QR exists and its status is `In Stock`, the device is in the warehouse. If it is `Sold` or `Defective`, it is not available. `scanAndSell` and `reportDefective` reject items that are not `In Stock`, so an item cannot be sold twice.
- **Batch info:** each `ImportBatch` saves the quantity and the date. Each item stores its `batchID`.

## QR code: generate at run time

I chose to **generate the QR payload at run time**.

- The QR only contains the ID string (the UUID). It does not contain product info or status.
- Product info and status are always looked up from the system using that ID, so they are always up to date.
- If we saved image files, we would have to manage lots of files, and they could easily get out of sync with the database. 
- In this CLI implementation, the "QR Code" is simply the unique UUID string printed to the console, which can be copied and pasted into the scanner menu.

Menu options:

```
1. Scan QR to sell
2. Scan QR to report defective
3. Check a QR
4. Inventory report
5. Import history
0. Exit
```

## Example test

1. Run the program and copy the iPhone QR code.
   
   <img width="577" height="787" alt="Screenshot 2026-11-21 at 12 19 10" src="https://github.com/user-attachments/assets/53048098-2499-4477-9c99-f4959fa31f1e" />

2. Choose `1` and paste it: the item is sold.
   
   <img width="390" height="214" alt="Screenshot 2026-11-21 at 12 20 11" src="https://github.com/user-attachments/assets/42774eaa-6fda-4600-8923-b98509bf6526" />

3. Choose `1` and paste it again: error, the item is already sold.
   
   <img width="387" height="214" alt="Screenshot 2026-11-21 at 12 20 55" src="https://github.com/user-attachments/assets/6f5310f8-cc37-474a-b44e-efeccd381069" />

4. Choose `3` and paste it: status shows `Sold`.
   
   <img width="573" height="245" alt="Screenshot 2026-11-21 at 12 21 37" src="https://github.com/user-attachments/assets/4877449f-2df0-4abe-bd20-571124e3df9d" />

5. Choose `4`: the report shows 1 sold and the rest in stock.
    
    <img width="572" height="463" alt="Screenshot 2026-11-21 at 12 22 15" src="https://github.com/user-attachments/assets/c339cdb4-8d9b-4161-8140-c149f3698602" />


## Notes

- `Product` is one **version** of a series (series + color + storage). A different color or storage is a different `Product`.
