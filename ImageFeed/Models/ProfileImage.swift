struct ProfileImage: Codable, Equatable {
    let small: String?
    let medium: String?
    let large: String?

    var best: String? { large ?? medium ?? small }
}
