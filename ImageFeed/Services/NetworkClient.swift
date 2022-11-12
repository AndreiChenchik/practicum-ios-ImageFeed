import Foundation

protocol NetworkRouting {
    @discardableResult func fetch(
        url: URL, handler: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask

    @discardableResult func fetch(
        request: URLRequest, handler: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask
}

struct NetworkClient: NetworkRouting {
    private let urlSession: URLSession

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    private enum NetworkError: Error {
        case codeError
    }

    @discardableResult func fetch(
        url: URL, handler: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let request = URLRequest(url: url)
        return fetch(request: request, handler: handler)
    }

    @discardableResult func fetch(
        request: URLRequest, handler: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let task = urlSession.dataTask(
            with: request
        ) { data, response, error in
            if let error = error {
                handler(.failure(error))
                return
            }

            if let response = response as? HTTPURLResponse,
                response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return
            }

            guard let data = data else { return }
            handler(.success(data))
        }

        task.resume()

        return task
    }
}
