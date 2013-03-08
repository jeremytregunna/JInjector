//
//  JInjectorTests.m
//  JInjectorTests
//
//  Created by Jeremy Tregunna on 2013-03-08.
//  Copyright (c) 2013 Jeremy Tregunna. All rights reserved.
//

#import "JInjectorTests.h"
#import "JInjector.h"

@interface DummyService : NSObject <JInjectable>
- (BOOL)works;
@end
@implementation DummyService
{
    BOOL _works;
}
- (void)awakeFromInitialization
{
    _works = YES;
}
- (BOOL)works
{
    return _works;
}
@end

@interface DumberService : NSObject <JInjectable>
@end
@implementation DumberService
@end

@interface JInjector (PrivateMethods)
+ (NSMutableDictionary*)_objectCache;
@end

@implementation JInjectorTests

- (void)testCreatingInstance
{
    DummyService* service = JInject(DummyService);
    STAssertNotNil(service, @"Should not get back a nil instance from JInject()");
}

- (void)testCachingInstance
{
    DummyService* service1 = JInject(DummyService);
    DummyService* service2 = JInject(DummyService);
    STAssertEqualObjects(service1, service2, @"Service 1 and service 2 should be the same object.");
    STAssertTrue([[JInjector _objectCache] count] == 1, @"Should only have one instance");
}

- (void)testAwakeFromInitialization
{
    DummyService* service = JInject(DummyService);
    STAssertTrue([service works] == YES, @"Must call awakeFromInitialization");
}

- (void)testRemoveSpecificObject
{
    DummyService* service = JInject(DummyService);
    [JInjector invalidateObject:service];
    STAssertTrue([[JInjector _objectCache] count] == 0, @"Should be empty");
}

- (void)testRemoveAllObjects
{
    DummyService* service1 = JInject(DummyService);
    DumberService* service2 = JInject(DumberService);
    STAssertNotNil(service1, @"service1 shouldn't be nil");
    STAssertNotNil(service2, @"service2 shouldn't be nil");
    STAssertTrue([[JInjector _objectCache] count] == 2, @"Must have two instances");
    [JInjector invalidateAllObjects];
    STAssertTrue([[JInjector _objectCache] count] == 0, @"Cache should be empty");
}

@end
