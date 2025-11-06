import UIKit

struct Subservice {
    var name: String
    var rate: Double
    var unit: String
    var image: UIImage?

    init(name: String, rate: Double, unit: String, image: UIImage? = nil) {
        self.name = name
        self.rate = rate
        self.unit = unit
        self.image = image
    }
}
