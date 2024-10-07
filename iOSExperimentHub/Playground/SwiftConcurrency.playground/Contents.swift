import Foundation

enum CustomError: Error {
    case myError
}

func getStudentName() async throws -> String {
    try await Task.sleep(nanoseconds: 1_000_000_000)
    return "Huy Pham"
}

func getClasses() async throws -> [String] {
    throw CustomError.myError
}

func getScores() async throws -> [Int] {
    try await Task.sleep(nanoseconds: 1_000_000_000)
    return [10, 9, 7, 8, 9, 9]
}

func printStudentInfo() async  {
    do {
        print("\(Date()): get name")
        async let name = getStudentName()
        print("\(Date()): get classes")
        async let classes = getClasses()
        print("\(Date()): get scores")
        async let scores = getScores()
        
        print("\(Date()): Creating ....")
        let result = try await (name, classes, scores)
        print("\(Date()): \(result.0) - \(result.1) - \(result.2)")
    } catch {
        print("Error: \(error)")
    }
}

Task {
    await printStudentInfo()
}
