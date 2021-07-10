# LoadingState

A generic type to describe loading states.

```swift
enum LoadingState<Success, Failure: Error> {
    
    case idle
    
    case inProgress
    
    case success(Success)
    
    case failure(Failure)
}
```

## Installation

LoadingState is distributed using [Swift Package Manager](https://swift.org/package-manager). To install it into a project, simply add it as a dependency within your Package.swift manifest:

```swift
let package = Package(
    ...
    dependencies: [
        .package(url: "https://github.com/lucamegh/LoadingState", from: "1.0.0")
    ],
    ...
)
```

## Usage

Use `LoadingState` to simplify your SwiftUI views:

```swift
class ArticleLoadingViewModel: ObservableObject {

    @Published private(set) var state: LoadingState<Article, Error> = .idle

    ...

    func load() {
        articleLoader.load(id: 1234) { [weak self] result in
            self?.state = .finished(result)
        }
    }
}

struct ArticleLoadingView: View {

    @ObservedObject var viewModel: ArticleLoadingViewModel

    var body: some View {
        switch viewModel.state {
        case .idle, .inProgress:
            LoadingView(message: "Loading...")
        case .success(let article):
            let viewModel = ArticleViewModel(article: article)
            ArticleView(viewModel: viewModel)
        case .failure(let error):
            ErrorView(error: error)
        }
    }
}
```

As you can see, it is possible to create loading states from instances of `Result` using the `finished(_ result:)` static method or `init(_ result:)` initializer.

Let's see how to leverage `ArticleLoadingViewModel` in a UIKit environment using [Portal](https://github.com/lucamegh/Portal):

```swift
class ArticleLoadingViewController: ContainerViewController {

    private let viewModel: ArticleLoadingViewModel

    ...

    override func loadView() {
        super.loadView()
        cancellable = viewModel.$state.sink { [unowned self] state in
            switch state {
            case .idle, .inProgress:
                content = LoadingViewController(message: "Loading...")
            case .success(let article):
                let viewModel = ArticleViewModel(article: article)
                content = ArticleViewController(viewModel: viewModel)
            case .failure(let error):
                content = ErrorViewController(error: error)
            }
        }
    }
}
```

Loading states expose a  `map(_ transform:)` operator that returns a new loading state, mapping any success value using the given transformation.

```swift
class ArticleLoadingViewModel: ObservableObject {

    @Published private(set) var state: LoadingState<ArticleViewModel, Error> = .idle

    ...

    func load() {
        articleLoader.load(id: 1234) { [weak self] (result: Result<Article, Error>) in
            self?.state = LoadingState(result).map(ArticleViewModel.init)
        }
    }
}
```

You can also take advantage of loading states to enhance your Combine pipelines like this:

```swift
func image(at url: URL, imageDownloader: ImageDownloader = .shared) -> AnyPublisher<LoadingState<UIImage, Error>, Never> {
    let subject = CurrentValueSubject<LoadingState<UIImage, Error>, Never>(.inProgress)
    imageDownloader.shared.downloadImage(at: url) { result in
        subject.value = .finished(result)
    }
    return subject
        .handleEvents(receiveSubscription: { _ in subject.value = .inProgress })
        .eraseToAnyPublisher()
}
```
