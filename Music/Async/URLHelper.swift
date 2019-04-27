import Foundation

class URLHelper {

    private let apiKey = "2RYX9MW0RSIPYNPI"
    private let genresURL = "https://freemusicarchive.org/api/get/genres.json?"
    private let albumsURL = "https://freemusicarchive.org/api/get/albums.json?"
    private let tracksURL = "https://freemusicarchive.org/api/get/tracks.json?"

    func getGenresURLString(_ page: Int) -> String {
        var url = genresURL
        url += "api_key=\(apiKey)&"
        url += "page=\(page)"
        return url
    }
    
    func getAlbumsURLString(genreHandle: String, page: Int) -> String {
        var url = albumsURL
        url += "api_key=\(apiKey)&"
        url += "genre_handle=\(genreHandle)&"
        url += "page=\(page)"
        return url
    }

    func getTracksURLString(albumId: String, page: Int) -> String {
        var url = tracksURL
        url += "api_key=\(apiKey)&"
        url += "album_id=\(albumId)&"
        url += "page=\(page)"
        return url
    }

}