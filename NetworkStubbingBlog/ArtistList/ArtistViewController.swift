import UIKit

class ArtistViewController: UIViewController {

    fileprivate var artists: [Artist] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let service = ArtistService()
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchArtists()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseID")
    }
    
    private func fetchArtists() {
        service.fetchArtists(forRequest: artistRequest) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let artists):
                strongSelf.artists = artists
            case .failure(_):
                print("error")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = sender as! IndexPath
        guard let detailsViewController = segue.destination as? ArtistDetailViewController else { return }
        let artist = artists[indexPath.row]
        detailsViewController.artist = artist
    }
}

extension ArtistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: indexPath)
    }
}

extension ArtistViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseID", for: indexPath)
        let model = artists[indexPath.row]
        cell.textLabel?.text = model.artistName
        return cell
    }
}

