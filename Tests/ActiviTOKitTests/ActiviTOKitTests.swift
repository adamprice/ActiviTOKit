import Foundation
import Testing
@testable import ActiviTOKit

extension Tag {
  @Tag static var washroom: Self
}

struct ActiviTOKitTests {

    let client: ActiviTOAPIClient

    init() {
        self.client = ActiviTOAPIClient()
    }

    @Test("Washroom Status", .tags(.washroom))
    func testWashroomStatus() async throws {

//        let json =
//        """
//        {
//          "districts": null,
//          "assets": [
//            {
//              "LocationID": 306,
//              "AssetID": 29751,
//              "PostedDate": "2024-06-11 09:13:57",
//              "AssetName": "Withrow Park North Washroom",
//              "SeasonStart": null,
//              "SeasonEnd": null,
//              "Reason": "Maintenance/Repairs",
//              "Comments": null,
//              "Status": 0
//            }
//          ]
//        }
//        """

        let washroomStatus = try await client.washroomStatus()
        print(washroomStatus)
    }

    @Test
    func testFacility() async throws {
        let facilities = try await client.facilities(locationID: 70)
        print(facilities)
    }

    @Test
    func testSwimLocations() async throws {
        let swimLocations = try await client.swimLocations()
        swimLocations.customDebugString()
    }

    @Test
    func testSwimLocationSchedule() async throws {
        let swimSchedule = try await client.swimmingSchedule(for: 2012)
        print(swimSchedule.prettyJSON ?? "")
    }

    @Test
    func testSkateLocations() async throws {
        let skateLocations = try await client.skateLocations()
        skateLocations.customDebugString()
    }
}

extension Data {
    var prettyJSON: String? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString as String
    }
}
