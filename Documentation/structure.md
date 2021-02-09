# Структура проекта

Структура проекта является отражением архитектурного подхода в разработке.
Проекты строятся на основе [Layer Architecture](Documentation/modules.md), где Layer Architecture — слоистая архитектура, в нашем случае включающая следующие части:
1. Business Logic
1. Presentation
1. Data Layer

## Cтруктура на примере OmegaBank

```
├── README.md
│   ...
│
├── OmegaBank
│   │
│   ├──Sources
│   │   │
│   │   └── Application
│   │   │   │
│   │   │   └── AppDelegate.swift
│   │   │
│   │   ├── Business Logic
│   │   │
│   │   ├── Models
│   │   │
│   │   ├── Presentation
│   │   │
│   │   └── Utility
│   │
│   ├── Supporting Files
│   │   │
│   │   ├── Info.plist
│   │   │
│   │   └── OmegaBank.entitlements
│   │   ...
│   │
│   └── Resources
│       │
│       └── Assets.xcassets
│       ...
│
├── OmegaBankTests
│
├── OmegaBankUITests
│ 
├── OmegaBankFrameworks
│   │ 
│   ├── OmegaBankAPI
│   │ 
│   └── OmegaBankAPITests
│ 
├── Pods
│ 
└── fastlane