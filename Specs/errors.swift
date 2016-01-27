import Quick
import Nimble
import Cartographer

private struct Person {
    let id: Int
    let name: String
    let kitty: Kitty
}

private struct Kitty {
    let name: String
}

extension Kitty: Mappable {
    init(mapper: Cartographer) throws {
        self.init(
            name: try mapper.fetch("name")
        )
    }
}

class ErrorsCartographerSpec: QuickSpec {
    override func spec() {
        describe("errors") {
            it("throws an error when trying to map a key that does not exist to a simple type") {
                let json = [
                    "id": 1,
                    "name": "person-name",
                ]
                
                let cartographer = Cartographer(json: json)
                
                expect {
                    Person.init(
                        id: try cartographer.fetch("id"),
                        name: try cartographer.fetch("name"),
                        kitty: try cartographer.fetch("bad-kitty")
                    )}.to(throwError(Cartographer.Error.MissingKey("bad-kitty")))
            }

            it("throws an error when trying to map a key that does not exist to a mappable type") {
                let json = [
                    "id": 1,
                    "name": "person-name",
                    "kitty": [
                        "name": "kitty-face"
                    ]
                ]
                
                let cartographer = Cartographer(json: json)
                
                expect {
                Person.init(
                    id: try cartographer.fetch("id"),
                    name: try cartographer.fetch("name"),
                    kitty: try cartographer.fetch("bad-kitty")
                )}.to(throwError(Cartographer.Error.MissingKey("bad-kitty")))
            }
            
            it("throws an error when trying to map a key with the wrong type") {
                let json = [
                    "id": "wat",
                    "name": "person-name",
                    "kitty": [
                        "name": "kitty-face"
                    ]
                ]
                
                let cartographer = Cartographer(json: json)
                
                expect {
                    Person.init(
                        id: try cartographer.fetch("id"),
                        name: try cartographer.fetch("name"),
                        kitty: try cartographer.fetch("kitty")
                    )}.to(throwError(Cartographer.Error.CannotCast("id", Int.self)))
            }

        }
    }
}
