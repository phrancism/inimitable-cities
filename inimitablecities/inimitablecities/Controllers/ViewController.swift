import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let cityUniqueWords = CitiesUniqueWords.default.data.first { $0.name == "zirma" }!
        let cityAllWords = CitiesAllWords.default.data.first { $0.name == "zirma" }!

        let lettersOfUniqueWords = cityUniqueWords.uniqueWords.flatMap { $0.map(String.init) }

        var counterLettersOfUniqueWords = ItalianAlphabetCounter()
        lettersOfUniqueWords.forEach { letter in
            counterLettersOfUniqueWords.counter[letter]! += 1
        }
        let counterSorted = counterLettersOfUniqueWords.counter.sorted { $0.key < $1.key }
        print(counterSorted)

        print(counterLettersOfUniqueWords.counter)
        print(counterLettersOfUniqueWords.total)
        print(counterLettersOfUniqueWords.relativeFrequencies)
    }


}
