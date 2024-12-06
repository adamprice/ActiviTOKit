import Foundation

struct SwimResponse: Decodable {
    enum CodingKeysL1: String, CodingKey {
        case features
    }

    enum CodingKeysL2: String, CodingKey {
        case attributes
    }

    let swimLocations: [SwimLocation]

    init(from decoder: Decoder) throws {
        let containerL1 = try decoder.container(keyedBy: CodingKeysL1.self)
        var containerL2 = try containerL1.nestedUnkeyedContainer(forKey: .features)

        var locations = [SwimLocation]()

        while containerL2.isAtEnd == false {
            let attributes = try containerL2.nestedContainer(keyedBy: CodingKeysL2.self)
            let location = try attributes.decode(SwimLocation.self, forKey: .attributes)
            locations.append(location)
        }

        self.swimLocations = locations
    }
}

public struct SwimLocation: Decodable {

    enum CodingKeys: String, CodingKey {
        case locationID = "locationid"
        case complexName = "complexname"
    }

    public let name: String
    public let locationID: Int

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.locationID = try container.decode(Int.self, forKey: .locationID)
        self.name = try container
            .decodeIfPresent(String.self, forKey: .complexName)?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? "Unknown"
    }
}

extension Array where Element == SwimLocation {
    func customDebugString() {
        for location in self {
            print("\(location.name)")
        }
    }
}
