import Foundation

struct SkateResponse: Decodable {
    enum CodingKeysL1: String, CodingKey {
        case features
    }

    enum CodingKeysL2: String, CodingKey {
        case attributes
    }

    let skateLocations: [SkateLocation]

    init(from decoder: Decoder) throws {
        let containerL1 = try decoder.container(keyedBy: CodingKeysL1.self)
        var containerL2 = try containerL1.nestedUnkeyedContainer(forKey: .features)

        var locations = [SkateLocation]()

        while containerL2.isAtEnd == false {
            let attributes = try containerL2.nestedContainer(keyedBy: CodingKeysL2.self)
            let location = try attributes.decode(SkateLocation.self, forKey: .attributes)
            locations.append(location)
        }

        self.skateLocations = locations
    }
}

public struct SkateLocation: Decodable {

    enum CodingKeys: String, CodingKey {
        case locationID = "locationid"
        case location = "location"
    }


    public let name: String
    public let locationID: Int

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.locationID = try container.decode(Int.self, forKey: .locationID)
        self.name = try container
            .decodeIfPresent(String.self, forKey: .location)?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? "Unknown"
    }
}

extension Array where Element == SkateLocation {
    func customDebugString() {
        for location in self {
            print("\(location.name)")
        }
    }
}
