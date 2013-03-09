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
@property (nonatomic, strong) NSMutableDictionary* objectCache;
@end

@implementation JInjectorTests

- (void)testCreatingInstance
{
    DummyService* service = JInject(0, DummyService);
    STAssertNotNil(service, @"Should not get back a nil instance from JInject()");
}

- (void)testCachingInstance
{
    DummyService* service1 = JInject(0, DummyService);
    DummyService* service2 = JInject(0, DummyService);
    STAssertEqualObjects(service1, service2, @"Service 1 and service 2 should be the same object.");
    STAssertTrue([[JInjector defaultInjector].objectCache count] == 1, @"Should only have one instance");
}

- (void)testAwakeFromInitialization
{
    DummyService* service = JInject(0, DummyService);
    STAssertTrue([service works] == YES, @"Must call awakeFromInitialization");
}

- (void)testRemoveSpecificObject
{
    DummyService* service = JInject(0, DummyService);
    [[JInjector defaultInjector] invalidateObject:service];
    STAssertTrue([[JInjector defaultInjector].objectCache count] == 0, @"Should be empty");
}

- (void)testRemoveAllObjects
{
    DummyService* service1 = JInject(0, DummyService);
    DumberService* service2 = JInject(0, DumberService);
    STAssertNotNil(service1, @"service1 shouldn't be nil");
    STAssertNotNil(service2, @"service2 shouldn't be nil");
    STAssertTrue([[JInjector defaultInjector].objectCache count] == 2, @"Must have two instances");
    [[JInjector defaultInjector] invalidateAllObjects];
    STAssertTrue([[JInjector defaultInjector].objectCache count] == 0, @"Cache should be empty");
}

@end
