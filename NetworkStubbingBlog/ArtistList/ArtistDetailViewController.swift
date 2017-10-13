import UIKit

final class ArtistDetailViewController: UIViewController {

    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var favouriteArtistLabel: UILabel!
    @IBOutlet weak var favouriteTrackLabel: UILabel!
    
    var artist: Artist?
    
    private let service = ArtistService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchArtistDetails()
    }
    
    private func fetchArtistDetails() {
        service.fetchArtistDetails(forRequest: artistDetailsRequest) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let artistDetails):
                strongSelf.updateUI(with: artistDetails)
            case .failure(_):
                print("error")
            }
        }
    }
    
    private func updateUI(with artistDetails: ArtistDetails) {
        guard let artist = artist else { return }
        artistNameLabel.text = artist.artistName
        favouriteArtistLabel.text = "Favourite artist: " + artistDetails.favouriteArtist.artistName
        favouriteTrackLabel.text = "Favourite track: " + artistDetails.favouriteTrack
    }

}
