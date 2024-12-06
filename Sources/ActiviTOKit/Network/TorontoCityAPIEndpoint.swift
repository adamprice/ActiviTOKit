import Foundation

struct TorontoCityAPIEndpoint {
    var path: String
    var queryItems: [URLQueryItem] = []
}

extension TorontoCityAPIEndpoint {
    static var washroomStatus: Self {
        TorontoCityAPIEndpoint(path: "washroom")
    }

    static func facilities(locationID: Int) -> Self {
        TorontoCityAPIEndpoint(path: "facilities/\(locationID)")
    }

    static func swimmingSchedule(for locationID: Int) -> Self {
        TorontoCityAPIEndpoint(path: "dropin/swim/\(locationID)")
    }
}

extension TorontoCityAPIEndpoint {
    var request: URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.toronto.ca"
        components.path = "/data/parks/live/" + path + ".json"
        components.queryItems = queryItems
        components.queryItems?.append(URLQueryItem(name: "_", value: "\(Date().millisecondsSince1970)"))

        guard let url = components.url else {
            preconditionFailure(
                "Invalid URL components: \(components)"
            )
        }

        return URLRequest(url: url)
    }
}

extension URLSession {
    func data(for endpoint: TorontoCityAPIEndpoint) async throws -> Data {
        let (data, response) = try await data(for: endpoint.request)
        guard
            let response = response as? HTTPURLResponse,
            response.statusCode == 200
        else {
            throw ActiviTOError.httpError
        }

        return data
    }
}

extension Date {
    var millisecondsSince1970: Int {
        Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
}
