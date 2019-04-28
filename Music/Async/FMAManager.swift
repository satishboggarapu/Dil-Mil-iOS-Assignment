import Foundation

class FMAManager {

    private var urlHelper: URLHelper!
    private let defaults = UserDefaults.standard

    init() {
        urlHelper = URLHelper()
    }

    internal func getGenres(page: Int, completion: @escaping (_ data: GenresResponseModel?, _ error: Error?) -> Void) {
        let url = urlHelper.getGenresURLString(page)

        getJSONFromURL(urlString: url) { data, error in
            guard let data = data, error == nil else {
                return completion(nil, error)
            }

            self.defaults.set(data, forKey: "genres")

            self.createGenreObjectWith(json: data) { model, error in
                guard let model = model, error == nil else {
                    return completion(nil, error)
                }
                return completion(model, nil)
            }
        }
    }

    internal func getAlbums(genre: GenreModel, page: Int, completion: @escaping (_ data: AlbumsResponseModel?, _ error: Error?) -> Void) {
        let url = urlHelper.getAlbumsURLString(genreHandle: genre.handle, page: page)

        getJSONFromURL(urlString: url) { data, error in
            guard let data = data, error == nil else {
                return completion(nil, error)
            }

            self.defaults.set(data, forKey: "\(genre.handle)")

            self.createAlbumObjectWith(json: data) { response, error in
                guard let response = response, error == nil else {
                    return completion(nil, error)
                }
                return completion(response, nil)
            }
        }
    }

    internal func getTracks(album: AlbumModel, page: Int, completion: @escaping (_ data: TracksResponseModel?, _ error: Error?) -> Void) {
        let url = urlHelper.getTracksURLString(albumId: album.id, page: page)

        getJSONFromURL(urlString: url) { data, error in
            guard let data = data, error == nil else {
                return completion(nil, error)
            }

            self.defaults.set(data, forKey: "\(album.id)")
            
            self.createTrackObjectWith(json: data) { response, error in
                guard let response = response, error == nil else {
                    return completion(nil, error)
                }
                return completion(response, nil)
            }
        }
    }
}

extension FMAManager {
    private func getJSONFromURL(urlString: String, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        guard  let url = URL(string: urlString) else {
            return completion(nil, FMAError.failedToCreateURLFromString)
        }

        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            guard error == nil else {
                return completion(nil, error)
            }

            guard let data = data else {
                return completion(nil, error)
            }
            completion(data, nil)
        }
        task.resume()
    }
    
    private func createGenreObjectWith(json: Data, completion: @escaping (_ data: GenresResponseModel?, _ error: Error?) -> Void) {
        do {
            let genreResponse = try JSONDecoder().decode(GenresResponseModel.self, from: json)
            return completion(genreResponse, nil)
        } catch let error {
            return completion(nil, error)
        }
    }

    private func createAlbumObjectWith(json: Data, completion: @escaping (_ data: AlbumsResponseModel?, _ error: Error?) -> Void) {
        do {
            let albumResponse = try JSONDecoder().decode(AlbumsResponseModel.self, from: json)
            return completion(albumResponse, nil)
        } catch let error {
            return completion(nil, error)
        }
    }
    
    private func createTrackObjectWith(json: Data, completion: @escaping (_ data: TracksResponseModel?, _ error: Error?) -> Void) {
        do {
            let trackResponse = try JSONDecoder().decode(TracksResponseModel.self, from: json)
            return completion(trackResponse, nil)
        } catch let error {
            return completion(nil, error)
        }
    }
}
