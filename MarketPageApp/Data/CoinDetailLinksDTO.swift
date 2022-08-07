import Foundation

struct CoinDetailLinksDTO: Codable {
    let homepage: [String]
    let blockchain_site: [String]
    let official_forum_url: [String]
    let subreddit_url: String?
    let twitter_screen_name: String?
    let repos_url: CoinDetailReposDTO
}

extension CoinDetailLinksDTO: CoinLinksRepresentable {
    var availableLinks: [CoinDetailLink: String] {
        var availableLinks: [CoinDetailLink: String] = [:]
        if let url = homepage.first(where: { !$0.isEmpty }) {
            availableLinks[.homepage] = url
        }
        if let url = blockchain_site.first(where: { !$0.isEmpty }) {
            availableLinks[.blockchainSite] = url
        }
        if let url = official_forum_url.first(where: { !$0.isEmpty }) {
            availableLinks[.forum] = url
        }
        if let url = subreddit_url {
            availableLinks[.subreddit] = url
        }
        if let url = twitter_screen_name {
            availableLinks[.twitterUser] = "https://www.twitter.com/\(url)"
        }
        if let url = repos_url.github.first(where: { !$0.isEmpty }) {
            availableLinks[.github] = url
        }
        if let url = repos_url.bitbucket.first(where: { !$0.isEmpty }) {
            availableLinks[.bitbucket] = url
        }
        return availableLinks
    }
}
