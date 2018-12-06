//
//  ExampleTextTypingView.swift
//  SelfSizingTextInputAccessoryViewExample
//
//  Created by Henry on 2018/12/06.
//  Copyright © 2018 Henry. All rights reserved.
//

import Foundation
import UIKit

class ExampleTextTypingView: UIInputView, UITextViewDelegate {
    var maximumHeight: CGFloat = 100 {
        didSet {
            adjustLayout()
        }
    }

    ////

    private let textView = UITextView()
    private weak var heightConstraint: NSLayoutConstraint?

    private func install() {
        allowsSelfSizing = true
        addSubview(textView)
        translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        let hc = heightAnchor.constraint(equalToConstant: 0)
        heightConstraint = hc
        NSLayoutConstraint.activate([
            hc,
            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor),
            // Constrain text-view width to be same with container's width.
            textView.widthAnchor.constraint(equalTo: widthAnchor),
            ])
        textView.delegate = self
        // It's better to make paddings with `contentInset` because unlike `textContainerInset`
        // sometimes gets ignored, scrolling algorithm always respect this paddings.
        textView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        // If we have zero text container inset, text sometimes vibrates
        // by the caret movement over the lines.
        // I don't know why. I just know that giving a little space for text-container inset fixes that.
        // I suspect some bugs in layout code of `UITextView`.
        textView.textContainerInset = UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)

        // Now text-view is empty. Current size is minimum size.
        adjustLayout()
    }
    private func adjustLayout() {
        // A text-container defines available space for text layout.
        // As width of the view has been constrained, width of the text container
        // has been fixed, only height becomes maximum value.
        // After text laid out on the text-container space, it's layout bounding
        // can be obtained by calling `usedRect` method.
        let m = textView.layoutManager
        let b = m.usedRect(for: textView.textContainer)
        let h = b.height + textView.contentInset.height + textView.textContainerInset.height
        let h1 = min(maximumHeight, h)
        let h2 = ceil(h1) // I don't want subpoint layout.
        heightConstraint?.constant = h2
        // Very important to prevent unexpected over-scrolling of text content.
        // Though this disables animation, but such animations are usually undesired.
        layoutIfNeeded()
    }

    ////

    override init(frame: CGRect, inputViewStyle: UIInputView.Style) {
        super.init(frame: frame, inputViewStyle: inputViewStyle)
        install()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        install()
    }
    override var translatesAutoresizingMaskIntoConstraints: Bool {
        willSet {
            precondition(newValue == false, "This view can be used only with Auto Layout system. Otherwise, this won't work properly.")
        }
    }

    ////

    func textViewDidChange(_ textView: UITextView) {
        adjustLayout()
    }
    func textViewDidChangeSelection(_ textView: UITextView) {
        adjustLayout()
    }
}

private extension UIEdgeInsets {
    var height: CGFloat {
        return top + bottom
    }
}
