final class ImagesListService {
    private (set) var photos: [Photo] = []

    private var imagesPerPage = 10

    private var lastLoadedPage: Int {
        photos.count / imagesPerPage
    }

    func fetchPhotosNextPage() {
        print("kill me please")
    }
}
