//
//  CodeInputView.swift
//  CodeInput
//
//  Created by Denis Bogomolov on 04/03/2017.
//

import UIKit

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
    public init(_ symbolsCount: Int, spacing: CGFloat) {
        self.symbolsCount = symbolsCount
        self.symbolSpacing = spacing
        let textStorage = NSTextStorage(string: "")
        let layout = NSLayoutManager()
        let container = CodeInputTextContainer(size: .zero)
        layout.addTextContainer(container)
        textStorage.addLayoutManager(layout)
        super.init(frame: .zero, textContainer: container)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("Xib/storyboard initialiation not supported, please use CodeInputWrapper")
    }

    lazy var underlineLayer: CAShapeLayer = {
        let shape = CAShapeLayer()
        shape.strokeColor = UIColor.red.cgColor
        shape.fillColor = UIColor.red.cgColor
        shape.backgroundColor = UIColor.clear.cgColor
        self.layer.insertSublayer(shape, at: 0)
        shape.frame = self.layer.bounds
        return shape
    }()

    override open func layoutSubviews() {
        super.layoutSubviews()
        updateExclusion()
        updateUnderlines()
    }

    public var symbolsCount: Int
    public var symbolSpacing: CGFloat

    func setup() {
        isScrollEnabled = false
        textAlignment = .center
        backgroundColor = .yellow
        contentInset = .zero
        textContainerInset = .zero
        textContainer.maximumNumberOfLines = symbolsCount
        textContainer.lineFragmentPadding = 0
        font = UIFont.systemFont(ofSize: 30)
        text = ""
    }

    func updateExclusion() {
        textContainer.exclusionPaths = calculateRects(for: .spacing).map { UIBezierPath(rect: $0) }
    }

    func updateUnderlines() {
        let underlineRects = calculateRects(for: .text)
            .map { CGRect(x: $0.minX, y: $0.maxY - 10, width: $0.width, height: 3) }
        let path = CGMutablePath()
        path.addRects(underlineRects)
        underlineLayer.path = path
    }

    enum Glyph {
        case spacing
        case text
    }

    func calculateRects(for glyph: Glyph) -> [CGRect] {
        let from = (glyph == .text) ? 0 : 1
        let count = 2 * symbolsCount - 1
        let height = bounds.height
        let width = bounds.width / CGFloat(count)
        return stride(from: from, to: count, by: 2)
            .map { CGRect(x: CGFloat($0) * width, y: 0, width: width, height: height) }
    }

    override open var intrinsicContentSize: CGSize {
        guard let font = font else { return .zero }
        let height = font.ascender + (-1 * font.descender)
        let spacing = CGFloat(symbolsCount - 1) * symbolSpacing
        let lettersWidth = font.maxWidth * CGFloat(symbolsCount)
        return CGSize(width: lettersWidth + spacing, height: height)
    }
}
