#escape=`
ARG TAG=latest
FROM microsoft/windowsservercore:$TAG
ARG BRANCH=master

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV chocolateyUseWindowsCompression false

RUN iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')); `
    choco feature disable --name showDownloadProgress

RUN choco install git mingw -y

RUN git clone https://github.com/nim-lang/Nim.git `
    cd Nim; `
    git checkout $BRANCH; `
    git clone --depth 1 https://github.com/nim-lang/csources.git; `
    cd csources; `
    Start-Process ".\build64.bat"; `
    cd .. ; `
    dir; dir bin; `
    bin\nim c koch; `
    Start-Process "koch boot -d:release"; `
    Start-Process "koch tools"
