//
//  Song.swift
//
//
//  Created by KSMACMINI-016 on 02/07/24.
//

import Fluent
import Vapor

final class Song: Model, @unchecked Sendable{
    static let schema = "songs"
    
    @ID(key: .id)
    var id : UUID?
    
    @Field(key: "title")
    var title : String
    
    init() { }
    
    init (id: UUID? = nil, title : String) {
        self.id = id
        self.title = title
    }
    
    func songDTO() -> SongDTO {
        .init(
            id: self.id,
            title: self.$title.value
        )
    }
}
