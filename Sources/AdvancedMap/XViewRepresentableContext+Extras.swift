
extension XViewRepresentableContext<AdvancedMap> {
  var shouldAnimateChanges: Bool {
    return !transaction.disablesAnimations && transaction.animation != nil
  }
}
