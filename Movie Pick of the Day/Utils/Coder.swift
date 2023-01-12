//
//  Coder.swift
//  Movie Pick of the Day
//
//  Created by Wind Versi on 12/1/23.
//

import Foundation

class DictionaryCoder {
    
    static func getDictionary<T>(of object: T) -> [String: Any]? where T: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object.self)
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            let dictionary = jsonObject as? [String: Any]
            guard let dictionary else {
                print("getDictionary - error: can't convert json object to dictionary")
                return nil
            }
            return dictionary
        } catch let error {
            print("getDictionary - error: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func getType<T>(of dictionary: [String: Any]) -> T? where T: Decodable {
        let decoder = JSONDecoder()
        do {
            let data = try JSONSerialization.data(withJSONObject: dictionary)
            let object = try decoder.decode(T.self, from: data)
            return object
        } catch let error {
            print("getType - error: \(error.localizedDescription)")
            return nil
        }
    }
    
}
