# JInjector
Copyright © 2013, Jeremy Tregunna, All Rights Reserved.

JInjector is an iOS and OS X dependency injection library. It is extremely light weight, and may not suit all purposes. It is not as flexible as some other IoC libraries, but this one suits my needs quite handily, YMMV.

This project uses Automatic Reference Counting (ARC), but does not use any weak references. As such, it will be safe to run with iOS deployment targets as low as the minimum Xcode gives you these days, 4.3.3. It will work on any 4.x iOS release however. This will also work on OS X 10.7.0 and higher.

## Installation

How you get this library into your build setup is your business. You can use git submodules, copy files, whatever you like. Should you choose to add our project file to your workspace, you can merely depend on the resulting library or framework product, and that should be all you need.

## Usage

Basically, there are two things you'll be most interested in: Injecting an instance into your classes, and supplying a pre-initialized instance for others to inject into their classes.

To get an instance of a class, it's really simple:

```objc
Car* car = JInject(Car);
```

You'll most likely use `JInject()` to give some property an instance, but this instance will be shared throughout the injector. `JInject()` uses a default injector, though you can create others by calling `[[JInjector alloc] init]` as you would expect. Instances are not cached between injectors.

To set a default value for a paritcular class, you can do something like this:

```objc
APIClient* client = [[APIClient alloc] initWithAccessToken:@"abcdef1234567890"];
[[JInjector defaultInjector] setObject:client forClass:[APIClient class]];
```

Then subsequent calls to query an instance will return that particular instance, and not create a new one. Any call to `-[JInjector setObject:forClass:]` will replace any previous instance that had been cached in the injector.

One thing worth mentioning, there's an optional protocol method on `JInjectable` (which your objects you want to be able to inject must conform to) which will be fired if JInjector has to create a new instance of your class. This method you can optionally implement has the signature:

```objc
- (void)awakeFromInitialization;
```

You will not be able to pass any parameters into this method, this is a limitation of our framework. In cases where you might, consider looking at the `APIClient` example above for a solution.

Both of the operations above support object subscripting like you'd find with arrays and dictionaries in modern Objective-C. They work just like described above, but you can use them like this:

```objc
JInjector* injector = [JInjector defaultInjector];
// Setting an object
injector[[APIClient class]] = [[APIClient alloc] initWithAccessToken:@"abcdef1234567890"];
// Getting an instance
APIClient* client = injector[[APIClient class]];
```

Want a comprehensive example of how to use this library? Look at the unit tests, they show all cases.

## License

The terms under which use and distribution of this library is governed may be found in the [LICENSE](https://github.com/jeremytregunna/JInjector/blob/master/LICENSE) file.

## Contributing

If you think you can help out, with code, documentation, whatever. Let me know. Preferably, use a pull request and attach test code along with your code. Please also see [this document](https://github.com/jeremytregunna/JInjector/blob/master/CONTRIBUTING.md) for information on our contributors agreement.
