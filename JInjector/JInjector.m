//
//  JInjector.m
//  JInjector
//
//  Created by Jeremy Tregunna on 2013-03-08.
//  Copyright (c) 2013 Jeremy Tregunna. All rights reserved.
//

#import "JInjector.h"
#import <objc/runtime.h>

NSString* const JInjectorClassNotInjectableException = @"JInjectorClassNotInjectableException";

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
        if(class_conformsToProtocol(aClass, @protocol(JInjectable)))
        {
            anObject = [[aClass alloc] init];
            if([anObject respondsToSelector:@selector(awakeFromInitialization)])
                [anObject awakeFromInitialization];
            [self setObject:anObject forClass:aClass];
        }
        else
            @throw [NSException exceptionWithName:JInjectorClassNotInjectableException reason:NSLocalizedString(@"Class is not injectable", nil) userInfo:nil];
    }
    
    return anObject;
}

- (id)objectForKeyedSubscript:(id)aKey
{
    return [self objectForClass:[aKey class]];
}

- (void)setObject:(id<JInjectable>)anObject forClass:(Class)aClass
{
    [self.objectCache setObject:anObject forKey:NSStringFromClass(aClass)];
}

- (void)setObject:(id<JInjectable>)anObject forKeyedSubscript:(id)aKey
{
    [self setObject:anObject forClass:[aKey class]];
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
