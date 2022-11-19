import Foundation

protocol ObjectLoading {
    @discardableResult func fetch<Object: Decodable>(
        url: URL,
        bearerToken: String?,
        handler: @escaping (Result<Object, Error>) -> Void
    ) -> URLSessionTask

    @discardableResult func fetch<Object: Decodable>(
        request: URLRequest,
        handler: @escaping (Result<Object, Error>) -> Void
    ) -> URLSessionTask
}

extension ObjectLoading {
    @discardableResult func fetch<Object: Decodable>(
        url: URL,
        handler: @escaping (Result<Object, Error>) -> Void
    ) -> URLSessionTask {
        fetch(url: url, bearerToken: nil, handler: handler)
    }
}

struct ObjectService: ObjectLoading {
    private let networkClient: NetworkRouting

    init(
        networkClient: NetworkRouting
    ) {
        self.networkClient = networkClient
    }

    func fetch<Object: Decodable>(
        url: URL,
        bearerToken: String?,
        handler: @escaping (Result<Object, Error>) -> Void
    ) -> URLSessionTask {

        var request = URLRequest(url: url)
        if let bearerToken {
            request.setValue(
                "Bearer \(bearerToken)",
                forHTTPHeaderField: "Authorization"
            )
        }

        return fetch(request: request, handler: handler)
    }

    func fetch<Object: Decodable>(
        request: URLRequest,
        handler: @escaping (Result<Object, Error>) -> Void
    ) -> URLSessionTask {
        return networkClient.fetch(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let object = try decoder.decode(Object.self, from: data)

                    handler(.success(object))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
