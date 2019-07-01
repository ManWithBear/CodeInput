//
//  CodeInputView.swift
//  CodeInput
//
//  Created by Denis Bogomolov on 04/03/2017.
//

import UIKit

/// Thanks to https://gist.github.com/preble/ab98fabda985b054126e
class CodeInputTextStorage: NSTextStorage {

    private var storage = NSTextStorage()

    // MARK: NSTextStorage Primitive Methods
    // https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/TextStorageLayer/Tasks/Subclassing.html

    override var string: String {
        return storage.string
    }

    override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedString.Key : Any] {
        return storage.attributes(at: location, effectiveRange: range)
    }

    override func replaceCharacters(in range: NSRange, with str: String) {
        beginEditing()
        storage.replaceCharacters(in: range, with: str)
        edited(.editedCharacters, range: range, changeInLength: (str as NSString).length - range.length)
        endEditing()
    }

    override func setAttributes(_ attrs: [NSAttributedString.Key : Any]?, range: NSRange) {
        beginEditing()
        storage.setAttributes(attrs, range: range)
        edited(.editedAttributes, range: range, changeInLength: 0)
        endEditing()
    }
}

class CodeInputTextContainer: NSTextContainer {
    // swiftlint:disable:next line_length
    override func lineFragmentRect(forProposedRect proposedRect: CGRect, at characterIndex: Int, writingDirection baseWritingDirection: NSWritingDirection, remaining remainingRect: UnsafeMutablePointer<CGRect>?) -> CGRect {
        let sRect = super.lineFragmentRect(forProposedRect: proposedRect,
                                           at: characterIndex,
                                           writingDirection: baseWritingDirection,
                                           remaining: remainingRect
        )
        guard let storage = layoutManager?.textStorage, !storage.string.isEmpty else { return sRect }
        let char = storage.attributedSubstring(from: NSRange(location: characterIndex, length: 1))
        let width = char.size().width
        let delta = (sRect.width - width) / 2
        let rect = CGRect(x: sRect.minX + delta, y: sRect.minY, width: width, height: sRect.height)
        return rect
    }

}

open class CodeInputView: UITextView {
    private var lettersFrames: [CGRect] = []
    private var exclusionsFrames: [CGRect] = []

    public init(_ symbolsCount: Int, spacing: CGFloat) {
        self.symbolsCount = symbolsCount
        self.symbolSpacing = spacing
        let textStorage = CodeInputTextStorage()
        let layout = NSLayoutManager()
        let container = CodeInputTextContainer(size: .zero)
        layout.addTextContainer(container)
        textStorage.addLayoutManager(layout)
        super.init(frame: .zero, textContainer: container)
        setup()
    }

    @available(*, unavailable) required public init?(coder aDecoder: NSCoder) {
        fatalError("Xib/storyboard initialiation not supported, please use CodeInputWrapper")
    }

    lazy var underlineLayer: CAShapeLayer = {
        let shape = CAShapeLayer()
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.black.cgColor
        shape.backgroundColor = UIColor.clear.cgColor
        self.layer.insertSublayer(shape, at: 0)
        shape.frame = self.layer.bounds
        return shape
    }()

    override open func layoutSubviews() {
        super.layoutSubviews()
        update()
    }

    func update() {
        calculateRects()
        updateExclusion()
        updateUnderlines()
    }

    public var symbolsCount: Int {
        didSet {
            update()
        }
    }
    public var symbolSpacing: CGFloat {
        didSet {
            update()
        }
    }

    func setup() {
        isScrollEnabled = false
        textAlignment = .center
        contentInset = .zero
        backgroundColor = .clear
        textContainerInset = .zero
        textContainer.maximumNumberOfLines = symbolsCount
        textContainer.lineFragmentPadding = 0
        font = UIFont.systemFont(ofSize: 30)
        text = ""
        autocapitalizationType = .none
        autocorrectionType = .no
        spellCheckingType = .no
        update()
    }

    func calculateRects() {
        guard let font = font else { return }
        let height = bounds.height
        lettersFrames = stride(from: 0, to: symbolsCount, by: 1).map {
            CGRect(x: (font.mWidth + symbolSpacing) * CGFloat($0), y: 0, width: font.mWidth, height: height)
        }
        exclusionsFrames = stride(from: 1, to: symbolsCount, by: 1).map {
            CGRect(x: (font.mWidth + symbolSpacing) * CGFloat($0) - symbolSpacing, y: 0, width: symbolSpacing, height: height)
        }
    }

    func updateExclusion() {
        textContainer.exclusionPaths = exclusionsFrames.map { UIBezierPath(rect: $0) }
    }

    func updateUnderlines() {
        let underlineRects = lettersFrames
            .map { CGRect(x: $0.minX, y: $0.maxY - 1, width: $0.width, height: 1) }
        let path = CGMutablePath()
        path.addRects(underlineRects)
        underlineLayer.path = path
    }

    override open var intrinsicContentSize: CGSize {
        let height = font.map { $0.ascender - $0.descender } ?? 0
        return CGSize(width: lettersFrames.last?.maxX ?? 0, height: height)
    }

    open override func sizeToFit() {
        bounds.size = intrinsicContentSize
    }
}
