//
//  CodeInputWrapper.swift
//  CodeInput
//
//  Created by Denis Bogomolov on 04/03/2017.
//

import UIKit

open class CodeInputWrapper: UIView {
    open private(set) var textView: CodeInputView!
    @IBInspectable var symbolsCount: Int = 4
    @IBInspectable var symbolSpacing: CGFloat = 8

    @available(*, unavailable) init() {
        fatalError("This class designed to be used only in xib/storyboard, please use CodeInputView")
    }
    @available(*, unavailable) override init(frame: CGRect) {
        fatalError("This class designed to be used only in xib/storyboard, please use CodeInputView")
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        textView = createCodeInputView()
        addSubview(textView)
    }

    open func createCodeInputView() -> CodeInputView {
        return CodeInputView(symbolsCount, spacing: symbolSpacing)
    }

    override open var intrinsicContentSize: CGSize {
        return textView.intrinsicContentSize
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
        textView.frame = bounds
    }
}
