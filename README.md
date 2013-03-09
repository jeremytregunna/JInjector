# JInjector
Copyright © 2013, Jeremy Tregunna, All Rights Reserved.

JInjector is an iOS and OS X dependency injection library. It is extremely light weight, and may not suit all purposes. It is not as flexible as some other IoC libraries, but this one suits my needs quite handily, YMMV.

This project uses Automatic Reference Counting (ARC), but does not use any weak references. As such, it will be safe to run with iOS deployment targets as low as the minimum Xcode gives you these days, 4.3.3. It will work on any 4.x iOS release however. This will also work on OS X 10.7.0 and higher.

## Installation

How you get this library into your build setup is your business. You can use git submodules, copy files, whatever you like. Should you choose to add our project file to your workspace, you can merely depend on the resulting library or framework product, and that should be all you need.

## Usage

Who needs a demo app? Look at the unit tests, they show you how to use it too.

## License

The terms under which use and distribution of this library is governed may be found in the [LICENSE](https://github.com/jeremytregunna/JInjector/blob/master/LICENSE) file.

## Contributing

If you think you can help out, with code, documentation, whatever. Let me know. Preferably, use a pull request and attach test code along with your code. Please also see [this document](https://github.com/jeremytregunna/JInjector/blob/master/CONTRIBUTING.md) for information on our contributors agreement.