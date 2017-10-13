import Foundation

struct Artist: Decodable {
    let artistName: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.singleValueContainer()
        let rawValue = try values.decode(String.self)
        artistName = rawValue
    }
}

struct ArtistDetails: Decodable {
    let favouriteArtist: Artist
    let favouriteTrack: String

    enum CodingKeys: String, CodingKey {
        case favouriteArtist = "favourite_artist"
        case favouriteTrack = "favourite_track"
    }
}
