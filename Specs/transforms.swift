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
            id: try mapper.fetch("id", transform: {x in x + 5}),
            name: try mapper.fetch("name")
        )
    }
}

class TransformsSpec: QuickSpec {
    override func spec() {
        describe("mapping an object with transforms") {
            it("maps an object transforming the keys") {
                let json = [
                    "id": 1,
                    "name": "person-name",
                ]

                let cartographer = Cartographer(json: json)

                do {
                    let person = try Person(mapper: cartographer)

                    expect(person.name).to(equal("person-name"))
                    expect(person.id).to(equal(6))
                } catch {
                    fail("there was an error in mapping")
                }
            }
        }
    }
}
