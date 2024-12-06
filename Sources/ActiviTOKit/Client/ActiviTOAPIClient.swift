import Foundation

/// Main class for interacting with the API
public class ActiviTOAPIClient {

    private let urlSession: URLSession
    private let decoder: JSONDecoder

    public init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
        self.decoder = JSONDecoder()
    }

    /// Retrieve statuses of washrooms
    public func washroomStatus() async throws -> [WashroomStatus] {
        let data = try await urlSession.data(for: .washroomStatus)
        let decoded = try decoder.decode(WashroomResponse.self, from: data)
        return decoded.assets
    }

    ///
    /// Retrieve the information on what's available at a specific location
    ///
    /// - Parameter locationID: The ID of the location to query
    /// - Returns: An array of facilities available at a given location
    ///
    public func facilities(locationID: Int) async throws -> [Facility] {
        let data = try await urlSession.data(for: .facilities(locationID: locationID))
        let decoded = try decoder.decode([Facility].self, from: data)
        return decoded
    }
}

// MARK: - Swimming

extension ActiviTOAPIClient {
    ///
    /// Retrieves a list of swimming locations
    ///
    /// - Returns: An array of swimming locations
    public func swimLocations() async throws -> [SwimLocation] {
        let data = try await urlSession.data(for: .swimLocations)
        let decoded = try decoder.decode(SwimResponse.self, from: data)
        return decoded.swimLocations
    }

    public func swimmingSchedule(for locationID: Int) async throws -> Data {
        let data = try await urlSession.data(for: .swimmingSchedule(for: locationID))
//        let decoded = String(data: data, encoding: .utf16)!
        return data
    }
}

// MARK: - Skating

extension ActiviTOAPIClient {
    ///
    /// Retrieves a list of skating locations
    ///
    /// - Returns: An array of skating locations
    public func skateLocations() async throws -> [SkateLocation] {
        let data = try await urlSession.data(for: .skateLocations)
        let decoded = try decoder.decode(SkateResponse.self, from: data)
        return decoded.skateLocations
    }
}
