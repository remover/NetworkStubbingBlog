import Foundation

class ArtistService {
    
    let client = ClientFactory.makeClient()
    
    func fetchArtists(forRequest request: URLRequest, completion: @escaping (Result<[Artist]>) -> Void) {
        
        client.makeRequest(request) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let data):
                let result = strongSelf.parseArtistResponse(data)
                DispatchQueue.main.async {
                    completion(result)
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func fetchArtistDetails(forRequest request: URLRequest, completion: @escaping (Result<ArtistDetails>) -> Void) {
        
        client.makeRequest(request) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let data):
                let result = strongSelf.parseArtistDetailsResponse(data)
                DispatchQueue.main.async {
                    completion(result)
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }

}

private extension ArtistService {
    func parseArtistResponse(_ data: Data) -> Result<[Artist]> {
        let decoder = JSONDecoder()
        guard let artist = try? decoder.decode([Artist].self, from: data) else {
            fatalError("Could not parse JSON")
        }
        return .success(artist)
    }
    
    func parseArtistDetailsResponse(_ data: Data) -> Result<ArtistDetails> {
        let decoder = JSONDecoder()
        guard let artistDetails = try? decoder.decode(ArtistDetails.self, from: data) else {
            fatalError("Could not parse JSON")
        }
        return .success(artistDetails)
    }

}

let artistRequest = URLRequest(url: URL(string: "https://untheological-adver.000webhostapp.com/artists_list.json")!)
let artistDetailsRequest = URLRequest(url: URL(string: "https://untheological-adver.000webhostapp.com/detail.json")!)
