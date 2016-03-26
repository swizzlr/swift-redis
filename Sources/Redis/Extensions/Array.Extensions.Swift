extension Array {
	public func quoteItems() -> Array<String> {
		let result: [String] = self.flatMap({ String("\"\($0)\"") })
		return result
	}
}
