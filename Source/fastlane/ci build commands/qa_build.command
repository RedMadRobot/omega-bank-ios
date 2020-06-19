# найдем директорию, в которой находится проект
cd "$( dirname "${BASH_SOURCE[0]}" )"
DIR="$( cd .. && cd .. && pwd )" 

# перейдем в нее
cd "$DIR"

# запускаем сборку на CI
bundle exec fastlane ci
