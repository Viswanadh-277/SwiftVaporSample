//
//  CreateSongs.swift
//
//
//  Created by KSMACMINI-016 on 02/07/24.
//

import Fluent

struct CreateSongs: AsyncMigration {
    
    func prepare(on database: Database) async throws {
        try await database.schema("songs")
            .id()
            .field("title", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("songs").delete()
    }
}
