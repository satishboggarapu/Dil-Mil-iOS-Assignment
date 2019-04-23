import Foundation

class FMAManager {

    private var urlHelper: URLHelper!

    init() {
        urlHelper = URLHelper()
    }

    func getGenres(page: Int = 1, completion: @escaping (_ data: GenreResponse?, _ error: Error?) -> Void) {
        let url = urlHelper.getGenresUrlString(page)

        getJSONFromURL(urlString: url) { data, error in
            guard let data = data, error == nil else {
                return completion(nil, error)
            }

            self.createGenreObjectWith(json: data) { model, error in
                guard let model = model, error == nil else {
                    return completion(nil, error)
                }
                return completion(model, nil)
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
    
    private func createGenreObjectWith(json: Data, completion: @escaping (_ data: GenreResponse?, _ error: Error?) -> Void) {
        do {
            let genreResponse = try JSONDecoder().decode(GenreResponse.self, from: json)
            return completion(genreResponse, nil)
        } catch let error {
            return completion(nil, error)
        }
    }
}
