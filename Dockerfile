#escape=`
FROM microsoft/windowsservercore

ENV chocolateyUseWindowsCompression false

RUN powershell -Command `
    iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')); `
    choco feature disable --name showDownloadProgress

RUN choco install git -y

RUN git clone https://github.com/nim-lang/Nim.git
RUN cd Nim; `
    build64.bat; `
    cd ..; `
    bin\nim c koch; `
    koch boot -d:release; `
    koch tools
