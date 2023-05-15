//
//  Model.swift
//  Test
//
//  Created by Haris Pratama on 15/05/23.
//

import Foundation

struct Owner: Codable {
    let login: String
    let id: Int
    let node_id: String
    let avatar_url: String
    let gravatar_id: String
    let url: String
    let html_url: String
    let followers_url: String
    let following_url: String
    let gists_url: String
    let starred_url: String
    let subscriptions_url: String
    let organizations_url: String
    let repos_url: String
    let events_url: String
    let received_events_url: String
    let type: String
    let site_admin: Bool
}

struct Items: Codable  {
    let id: Int
    let node_id: String
    let name: String
    let full_name: String
    let owner: Owner
    let html_url: String
    let description: String?
}

struct Resp: Codable {
    let total_count: Int
    let incomplete_results: Bool
    let items: [Items]
}
