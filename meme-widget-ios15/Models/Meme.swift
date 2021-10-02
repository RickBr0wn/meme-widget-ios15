//
//  Meme.swift
//  meme-widget-ios15
//
//  Created by Rick Brown on 02/10/2021.
//

import Foundation

struct Meme: Codable {
  let postLink: URL
  let subreddit: String
  let title: String
  let url: URL
  let nsfw: Bool
  let spoiler: Bool
  let author: String
  let ups: Int
  let preview: [URL]
}
