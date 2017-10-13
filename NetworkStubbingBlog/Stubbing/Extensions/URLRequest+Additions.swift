import Foundation

extension URLRequest {
    func sanitizedFileName() -> String? {
        guard let url = url else { return nil }
        let sanitized = url.absoluteString.replacingOccurrences(of: "/", with: "_")
        let prefixedHTTPMethod = httpMethod ?? ""
        return prefixedHTTPMethod + sanitized
    }
}
