import Foundation

struct ARCGISEndpoint {
    var path: String
    var queryItems: [URLQueryItem] = []
}

extension ARCGISEndpoint {
    static var swimLocations: Self {
        ARCGISEndpoint(path: "V_Swim_Locations_2022/FeatureServer/0/query",
                       queryItems: [
                           URLQueryItem(name: "f", value: "json"),
                           URLQueryItem(name: "where", value: "Show_On_Map = 'Yes'"),
                           URLQueryItem(name: "returnGeometry", value: "true"),
                           URLQueryItem(name: "spatialRel", value: "esriSpatialRelIntersects"),
                           URLQueryItem(name: "outFields", value: "*"),
                           URLQueryItem(name: "outSR", value: "102100"),
                           URLQueryItem(name: "resultOffset", value: "0"),
                           URLQueryItem(name: "resultRecordCount", value: "5000")
                       ])
    }

    static var skateLocations: Self {
        ARCGISEndpoint(path: "Skate_Locations_v2/FeatureServer/0/query",
                       queryItems: [
                           URLQueryItem(name: "f", value: "json"),
                           URLQueryItem(name: "where", value: "Show_On_Map = 'Yes'"),
                           URLQueryItem(name: "returnGeometry", value: "true"),
                           URLQueryItem(name: "spatialRel", value: "esriSpatialRelIntersects"),
                           URLQueryItem(name: "outFields", value: "*"),
                           URLQueryItem(name: "outSR", value: "102100"),
                           URLQueryItem(name: "resultOffset", value: "0"),
                           URLQueryItem(name: "resultRecordCount", value: "5000")
                       ])
    }

    private static var headers: [String: String] {
        ["User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:109.0) Gecko/20100101 Firefox/113.0",
         "Accept": "*/*",
         "Accept-Language": "en-GB,en;q=0.5",
         "Accept-Encoding": "gzip, deflate, br",
         "Origin": "https://www.toronto.ca",
         "Connection": "keep-alive",
         "Referer": "https://www.toronto.ca/",
         "Sec-Fetch-Dest": "empty",
         "Sec-Fetch-Mode": "cors",
         "Sec-Fetch-Site": "cross-site",
         "Pragma": "no-cache",
         "Cache-Control": "no-cache",
         "Te": "trailers"]
    }
}

extension ARCGISEndpoint {
    var request: URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "services3.arcgis.com"
        components.path = "/b9WvedVPoizGfvfD/arcgis/rest/services/" + path
        components.queryItems = queryItems

        guard let url = components.url else {
            preconditionFailure(
                "Invalid URL components: \(components)"
            )
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ARCGISEndpoint.headers

        return request
    }
}

extension URLSession {
    func data(for endpoint: ARCGISEndpoint) async throws -> Data {
        Logger.network.debug("Sending request to \(endpoint.request.url!)")
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

import OSLog

extension Logger {
    static var network: Self {
        Logger(subsystem: "network", category: "network")
    }
}
