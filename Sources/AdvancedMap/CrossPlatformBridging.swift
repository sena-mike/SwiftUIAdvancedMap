import Foundation
import SwiftUI

#if os(iOS) || os(tvOS)
public typealias XEdgeInsets = UIEdgeInsets
public typealias XViewRepresentable = UIViewRepresentable
public typealias XViewRepresentableContext = UIViewRepresentableContext
public typealias XGestureRecognizer = UIGestureRecognizer
#else
public typealias XEdgeInsets = NSEdgeInsets
public typealias XViewRepresentable = NSViewRepresentable
public typealias XViewRepresentableContext = NSViewRepresentableContext
public typealias XGestureRecognizer = NSGestureRecognizer
#endif
