# nim-servercore

[![Build status](https://ci.appveyor.com/api/projects/status/dafe5co3497b3smx/branch/master?svg=true)](https://ci.appveyor.com/project/metasyn/nim-servercore/branch/master)

Building [Nim](https://nim-lang.org/) on `microsoft/windowsservercore`.


Usage:
  - `docker pull metasyn/nim-servercore`
  
Building:
  - `git clone`
  - `docker build -t myimage .`

Build args:
  - `TAG`: the tag to use when pull `microsoft/windowsservcore`, e.g. `1803`
  - `BRANCH`: the branch to use when checking out https://github.com/nim-lang/nim
  - e.g. `docker build -t myimage . --build-arg BRANCH=devel TAG=1803`
