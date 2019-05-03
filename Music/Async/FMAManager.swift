import Foundation

class FMAManager {

    private var urlHelper: URLHelper!
    private let defaults = UserDefaults.standard

    init() {
        urlHelper = URLHelper()
    }

    internal func getGenres(page: Int, completion: @escaping (_ data: GenresResponseModel?, _ error: Error?) -> Void) {
        let url = urlHelper.getGenresURLString(page)

        if let genres = defaults.object(forKey: "genres") as? Data {
            let decoder = JSONDecoder()
            if let genreResponseModel = try? decoder.decode(GenresResponseModel.self, from: genres) {
                completion(genreResponseModel, nil)
            }
        }

//        getJSONFromURL(urlString: url) { data, error in
//            guard let data = data, error == nil else {
//                return completion(nil, error)
//            }
//
//            self.createGenreObjectWith(json: data) { model, error in
//                guard let model = model, error == nil else {
//                    return completion(nil, error)
//                }
////                let encoder = JSONEncoder()
////                if let encoded = try? encoder.encode(model) {
////                    let defaults = UserDefaults.standard
////                    defaults.set(encoded, forKey: "genres")
////                }
//
//                return completion(model, nil)
//            }
//        }
    }

    internal func getTracks(genre: GenreModel, page: Int, completion: @escaping (_ data: TracksResponseModel?, _ error: Error?) -> Void) {
        let url = urlHelper.getTracksURLString(genreId: genre.id, page: page)

        if let tracks = defaults.object(forKey: "\(genre.id)") as? Data {
            let decoder = JSONDecoder()
            if let trackResponseModel = try? decoder.decode(TracksResponseModel.self, from: tracks) {
                completion(trackResponseModel, nil)
            }
        }

//        getJSONFromURL(urlString: url) { data, error in
//            guard let data = data, error == nil else {
//                return completion(nil, error)
//            }
//
//            self.createTrackObjectWith(json: data) { response, error in
//                guard let response = response, error == nil else {
//                    return completion(nil, error)
//                }
//
////                let encoder = JSONEncoder()
////                if let encoded = try? encoder.encode(response) {
////                    let defaults = UserDefaults.standard
////                    defaults.set(encoded, forKey: "\(genre.id)")
////                }
//
//                return completion(response, nil)
//            }
//        }
    }
    
    internal func getTrack(trackId: String, completion: @escaping (_ trackUrl: String?, _ error: Error?) -> Void) {
        let url = urlHelper.getTrackURLString(trackId: trackId)

        getJSONFromURL(urlString: url) { data, error in
            guard let data = data, error == nil else {
                return completion(nil, error)
            }

            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let trackFileUrl = json["track_file_url"] as? String {
                return completion(trackFileUrl, nil)
            }
            return completion(nil, nil)
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
    
    private func createTrackObjectWith(json: Data, completion: @escaping (_ data: TracksResponseModel?, _ error: Error?) -> Void) {
        do {
            let trackResponse = try JSONDecoder().decode(TracksResponseModel.self, from: json)
            return completion(trackResponse, nil)
        } catch let error {
            return completion(nil, error)
        }
    }
    
    private func createTrackWith(json: Data, completion: @escaping (_ data: TrackModel?, _ error: Error?) -> Void) {
        do {
            let trackModel = try JSONDecoder().decode(TrackModel.self, from: json)
            return completion(trackModel, nil)
        } catch let error {
            return completion(nil, error)
        }
    }
}
