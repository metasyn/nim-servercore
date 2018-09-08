#escape=`
ARG TAG=latest
FROM microsoft/windowsservercore:$TAG
ARG BRANCH=master

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV chocolateyUseWindowsCompression false

RUN iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')); `
    choco feature disable --name showDownloadProgress

RUN choco install git 7zip mingw -y

RUN git clone https://github.com/nim-lang/Nim.git; `
    cd Nim; `
    git checkout $BRANCH; `
    git clone --depth 1 https://github.com/nim-lang/csources.git; `
    cd csources; `
    .\build64.bat; `
    cd .. ; `
    bin\nim.exe c koch; `
    .\koch.exe boot -d:release; `
    .\koch.exe tools

RUN cd C:\Nim\bin; `
    Invoke-WebRequest -UseBasicParsing https://nim-lang.org/download/dlls.zip -O dlls.zip; `
    7z x dlls.zip; `
    rm dlls.zip

COPY Set-Path.ps1 .
RUN .\Set-Path.ps1 -NewLocation "C:\Nim\bin"; `
    .\Set-Path.ps1 -NewLocation "$env:USERPROFILE\.nimble\bin";

ENTRYPOINT powershell.exe
