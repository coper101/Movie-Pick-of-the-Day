//
//  SearchPager.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 21/3/23.
//

import Foundation

struct SearchPager {
    var page: Int
    var totalPages: Int
    
    var isLastPage: Bool {
        page == totalPages
    }
}
