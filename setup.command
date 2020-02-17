#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR/Source"

# Устанавливаем ruby зависимости.
# Cocoapods and Fastlane
bundle install

# Обновляем репозиторий подов.
bundle exec pod repo update

# Запускаем установку подов.
bundle exec pod install

# Путь до файла с паролями. Из него fastlane автоматически возмет данные.
secrets="./fastlane/.env"
example_secrets="./fastlane/env-example"

if [ ! -f "${secrets}" ]; then
  cp "${example_secrets}" "${secrets}"
  echo ""
  echo "--------------------------------------------------------------------------------"
  echo "Created ${secrets}. Please add your keys to it."
  echo "--------------------------------------------------------------------------------"
fi