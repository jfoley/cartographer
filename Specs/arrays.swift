import Quick
import Nimble
import Cartographer

private struct Person {
    let id: Int
    let name: String
    let kitties: [Kitty]
}

private struct Kitty {
    let name: String
}

extension Person: Mappable {
    init(mapper: Cartographer) throws {
        self.init(
            id: try mapper.fetch("id"),
            name: try mapper.fetch("name"),
            kitties: try mapper.fetchMany("kitties")
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

class ArrayCartographerSpec: QuickSpec {
    override func spec() {
        describe("mapping an object with arrays") {
            it("maps an object") {
                let json = [
                    "id": 1,
                    "name": "person-name",
                    "kitties": [
                        [
                            "name": "meow-face"
                        ]
                    ]
                ]
                
                let cartographer = Cartographer(json: json)
                
                do {
                    let person = try Person(mapper: cartographer)
                    
                    expect(person.name).to(equal("person-name"))
                    expect(person.id).to(equal(1))
                    expect(person.kitties.first!.name).to(equal("meow-face"))
                } catch {
                    fail("there was an error in mapping")
                }
            }
        }
    }
}
