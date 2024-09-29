import Foundation

// Function that simulates a long-running background task
func updatePhotoGalleries() async {
    for i in 1...5 {
        print("Updating gallery with new photos: \(i) on thread: \(Thread.current)")
        try? await Task.sleep(nanoseconds: 1_000_000_000) // Simulate a delay of 1 second
    }
}

// Function that simulates fetching user data in the foreground
func fetchUserData() async {
    print("Fetching user data... on thread: \(Thread.current)")
    try? await Task.sleep(nanoseconds: 2_000_000_000) // Simulate fetching time of 2 seconds
    print("User data fetched! on thread: \(Thread.current)")
}

// Main async function that will run both tasks concurrently
func performConcurrentTasks() async {
    print("Starting tasks... on thread: \(Thread.current)")

    async let galleryTask = updatePhotoGalleries()
    async let userDataTask = fetchUserData()

    // Await both tasks to complete
    await galleryTask
    await userDataTask

    print("All tasks completed! on thread: \(Thread.current)")
}
func listPhotos(inGallery name: String) async throws -> [String] {
    try await Task.sleep(for: .seconds(2))
    print(["IMG001", "IMG99", "IMG0404"])
    return ["IMG001", "IMG99", "IMG0404"]
}

// Running the concurrent tasks in an asynchronous context
Task {
//    await performConcurrentTasks()
    try await listPhotos(inGallery: "")
    print("Huy")
}

