# Навигация

Основные моменты:

* Не используем [UIStoryboard](https://developer.apple.com/documentation/uikit/uistoryboard) и [UIStoryboardSegue](https://developer.apple.com/documentation/uikit/uistoryboardsegue)
* Переходы вызываются в контроллерах с помощью [show(_:sender:)](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621377-show) и [present(_:animated:completion:)](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621380-present)
* Mожно создавать классы-фабрики, которые создают и конфигурируют контроллер, который требуется показать:
```swift

final class ViewControllerFactory {

    static func makeBookListViewController() -> UIViewController {
        let childVC = BookListViewController()
        let bottomView = BottomView()
        let containerVC = BookListContainerController(content: childVC, bottomView: bottomView)
        bottomView.onNext = { [unowned childVC] in
            childVC.onNext()
        }
        bottomView.onHelp = { [unowned containerVC] in
            containerVC.showSmth()
        }
        return containerVC
    }

}
```
* На некоторых проектах используется подход с роутерами, когда код навигации выносится из контроллера в отдельный класс:
```swift
/// Базовый роутер. Создается для каждого вью контроллера отдельно.
class Router<T: UIViewController> {
    
    /// Вью контроллер, с которого осуществляются переходы
    weak var viewController: T?
    
    /// Инициализация роутера
    /// - Parameter source: вью контроллер, с которого осуществляются переходы
    init(_ source: T) {
        viewController = source
    }
    
}
```

```swift
final class SomeViewController: ViewController {

    private lazy var router = SomeRouter(self)

    @IBAction private func showNext(_ sender: Any) {
        let viewModel = SomeViewModel()
        router.showNext(viewModel: viewModel)
    }

}
```

```swift
final class SomeRouter: Router<SomeViewController> {
    
    func showNext(viewModel: SomeViewModel) {
        let vc = NextViewController.make(viewModel: viewModel)
        viewController?.show(vc, sender: nil)
    }
    
}
```