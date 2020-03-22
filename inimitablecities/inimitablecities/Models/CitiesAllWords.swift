import Foundation

struct CitiesAllWords {
    static let `default` = CitiesAllWords()
    private enum Constants {
        static let citiesAllWordsJSONFileName = "cities_words"
    }

    let data: [CityAllWords]

    private init() {

        guard let url = Bundle.main.url(forResource: Constants.citiesAllWordsJSONFileName, withExtension: "json")
            else { fatalError("Cities Unique Words JSON file could not be found") }

        guard let data = try? Data(contentsOf: url)
            else { fatalError("Cities Unique Words JSON file could not be read") }

        guard let dataDecoded = try? JSONDecoder().decode([CityAllWords].self, from: data)
            else { fatalError("Cities Unique Words JSON file could not be decoded") }

        self.data = dataDecoded
    }
}

struct CityAllWords: Decodable {
    let name: String
    let words: [String]
}
