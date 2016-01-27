public class Cartographer {
    public enum Error: ErrorType {
        case MissingKey(String)
        case CannotCast(String, Any)
    }

    private let json: [String: AnyObject]
    
    public init(json: [String: AnyObject]) {
        self.json = json
    }
    
    public func fetch<T: Mappable>(key: String) throws -> T {
        guard let value = json[key] else {
            throw Error.MissingKey(key)
        }
    
        return try! cast(value, key: key)
    }
    
    public func fetch<T>(key: String) throws -> T {
        guard let value = json[key] else {
            throw Error.MissingKey(key)
        }
        
        return try cast(value, key: key)
    }

    public func fetchMany<T: Mappable>(key: String) throws -> [T] {
        let values = json[key]! as! [AnyObject]
        
        return try values.map { value in
            return try T(mapper: Cartographer(json: value as! [String: AnyObject]))
        }
    }
    
    public func fetch<T>(key: String, transform: (T) -> (T)) throws -> T {
        let value = json[key]!
        
        return transform(try cast(value, key: key))
    }
    
    func cast<T: Mappable>(value: AnyObject, key: String) throws -> T {
        return try T(mapper: Cartographer(json: value as! [String: AnyObject]))
    }
    
    func cast<T>(value: AnyObject, key: String) throws -> T {
        guard let casted: T = value as? T else {
            throw Error.CannotCast(key, T.self)
        }

        return casted
    }
}

public protocol Mappable {
    init(mapper: Cartographer) throws
}