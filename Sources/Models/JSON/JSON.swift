//  JSON.swift

import Foundation

public class JSON: Equatable, Codable {
    public let map: [Variable: JSONSupportedType]
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let compositeDictionary = try? container.decode([Variable: JSONSupportedType].self) {
            var map = [Variable: JSONSupportedType]()
            for (key, item) in compositeDictionary {
                guard !key.isEmpty else {
                    throw DecodingError.dataCorruptedError(in: container, debugDescription: "JSON contained empty key. Invalid data.")
                }
                map[key] = item
            }
            if map.isEmpty {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Empty object. Invalid data.")
            }
            
            self.map = map
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported type. Invalid data.")
        }
    }
    
    public func toObject<T: Decodable>() throws -> T? {
        let data = try JSONSerialization.data(withJSONObject: map, options: [])
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    public static func == (lhs: JSON, rhs: JSON) -> Bool {
        NSDictionary(dictionary: lhs.map).isEqual(to: rhs.map)
    }
}
