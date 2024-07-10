//
//  SongViewController.swift
//
//
//  Created by KSMACMINI-016 on 02/07/24.
//

import Fluent
import Vapor

struct SongViewController : RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let songs = routes.grouped("songs")
        songs.get(use: self.index)
        songs.post(use: self.create)
        songs.group(":id") { song in
            song.delete(use: self.delete)
            song.get(use : self.getById)
        }
        songs.put(use: self.put)
    }
    
    // /songs route --> GET Request
    @Sendable
    func index(req : Request) async throws -> [SongDTO] {
        try await Song.query(on : req.db).all().map { $0.songDTO() }
    }
    
    // /songs route --> POST Request
    @Sendable
    func create(req: Request) async throws -> HTTPStatus {
        let song = try req.content.decode(SongDTO.self).songModel()

        try await song.save(on: req.db)
        return .ok
    }

    // /songs/id route --> DELETE Request
    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let song = try await Song.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        try await song.delete(on: req.db)
        return .noContent
    }
    
    // /songs/id route --> GET Request
    @Sendable
    func getById(req: Request) async throws -> SongDTO {
        guard let song = try await Song.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        return song.songDTO()
    }
    
    // /songs route --> PUT Request
    @Sendable
    func put(req: Request) async throws -> SongDTO {
        let editedSong = try req.content.decode(SongDTO.self).songModel()
        
        guard let song = try await Song.find(editedSong.id, on: req.db) else {
            throw Abort(.notFound)
        }
        
        song.title = editedSong.title
        
        try await song.update(on: req.db)
        
        return song.songDTO()
    }
}
