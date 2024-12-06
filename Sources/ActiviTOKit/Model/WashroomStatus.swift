import Foundation

struct WashroomResponse: Decodable {
    let assets: [WashroomStatus]
}

/// A model to represent a washroom status
public struct WashroomStatus: Decodable {

    private enum CodingKeys: String, CodingKey {
        case locationID = "LocationID"
        case assetID = "AssetID"
        case postedDate = "PostedDate"
        case assetName = "AssetName"
        case reason = "Reason"
        case comments = "Comments"
        case status = "Status"
    }

    /// A location ID
    public let locationID: Int
    public let assetID: Int
    public let postedDate: String
    public let assetName: String
    public let reason: String?
    public let comments: String?
    public let status: Int

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.locationID = try container.decode(Int.self, forKey: .locationID)
        self.assetID = try container.decode(Int.self, forKey: .assetID)
        self.postedDate = try container.decode(String.self, forKey: .postedDate)
        self.assetName = try container.decode(String.self, forKey: .assetName)
        self.reason = try container.decodeIfPresent(String.self, forKey: .reason)
        self.comments = try container.decodeIfPresent(String.self, forKey: .comments)
        self.status = try container.decode(Int.self, forKey: .status)
    }
}
