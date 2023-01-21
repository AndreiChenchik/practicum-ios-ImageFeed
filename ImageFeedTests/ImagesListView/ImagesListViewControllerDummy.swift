@testable import ImageFeed
import UIKit

final class ImagesListViewControllerDummy: UIViewController, ImagesListViewControllerProtocol {
    var tableView: UITableView = .init()
    func setProgress(_ isOn: Bool) {}
}
