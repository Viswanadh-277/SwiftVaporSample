//
//  SongDTO.swift
//
//
//  Created by KSMACMINI-016 on 02/07/24.
//

import Fluent
import Vapor

struct SongDTO: Content {
    var id: UUID?
    var title: String?
    
    func songModel() -> Song {
        let model = Song()
        
        model.id = self.id
        if let title = self.title {
            model.title = title
        }
        return model
    }
}
