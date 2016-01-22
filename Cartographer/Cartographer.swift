public class Cartographer {
    private let json: [String: AnyObject]
    
    public init(json: [String: AnyObject]) {
        self.json = json
    }
    
    public func fetch<T>(key: String) throws -> T {
        let value = json[key]!
        
        return cast(value)
    }
    
    func cast<T>(value: AnyObject) -> T {
        return value as! T
    }
}

public protocol Mappable {
    init(mapper: Cartographer) throws
}
