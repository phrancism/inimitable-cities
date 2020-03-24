import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var canvas: UIView!
    private var canvasHeight: CGFloat { canvas.bounds.height }
    private var canvasWidth: CGFloat { canvas.bounds.width }
    private var canvasMidY: CGFloat { canvas.bounds.midY }
    

    private let cityName = "zoe"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let cityUniqueWords = CitiesUniqueWords.default.data.first { $0.name == cityName }!

//        for (i, word) in cityUniqueWords.uniqueWords.enumerated() {
//
//        }

//        drawPathFor("a")
//        drawPathFor("z")
//        drawPathFor("z")
//        drawPathFor("u")
//        drawPathFor("r")
//        drawPathFor("r")
//        drawPathFor("o")

        drawSkylineFor(cityUniqueWords)
    }

    private func drawSkylineFor(_ cityUniqueWords: CityUniqueWords) {
        let lettersOfUniqueWords = cityUniqueWords.uniqueWords.flatMap { $0.map(String.init) }

        var counterLettersOfUniqueWords = ItalianAlphabetCounter()

        for letter in lettersOfUniqueWords {
            guard counterLettersOfUniqueWords.counter.keys.contains(letter) else { continue }
            counterLettersOfUniqueWords.counter[letter.normalized]! += 1
        }

        let relativeFrequenciesSorted = counterLettersOfUniqueWords.relativeFrequencies.sorted { $0.key < $1.key }
        let highestFrequency = relativeFrequenciesSorted.max { $0.value < $1.value }!

        let skylineStartPoint = canvas.bounds.height * Constants.skylineStartPointRatio
        let letterViewHeight = (canvas.bounds.height / Constants.italianAlphabetCount.cgFloat) * Constants.skylineHeightRatio

        relativeFrequenciesSorted.enumerated().forEach { i, frequency in
            let letterViewWidth = canvasWidth * Constants.letterViewWidthRatio * (frequency.value / highestFrequency.value).cgFloat
            let letterViewVerticalPosition = i.cgFloat * letterViewHeight + skylineStartPoint
            let letterViewOrigin = CGPoint(x: CGFloat.zero, y: letterViewVerticalPosition)
            let letterViewSize = CGSize(width: letterViewWidth, height: letterViewHeight)
            let letterViewRect = CGRect(origin: letterViewOrigin, size: letterViewSize)
            let letterView = UIView(frame: letterViewRect)
            letterView.backgroundColor = .white
            canvas.addSubview(letterView)
        }
    }

    private func drawPathFor(_ letter: String) {
        let path = UIBezierPath()
        let startPoint = CGPoint(x: canvasWidth, y: CGFloat.zero)
        let endPoint = letterPathEndPointFor(letter)
        let leftControlPoint = CGPoint(x: endPoint.x, y: canvasMidY)
        let rightControlPoint = CGPoint(x: startPoint.x, y: canvasMidY)

        path.move(to: startPoint)
        path.addCurve(to: endPoint, controlPoint1: rightControlPoint, controlPoint2: leftControlPoint)
        path.lineWidth = 150
        path.stroke()

        let shapeLayer = CAShapeLayer()
        let hue = hueFor(letter)
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor(
            hue: hue,
            saturation: Constants.letterPathSaturation,
            brightness: Constants.letterPathBrightness,
            alpha: Constants.letterPathAlpha
        ).cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.fillColor = UIColor(white: 0, alpha: 0).cgColor
        canvas.layer.addSublayer(shapeLayer)
    }

    private func letterPathEndPointFor(_ letter: String) -> CGPoint {
        guard let index = ItalianAlphabetCounter.letters.firstIndex(of: letter)
            else { return CGPoint.zero }

        let ratio: CGFloat = 1 - (index.cgFloat / Constants.italianAlphabetCount.cgFloat)
        let xValue: CGFloat = ratio * canvasWidth

        return CGPoint(x: xValue, y: canvasHeight)
    }

    private func hueFor(_ letter: String) -> CGFloat {
        guard let index = ItalianAlphabetCounter.letters.firstIndex(of: letter)
            else { return CGFloat.zero }

        return (index.cgFloat / Constants.italianAlphabetCount.cgFloat) * 360
    }
}

private extension ViewController {
    private enum Constants {
        static let italianAlphabetCount: Int = 21
        static let letterPathAlpha: CGFloat = 0.6
        static let letterPathBrightness: CGFloat = 0.75
        static let letterPathSaturation: CGFloat = 0.8
        static let letterPathWidth: CGFloat = 2.0
        static let letterViewWidthRatio: CGFloat = 0.75
        static let skylineHeightRatio: CGFloat = 0.9
        static var skylineStartPointRatio: CGFloat { (1 - skylineHeightRatio) / 2}
    }
}

private extension Double {
    var cgFloat: CGFloat { CGFloat(self) }
}

private extension Int {
    var cgFloat: CGFloat { CGFloat(self) }
}

private extension String {
    var normalized: String {
        switch self {
            case "à": return "a"
            case "é", "è": return "e"
            case "ì": return "i"
            case "ò": return "o"
            case "ù": return "ù"
            default: return self
        }
    }
}
