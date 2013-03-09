//
//  JInjector.m
//  JInjector
//
//  Created by Jeremy Tregunna on 2013-03-08.
//  Copyright (c) 2013 Jeremy Tregunna. All rights reserved.
//

#import "JInjector.h"

@interface JInjector ()
@property (nonatomic, strong) NSMutableDictionary* objectCache;
@end

@implementation JInjector

+ (instancetype)defaultInjector
{
    static id shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (id)init
{
    if((self = [super init]))
        self.objectCache = [NSMutableDictionary dictionary];
    return self;
}

- (id)objectForClass:(Class)aClass
{
    NSString* className = NSStringFromClass(aClass);
    id<JInjectable> anObject = [self.objectCache objectForKey:className];
    if(anObject == nil)
    {
        anObject = [[aClass alloc] init];
        if([anObject respondsToSelector:@selector(awakeFromInitialization)])
            [anObject awakeFromInitialization];
        [self setObject:anObject forClass:aClass];
    }
    
    return anObject;
}

- (void)setObject:(id<JInjectable>)anObject forClass:(Class)aClass
{
    [self.objectCache setObject:anObject forKey:NSStringFromClass(aClass)];
}

- (void)invalidateObject:(id<JInjectable>)anObject
{
    [self.objectCache removeObjectForKey:NSStringFromClass([anObject class])];
}

- (void)invalidateAllObjects
{
    [self.objectCache removeAllObjects];
}

@end
