//
//  DataManager.swift
//  ToDoList
//
//  Created by Prabhat Singh Pathania on 23/07/18.
//  Copyright © 2018 Prabhat Singh Pathania. All rights reserved.
//

import Foundation

public class DataManager {
    
    // get Document Directory
    static fileprivate func getDocumentDirectory()-> URL{
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
            return url
        }
        else{
            fatalError("Unable to access document directory")
        }
    }
    
    
    // Save any kind of codable objects
    static func save <T:Encodable> (_ object:T, with filename:String){
        let url = getDocumentDirectory().appendingPathComponent(filename, isDirectory: false)
        let encoder = JSONEncoder()
        do{
            let data = try encoder.encode(object)
            if FileManager.default.fileExists(atPath: url.path){
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        }
        catch{fatalError(error.localizedDescription)}
    }
    
    // Load any kind of codable object
    static func load <T:Decodable> (_ filename:String, with type:T.Type) -> T {
        let url = getDocumentDirectory().appendingPathComponent(filename, isDirectory: false)
        if !FileManager.default.fileExists(atPath: url.path){
            fatalError("File not found at path \(url.path)")
        }
        if let data = FileManager.default.contents(atPath: url.path){
            do{
                let model = try JSONDecoder().decode(type, from: data)
                return model
            }
            catch {fatalError(error.localizedDescription)}
        }else{
            fatalError("Data unavailable at path \(url.path)")
        }
    }
    
    // Load data from file
    static func loadData (_ filename:String) -> Data? {
        let url = getDocumentDirectory().appendingPathComponent(filename, isDirectory: false)
        if !FileManager.default.fileExists(atPath: url.path){
            fatalError("File not found at path \(url.path)")
        }
        if let data = FileManager.default.contents(atPath: url.path){
            return data
        }else{
            fatalError("Data unavailable at path \(url.path)")
        }
    }
    
    // Load all file from a directory
    static func loadAll <T:Decodable> (_ type:T.Type) -> [T] {
        do{
            let files = try FileManager.default.contentsOfDirectory(atPath: getDocumentDirectory().path)
            var modelObjects = [T]()
            for fileName in files {
                modelObjects.append(load(fileName, with: type))
            }
            return modelObjects
        }
        catch{fatalError("Could not load any files")}
    }
    
    // Delete a files
    static func delete (_ fileName:String){
        let url = getDocumentDirectory().appendingPathComponent(fileName, isDirectory: false)
        if FileManager.default.fileExists(atPath: url.path){
            do{
                try FileManager.default.removeItem(at: url)
                
            }
            catch{fatalError(error.localizedDescription)}
        }
        else {
            
        }
    }
    
}
