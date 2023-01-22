import Foundation
import SwiftUI

#if os(iOS) || os(tvOS)
public typealias XLegacyView = UIView
public typealias XEdgeInsets = UIEdgeInsets
public typealias XViewRepresentable = UIViewRepresentable
public typealias XViewRepresentableContext = UIViewRepresentableContext
public typealias XTapOrClickGestureRecognizer = UIGestureRecognizer
public typealias XLongTapOrClickGestureRecognizer = UIGestureRecognizer
#else
public typealias XLegacyView = NSView
public typealias XEdgeInsets = NSEdgeInsets
public typealias XViewRepresentable = NSViewRepresentable
public typealias XViewRepresentableContext = NSViewRepresentableContext
public typealias XTapOrClickGestureRecognizer = NSGestureRecognizer
public typealias XLongTapOrClickGestureRecognizer = NSPressGestureRecognizer
#endif
