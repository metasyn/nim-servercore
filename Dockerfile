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
    .\build64.bat; `
    cd .. ; `
    bin\nim.exe c koch; `
    .\koch.exe boot -d:release; `
    .\koch.exe tools

COPY Set-Path.ps1 .
RUN .\Set-Path.ps1 -NewLocation "C:\Nim\bin"

RUN choco install openssl.light -y

ENTRYPOINT powershell.exe
>>>>>>> edc399cd38ac948e2c8aef90046b3620af82ec02
