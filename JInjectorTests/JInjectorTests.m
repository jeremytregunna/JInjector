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
    @public
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
    DummyService* service = JInject(DummyService);
    STAssertNotNil(service, @"Should not get back a nil instance from JInject()");
}

- (void)testSeparateInjectors
{
    JInjector* injector1 = [JInjector defaultInjector];
    JInjector* injector2 = [[JInjector alloc] init];
    DummyService* service1 = injector1[[DummyService class]];
    DummyService* service2 = injector2[[DummyService class]];
    STAssertFalse(injector1 == injector2, @"Injectors should be different instances");
    STAssertFalse(service1 == service2, @"Should receive two different instances from two different injectors.");
}

- (void)testCachingInstance
{
    DummyService* service1 = JInject(DummyService);
    DummyService* service2 = JInject(DummyService);
    STAssertEqualObjects(service1, service2, @"Service 1 and service 2 should be the same object.");
    STAssertTrue([[JInjector defaultInjector].objectCache count] == 1, @"Should only have one instance");
}

- (void)testExplicitCaching
{
    DummyService* service = [[DummyService alloc] init];
    service->_works = NO;
    [[JInjector defaultInjector] setObject:service forClass:[DummyService class]];
    STAssertEqualObjects(service, JInject(DummyService), @"An explicitly supplied object must be the object returned");
}

- (void)testCachingWithSubscripting
{
    JInjector* injector = [JInjector defaultInjector];
    DummyService* service = [[DummyService alloc] init];
    service->_works = NO;
    injector[[DummyService class]] = service;
    STAssertTrue([injector.objectCache count] == 1, @"Should have one instance");
}

- (void)testRetrievingWithSubscripting
{
    JInjector* injector = [JInjector defaultInjector];
    DummyService* service = [[DummyService alloc] init];
    service->_works = NO;
    injector[[DummyService class]] = service;
    STAssertEqualObjects(injector[[DummyService class]], service, @"Should be the same objects");
}

- (void)testAwakeFromInitialization
{
    DummyService* service = JInject(DummyService);
    STAssertTrue([service works] == YES, @"Must call awakeFromInitialization");
}

- (void)testRemoveSpecificObject
{
    DummyService* service = JInject(DummyService);
    [[JInjector defaultInjector] invalidateObject:service];
    STAssertTrue([[JInjector defaultInjector].objectCache count] == 0, @"Should be empty");
}

- (void)testRemoveAllObjects
{
    DummyService* service1 = JInject(DummyService);
    DumberService* service2 = JInject(DumberService);
    STAssertNotNil(service1, @"service1 shouldn't be nil");
    STAssertNotNil(service2, @"service2 shouldn't be nil");
    STAssertTrue([[JInjector defaultInjector].objectCache count] == 2, @"Must have two instances");
    [[JInjector defaultInjector] invalidateAllObjects];
    STAssertTrue([[JInjector defaultInjector].objectCache count] == 0, @"Cache should be empty");
}

@end
