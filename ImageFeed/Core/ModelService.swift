import Foundation

struct ModelService: ModelLoading {
    private let networkClient: NetworkRouting

    init(
        networkClient: NetworkRouting
    ) {
        self.networkClient = networkClient
    }

    func fetch<Model: Decodable>(
        request: URLRequest,
        handler: @escaping (Result<Model, Error>) -> Void
    ) -> URLSessionTask {
        return networkClient.fetch(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(Model.self, from: data)

                    handler(.success(model))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
