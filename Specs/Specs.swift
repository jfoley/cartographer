import Quick
import Nimble
import Cartographer

struct Person {
    let id: Int
    let name: String
    let kitty: Kitty
}

struct Kitty {
    let name: String
}

extension Person: Mappable {
    init(mapper: Cartographer) throws {
        self.init(
            id: try mapper.fetch("id"),
            name: try mapper.fetch("name"),
            kitty: try mapper.fetch("kitty")
        )
    }
}

extension Kitty: Mappable {
    init(mapper: Cartographer) throws {
        self.init(
            name: try mapper.fetch("name")
        )
    }
}

class CartographerSpec: QuickSpec {
    override func spec() {
        describe("cartographer") {
            it("maps an object") {
                let json = [
                    "id": 1,
                    "name": "person-name",
                    "kitty": [
                        "name": "kitty-face"
                    ]
                ]

                let cartographer = Cartographer(json: json)

                do {
                    let person = try Person(mapper: cartographer)

                    expect(person.name).to(equal("person-name"))
                    expect(person.id).to(equal(1))
                    expect(person.kitty.name).to(equal("kitty-face"))
                } catch {
                    
                }
            }
        }
    }
}
