import Foundation

final class ImagesListService {
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
        if index + 1 == photos.count && task == nil {
            print("let's load")
            fetchPhotosNextPage()
        }
    }
}

extension ImagesListService {
    private func fetchPhotosNextPage() {
        let photosURL = nextPhotosURL()
        print(photosURL.absoluteString)

        task = modelService.fetch(
            url: photosURL,
            bearerToken: bearer
        ) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }

            switch result {
            case let .success(photoResults):
                let photos = photoResults.map { photoResult in
                    Photo(
                        id: photoResult.id,
                        description: photoResult.description,
                        thumbnailImage: photoResult.urls.small,
                        largeImage: photoResult.urls.full,
                        size: .init(
                            width: photoResult.width,
                            height: photoResult.height
                        ),
                        createdAt: self.dateFormatter.date(from: photoResult.createdAt) ?? Date(),
                        isLiked: photoResult.likedByUser
                    )
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
