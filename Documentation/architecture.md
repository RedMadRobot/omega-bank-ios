# Сервис-ориентированная архитектура на уровне бизнес логики

На сервисном уровне мы придерживаемся принципов [SOA](https://ru.wikipedia.org/wiki/Сервис-ориентированная_архитектура).
Сервисы - объекты которые работают с бизнес-сущностями. Каждый сервис работает как правило с одним типом сущности. 

```swift
final class ServiceLayer {
    static let shared = ServiceLayer()

    /// Сервис работы с картами
    private(set) lazy var cardListService = CardListServiceImpl(apiClient: apiClient)

    /// Сервис работы с депозитами
    private(set) lazy var depositListService = DepositListImpl(apiClient: apiClient)

}
```

Можно вводить дополнительные сервисы которые не работают с бизнес-сущностями, а реализуют какую-то бизнес логику, например синхронизацию данных или хранение настроек.

## Реализация скрыта протоколом

```swift
protocol CardListService {
    
    /// Обработчик ответа на загрузку списка карт
    typealias CardListHandler = ResultHandler<[Card]>

    /// Загрузка списка карт
    @discardableResult
    func load(completion: @escaping CardListHandler) -> Progress
}

```

## Собственно реализация

```swift
final class CardListServiceImpl: APIService, CardListService {
    
    @discardableResult
    func load(completion: @escaping CardListHandler) -> Progress {
        apiClient.request(CardsEndpoint(), completionHandler: completion)
    }

}
```