# Разделение на модули/таргеты

## LA: Layer Architecture ("Слоистая архитектура")

Выделяем 3 основных слоя:
1. Presentation 
1. Business Logic
1. Data Layer

* `Presentation` и `Business Logic` располагаются в отдельных папках, которые располагаются в директории: `OmegaBank/Sources`.
* `Data Layer` представлен отдельным модулем и выделен как `OmegaBankAPI` franework (Располагается в `OmegaBankFrameworks/OmegaBankAPI`).

## Presentation

UI слой. На нем располагается [MVC](Documentation/mvc.md).
Структура этого слоя:
```
Presentation
│
├── Common
│   │
│   ├── View
│   │   │
│   │   ├── Button
│   │   │
│   │   └── View
│   │
│   └── ViewController
│
├── Auth
│
├── Partner
│
└── Savings
    │
    ├── AddCard
    │
    ├── AddDeposit
    │
    └── ProductList
```

Где `Common` - папка содержащая вспомогательную функциональность для слоя `Presentation`. Причем она сгруппирована по принадлежности: `View`, `ViewController`, ...

Остальные папки: `Savings`, `Partner`, `Auth`, ... представляют отдельный сценарий. Каждый сценарий представляет собой отдельный [MVC](Documentation/mvc.md).

## Business Logic

Business Logic - Бизнес логика (Работа с данными)
Подробнее можно почитать [тут](Documentation/architecture.md)

## Data Layer

Data Layer - Источник данных. Слой отвечает за получение данных. Данные могут быть получены не только с API-клиента, но и с локальной базы: CoreData, Realm ...

Данный слой в OmegaBank-е представлен API-клиентом и выделен в отдельный таргет(framework): *OmegaBankAPI*.

## Дополнительные ссылки

1. [Архитектурный дизайн мобильных приложений](https://habr.com/ru/company/redmadrobot/blog/246551/)
1. [Архитектурный дизайн мобильных приложений: часть 2](https://habr.com/ru/company/redmadrobot/blog/251337/)