@echo off
set /p version=Enter version number: 
docker tag registry.initialised.si/tools/jenkins-docker:%version% registry.initialised.si/tools/jenkins-docker:latest
docker push registry.initialised.si/tools/jenkins-docker:%version%
docker push registry.initialised.si/tools/jenkins-docker:latest
pause