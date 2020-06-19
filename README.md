# OmegaBank

## Repository:
```
https://git.redmadrobot.com/n.zhukov/omegabank
```
### Branches:
```
master - release branch
develop - base branch for development
```
### Backend endpoint:
```
https://omegabank.mock-object.redmadserver.com/api/v1/
```
### Backend Repository:
```
https://git.redmadrobot.com/a.glezman/omegabank-mock
```
## Schemas:
```
Debug - development scheme
QA - quality assurance scheme
Release - release scheme
```
## Build assembly:
### QA
```
bundle exec fastlane ci
```
You can do this by the script running `fastlane/ci build commands/qa_build.command`