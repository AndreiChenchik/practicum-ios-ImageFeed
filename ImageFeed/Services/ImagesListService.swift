import Foundation

protocol ImagesListLoading {

}

final class ImagesListService: ImagesListLoading {
    let didChangeNotification = Notification.Name(
        rawValue: "ImagesListServiceDidChange"
    )

    private let modelService: ModelLoading
    private let notificationCenter: NotificationCenter
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()

        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        return formatter
    }()

    private (set) var photos: [Photo] = [] {
        didSet {
            notificationCenter.post(
                name: didChangeNotification,
                object: self
            )
        }
    }

    private var task: URLSessionTask?
    private var bearer: String?
    private var imagesPerPage = 10

    init(
        notificationCenter: NotificationCenter,
        modelService: ModelLoading
    ) {
        self.notificationCenter = notificationCenter
        self.modelService = modelService
    }

    func authorize(with bearer: String) {
        self.bearer = bearer
        fetchPhotosNextPage()
    }

    func prepareForDisplay(index: Int) {
        guard index + 1 == photos.count,
              task == nil
        else {
            return
        }

        fetchPhotosNextPage()
    }
}

// MARK: - Photos Loading

extension ImagesListService {
    private func fetchPhotosNextPage() {
        let photosURL = nextPhotosURL()

        task = modelService.fetch(
            url: photosURL,
            bearerToken: bearer
        ) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }

            switch result {
            case let .success(photoResults):
                let photos = photoResults.map {
                    $0.convertToViewModel(formatter: self.dateFormatter)
                }

                DispatchQueue.main.async { [weak self] in
                    self?.photos += photos
                }
            case let .failure(error):
                print(error.localizedDescription)
            }

            self.task = nil
        }
    }

    private var lastLoadedPage: Int {
        photos.count / imagesPerPage
    }

    private func nextPhotosURL() -> URL {
        var url = URL.unsplashBaseURL
        url.appendPathComponent("/photos")

        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)

        urlComponents?.queryItems = [
            .init(name: "page", value: "\(lastLoadedPage + 1)"),
            .init(name: "per_page", value: "\(imagesPerPage)")
        ]

        guard let photosURL = urlComponents?.url else {
            fatalError("Can't build photos URL")
        }

        return photosURL
    }
}

private extension PhotoResult {
    func convertToViewModel(formatter: DateFormatter) -> Photo {
        Photo(
            id: self.id,
            description: self.description,
            thumbnailImage: self.urls.small,
            largeImage: self.urls.full,
            size: .init(
                width: self.width,
                height: self.height
            ),
            createdAt: formatter.date(from: self.createdAt) ?? Date(),
            isLiked: self.likedByUser
        )
    }
}

// MARK: - Likes

extension ImagesListService {
    func changeLike(index: Int, isLiked: Bool, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let bearer else { return }

        let photo = photos[index]

        var url = URL.unsplashBaseURL
        url.appendPathComponent("/photos/\(photo.id)/like")

        var request = URLRequest(url: url)
        request.httpMethod = isLiked ? "POST" : "DELETE"

        request.setValue(
            "Bearer \(bearer)",
            forHTTPHeaderField: "Authorization"
        )

        modelService.fetch(request: request) { [weak self] (result: Result<LikeResult, Error>) in
            let likeResult: Result<Bool, Error>

            defer {
                DispatchQueue.main.async { [weak self] in
                    if case .success = likeResult {
                        self?.photos[index].isLiked = isLiked
                    }
                    completion(likeResult)
                }
            }

            switch result {
            case .success:
                likeResult = .success(isLiked)
            case let .failure(error):
                likeResult = .failure(error)
            }
        }
    }
}
