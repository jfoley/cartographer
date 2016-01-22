public class Cartographer {
    private let json: [String: AnyObject]
    
    public init(json: [String: AnyObject]) {
        self.json = json
    }
    
    public func fetch<T: Mappable>(key: String) throws -> T {
        let value = json[key]!
    
        return try! cast(value)
    }
    
    public func fetch<T>(key: String) throws -> T {
        let value = json[key]!
        
        return cast(value)
    }
    
    func cast<T: Mappable>(value: AnyObject) throws -> T {
        return try T(mapper: Cartographer(json: value as! [String: AnyObject]))
    }
    
    func cast<T>(value: AnyObject) -> T {
        return value as! T
    }
}

public protocol Mappable {
    init(mapper: Cartographer) throws
}