# OmegaBank

## Репозиторий:
```
https://github.com/RedMadRobot/omega-bank-ios
```
### Backend endpoint:
```
https://omegabank.mock-object.redmadserver.com/api/v1/
```
### Backend repository:
```
https://github.com/RedMadRobot/omega-bank-mock
```
## Схемы проекта:
```
Debug - development схема
QA - схема для QA
Release - release схема
```
## Сборка проекта:
### QA
```
bundle exec fastlane ci
```
Вы можете запустить этот процесс с помощью скрипта `fastlane/ci build commands/qa_build.command`

# Документация

1. [Структура проекта](Documentation/structure.md)
1. [Разделение на модули/таргеты](Documentation/modules.md)
1. [Сервис-ориентированная архитектура на уровне бизнес логики](Documentation/architecture.md)
1. [MVC - как подход с дочерними контроллерами, за что отвечают родительские контроллеры](Documentation/mvc.md)
1. [Навигация](Documentation/routing.md)