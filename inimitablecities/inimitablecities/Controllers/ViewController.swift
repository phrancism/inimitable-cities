import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var canvas: UIView!
    private var canvasHeight: CGFloat { canvas.bounds.height }
    private var canvasWidth: CGFloat { canvas.bounds.width }
    private var canvasMinX: CGFloat { canvas.bounds.minX }
    private var canvasMinY: CGFloat { canvas.bounds.minY }
    private var canvasMidX: CGFloat { canvas.bounds.midX }
    private var canvasMidY: CGFloat { canvas.bounds.midY }
    

    private let cityName = "olivia"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let cityUniqueWords = CitiesUniqueWords.default.data.first { $0.name == cityName }!

        let offsetWordsCount = cityUniqueWords.uniqueWords.count + 1
        for (i, word) in cityUniqueWords.uniqueWords.enumerated() {
            let offsetIndex = i + 1
            let ratio: CGFloat = (offsetIndex.cgFloat / offsetWordsCount.cgFloat)
            let startPointX: CGFloat = ratio * canvasWidth
            let startPointY: CGFloat = ratio * canvasHeight
            let startPoint = CGPoint(x: canvasMinX, y: startPointY)

            for letter in Array(word).map(String.init) {
                drawPathFor(letter.normalized, startingAt: startPoint)
            }
        }

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
        let buildingViewHeight = (canvas.bounds.height / Constants.italianAlphabetCount.cgFloat) * Constants.skylineHeightRatio

        relativeFrequenciesSorted.enumerated().forEach { i, frequency in
            let buildingViewWidth = canvasWidth * Constants.buildingViewWidthRatio * (frequency.value / 0.25).cgFloat
            let buildingViewVerticalPosition = i.cgFloat * buildingViewHeight + skylineStartPoint
            let buildingViewOrigin = CGPoint(x: CGFloat.zero, y: buildingViewVerticalPosition)
            let buildingViewSize = CGSize(width: buildingViewWidth, height: buildingViewHeight)
            let buildingViewRect = CGRect(origin: buildingViewOrigin, size: buildingViewSize)
            let buildingView = UIView(frame: buildingViewRect)
            buildingView.backgroundColor = canvas.backgroundColor ?? .black
            canvas.addSubview(buildingView)
        }
    }

    private func drawPathFor(_ letter: String, startingAt startPoint: CGPoint) {
        let path = UIBezierPath()
        let endPoint = letterPathEndPointFor(letter)
        let leftControlPoint = CGPoint(x: canvasMidX, y: endPoint.y)
        let rightControlPoint = CGPoint(x: canvasMidX, y: startPoint.y)

        path.move(to: startPoint)
        path.addCurve(to: endPoint, controlPoint1: rightControlPoint, controlPoint2: leftControlPoint)

        let shapeLayer = CAShapeLayer()
        let hue = hueFor(letter)
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor(
            hue: hue,
            saturation: Constants.letterPathSaturation,
            brightness: Constants.letterPathBrightness,
            alpha: Constants.letterPathAlpha
        ).cgColor
        shapeLayer.lineWidth = Constants.letterPathWidth
        shapeLayer.fillColor = UIColor(white: 0, alpha: 0).cgColor
        canvas.layer.addSublayer(shapeLayer)
    }

    private func letterPathEndPointFor(_ letter: String) -> CGPoint {
        guard let index = ItalianAlphabetCounter.letters.firstIndex(of: letter)
            else { return CGPoint.zero }

        let offsetIndex = index + 1
        let offsetItalianAlphabetCount = Constants.italianAlphabetCount + 1

        let ratio: CGFloat = (offsetIndex.cgFloat / offsetItalianAlphabetCount.cgFloat)
        let xValue: CGFloat = ratio * canvasWidth
        let yValue: CGFloat = ratio * canvasHeight

        return CGPoint(x: canvasWidth, y: yValue)
    }

    private func hueFor(_ letter: String) -> CGFloat {
        guard let index = ItalianAlphabetCounter.letters.firstIndex(of: letter)
            else { return CGFloat.zero }

        return (index.cgFloat / Constants.italianAlphabetCount.cgFloat)
    }
}

private extension ViewController {
    private enum Constants {
        static let italianAlphabetCount: Int = 21
        static let letterPathAlpha: CGFloat = 0.25
        static let letterPathBrightness: CGFloat = 0.75
        static let letterPathSaturation: CGFloat = 0.8
        static let letterPathWidth: CGFloat = 3.0
        static let buildingViewWidthRatio: CGFloat = 0.75
        static let skylineHeightRatio: CGFloat = 0.95
        static var skylineStartPointRatio: CGFloat { (1 - skylineHeightRatio) / 2}
    }
}

private extension Double {
    var cgFloat: CGFloat { CGFloat(self) }
}

private extension Int {
    var cgFloat: CGFloat { CGFloat(self) }
    var isEven: Bool { return (self % 2) == 0  }
}

private extension String {
    var normalized: String {
        switch self {
            case "à": return "a"
            case "é", "è": return "e"
            case "ì": return "i"
            case "ò": return "o"
            case "ù": return "u"
            default: return self
        }
    }
}
