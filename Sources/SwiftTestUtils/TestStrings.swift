//
//  File.swift
//  
//
//  Created by Joshua Clark on 9/30/22.
//

import Foundation

public class TestStrings {
    private var testValues: TestValues?
    private var jsonPath: URL
    
    public convenience init?(jsonPathFromHomeDirectory: String) throws {
        let jsonPath = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(jsonPathFromHomeDirectory, isDirectory: false)
        try self.init(jsonPath: jsonPath)
    }
    
    public convenience init?(jsonPathFromApplicationSupportDirectory: String) throws {
        let jsonPath = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Library/Application Support/\(jsonPathFromApplicationSupportDirectory)", isDirectory: false)
        try self.init(jsonPath: jsonPath)
    }
    
    public init?(jsonPath: URL) throws {
        do {
            let fileManager = FileManager.default.self
            if !fileManager.fileExists(atPath: jsonPath.path) {
                if !fileManager.fileExists(atPath: jsonPath.deletingLastPathComponent().path) {
                    try fileManager.createDirectory(at: jsonPath.deletingLastPathComponent(), withIntermediateDirectories: true)
                }
                fileManager.createFile(atPath: jsonPath.path, contents: nil)
                self.testValues = nil
            } else {
                guard let data = try? Data(contentsOf: jsonPath) else {return nil}
                let decoder = JSONDecoder()
                self.testValues = try decoder.decode(TestValues.self, from: data)
            }
            
            self.jsonPath = jsonPath
        } catch {
            throw TestStringsError.jsonDecodeError
        }
    }
    
    public func fetchValue(name: String) -> String? {
        guard let testValues = testValues else {
            return nil
        }

        for index in 0..<testValues.testValueArray.count {
            if name == testValues.testValueArray[index].name {
                return testValues.testValueArray[index].value
            }
        }
        return nil
    }
    
    public func addValue(name: String, value: String) throws {
        let testValue = TestValue(name: name, value: value)
        if let testValues = self.testValues {
            for index in 0..<testValues.testValueArray.count {
                if name == testValues.testValueArray[index].name {
                    self.testValues!.testValueArray.remove(at: index)
                }
            }
           
            self.testValues!.testValueArray.append(testValue)
            try self.createJsonFile()
        } else {
            self.testValues = TestValues(testValueArray: [testValue])
            try self.createJsonFile()
        }
    }
    
    public func removeValue(name: String) throws {
        guard let testValues = self.testValues else {
            return
        }
        
        for index in 0..<testValues.testValueArray.count {
            if name == testValues.testValueArray[index].name {
                self.testValues!.testValueArray.remove(at: index)
                try self.createJsonFile()
            }
        }
    }
    
    public func createJsonFile() throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        do
        {
            let configData = try encoder.encode(self.testValues)
            try FileManager.default.removeItem(at: self.jsonPath)
            FileManager.default.createFile(atPath: self.jsonPath.path, contents: configData)
        }
        
        catch
        {
            throw TestStringsError.jsonEncodeError
        }
    }
}

public struct TestValues: Codable {
    var testValueArray: [TestValue]
}

public struct TestValue: Codable {
    let name: String
    let value: String
}

public enum TestStringsError: Error {
    case jsonEncodeError
    case jsonDecodeError
}
