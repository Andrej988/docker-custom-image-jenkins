@echo off
set /p version=Enter version number: 
docker build -t=registry.initialised.si/tools/jenkins-docker:%version% .
pause