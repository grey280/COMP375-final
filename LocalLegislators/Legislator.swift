//
//  Legislator.swift
//  LocalLegislators
//
//  Created by Grey Patterson on 2017-05-22.
//  Copyright © 2017 Grey Patterson. All rights reserved.
//

import Foundation

class Legislator{
    var name: String
    var twitter: String
    var website: URL
    
    init(_ name: String, twitter: String, website: URL){
        self.name = name
        self.twitter = twitter
        self.website = website
    }
    
    convenience init(_ name: String, twitter: String, website: String){
        let site = URL(string: website) ?? URL(string: "https://www.whitehouse.gov")!
        self.init(name, twitter: twitter, website: site)
    }
}
