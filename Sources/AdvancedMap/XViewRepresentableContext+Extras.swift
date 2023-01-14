
extension XViewRepresentableContext<AdvancedMap> {
  var shouldAnimateChanges: Bool {
    return !transaction.disablesAnimations
  }
}
