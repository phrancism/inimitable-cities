import Foundation

struct CitiesUniqueWords {
    static let `default` = CitiesUniqueWords()
    private enum Constants {
        static let citiesUniqueWordsJSONFileName = "cities_unique_words"
    }

    let data: [CityUniqueWords]

    private init() {

        guard let url = Bundle.main.url(forResource: Constants.citiesUniqueWordsJSONFileName, withExtension: "json")
            else { fatalError("Cities Unique Words JSON file could not be found") }

        guard let data = try? Data(contentsOf: url)
            else { fatalError("Cities Unique Words JSON file could not be read") }

        guard let dataDecoded = try? JSONDecoder().decode([CityUniqueWords].self, from: data)
            else { fatalError("Cities Unique Words JSON file could not be decoded") }

        self.data = dataDecoded
    }
}

struct CityUniqueWords: Decodable {
    let name: String
    let uniqueWords: [String]

    private enum CodingKeys: String, CodingKey {
        case name
        case uniqueWords = "unique_words"
    }
}
