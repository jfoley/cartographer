import Quick
import Nimble
import Cartographer

private struct Person {
    let id: Int
    let name: String
}

extension Person: Mappable {
    init(mapper: Cartographer) throws {
        self.init(
            id: try mapper.fetch("id"),
            name: try mapper.fetch("name")
        )
    }
}

class SimpleCartographerSpec: QuickSpec {
    override func spec() {
        describe("mapping a simple object") {
            it("maps an object") {
                let json = [
                    "id": 1,
                    "name": "person-name",
                ]

                let cartographer = Cartographer(json: json)

                do {
                    let person = try Person(mapper: cartographer)

                    expect(person.name).to(equal("person-name"))
                    expect(person.id).to(equal(1))
                } catch {
                    fail("there was an error in mapping")
                }
            }
        }
    }
}
