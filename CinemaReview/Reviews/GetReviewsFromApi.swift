
import UIKit
import Alamofire
import Kingfisher

class GetReviewsFromApi {
    
    let urlReviewsNext = "https://api.nytimes.com/svc/movies/v2/reviews/search.json?offset=&api-key="
    
    let urlReviewsWord = "https://api.nytimes.com/svc/movies/v2/reviews/search.json?query=&api-key="
    
    let urlReviewsDate = "https://api.nytimes.com/svc/movies/v2/reviews/search.json?opening-date=&api-key="
    
    let urlReviews = "https://api.nytimes.com/svc/movies/v2/reviews/search.json?api-key="
    
    let urlReviewsByCritic = "https://api.nytimes.com/svc/movies/v2/reviews/search.json?reviewer=&api-key="
    
    let key = "rp3d9BM90jGDjFjCoCuXMX1JHgLz9rMG"
    
    var reviewsData: [Review] = []
    
    struct Success: Codable {
        let results: [Review]
        let copyright: String
        let status: String
        let has_more: Bool
        let num_results: Int
        
    }
    
    struct Review: Codable {
        let byline: String
        let publication_date: String
        let multimedia: Multimedia?
        let mpaa_rating: String
        let date_updated: String
        let link: Link
        let display_title: String
        let summary_short: String
        let opening_date: String?
        let critics_pick: Int
        let headline: String
    }
    
    struct Multimedia: Codable {
        let width: Int
        let type: String
        let src: String
        let height: Int
    }
    
    struct Link: Codable {
        let type: String
        let url: String
        let suggested_link_text: String
    }
    
    func getDataReviews(urlReviews: String, itsInfiniteScrolling: Bool, completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            
            AF.request(urlReviews + self.key).responseData { response in
                switch response.result {
                case .success(let data):
                    
                    do {
                        if !itsInfiniteScrolling {
                            self.reviewsData.removeAll()
                        }
                        
                        let decodedData = try JSONDecoder().decode(Success.self, from: data)
                        for i in 0...decodedData.results.count-1 {
                            self.reviewsData.append(decodedData.results[i])
                        }
                        
                    } catch {
                        print("decode error")
                    }
                    
                    DispatchQueue.main.async {
                        completion()
                    }
                    
                case .failure(let error):
                    print(error)
                    break
                }
            }
        }
    }
        
    func setImage(index: Int) -> URL? {
            let imageUrl = self.reviewsData[index].multimedia?.src ?? "vk.com/1"
            
            return URL(string: imageUrl)
    }
}
