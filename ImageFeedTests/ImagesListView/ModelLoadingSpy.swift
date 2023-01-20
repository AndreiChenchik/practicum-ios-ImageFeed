@testable import ImageFeed
import Foundation

final class ModelLoadingSpy {
    let photosJson = """
        [
          {
            "id": "Cy5dya5MAlI",
            "created_at": "2022-08-31T14:36:55Z",
            "width": 3120,
            "height": 4160,
            "description": null,
            "urls": {
              "full": "https://images.unsplash.com",
              "small": "https://images.unsplash.com"
            },
            "liked_by_user": false
          }
        ]
        """

    var isFetchCalled = false
    var authHeader: String?
    var urlCalled: URL?
}

extension ModelLoadingSpy: ModelLoading {
    func fetch<Model: Decodable>(
        request: URLRequest,
        handler: @escaping (Result<Model, Error>) -> Void
    ) -> URLSessionTask {
        authHeader = request.allHTTPHeaderFields?["Authorization"]
        isFetchCalled = true
        urlCalled = request.url

        let data = photosJson.data(using: .utf8)!
        let model = try? JSONDecoder().decode(Model.self, from: data)

        if let model {
            handler(.success(model))
        }

        return URLSession.shared.dataTask(with: .init(url: .init(string: "https://ya.ru")!))
    }
}
