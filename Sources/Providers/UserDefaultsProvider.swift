//  UserDefaultsProvider.swift

import Foundation

private let userDefaultsKeyPrefix = "com.toggles"

public class UserDefaultsProvider: MutableValueProvider {
    
    public var name: String { "UserDefaults" }
    
    private let userDefaults: UserDefaults
    
    public init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    public func optionalValue(for variable: Variable) -> Value? {
        let data = userDefaults.value(forKey: key(for: variable)) as? Data
        guard let data = data else { return nil }
        return try! PropertyListDecoder().decode(Value?.self, from: data)
    }
    
    public func set(_ value: Value, for variable: Variable) {
        let data = try! PropertyListEncoder().encode(value)
        userDefaults.set(data, forKey: key(for: variable))
    }
    
    public func delete(_ variable: Variable) {
        userDefaults.set(nil, forKey: key(for: variable))
    }
    
    // MARK: - Private
    
    private func key(for identifier: String) -> String {
        [userDefaultsKeyPrefix, identifier].joined(separator: ".")
    }
}
