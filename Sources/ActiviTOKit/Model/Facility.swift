import Foundation

public struct Facility: Decodable {

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case rate = "Rate"
        case permit = "Permit"
    }

    public let name: String
    public let rate: String?
    public let permit: Permit?

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.rate = try container.decodeIfPresent(String.self, forKey: .rate)
        self.permit = try? container.decodeIfPresent(Permit.self, forKey: .permit)
    }
}

public enum Permit: String, Decodable {
    case ice
    case sport
    case room
}
