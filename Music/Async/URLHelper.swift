import Foundation

class URLHelper {

    private let apiKey = "2RYX9MW0RSIPYNPI"
    private let genresURL = "https://freemusicarchive.org/api/get/genres.json?"

    func getGenresUrlString(_ page: Int) -> String {
        return "\(genresURL)api_key=\(apiKey)&page=\(page)"
    }


}