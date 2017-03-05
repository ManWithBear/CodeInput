//
//  CodeInputWrapper.swift
//  CodeInput
//
//  Created by Denis Bogomolov on 04/03/2017.
//

import UIKit

open class CodeInputWrapper: UIView {
    open private(set) var textView: CodeInputView!

    private init() {
        fatalError("This class designed to be used only in xib/storyboard, please use CodeInputView")
    }
    private override init(frame: CGRect) {
        fatalError("This class designed to be used only in xib/storyboard, please use CodeInputView")
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        textView = createCodeInputView()
        addSubview(textView)
    }

    open func createCodeInputView() -> CodeInputView {
        return CodeInputView(4, spacing: 20)
    }

    override open var intrinsicContentSize: CGSize {
        return textView.intrinsicContentSize
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
        textView.frame = bounds
    }
}
