//
//  JInjector.m
//  JInjector
//
//  Created by Jeremy Tregunna on 2013-03-08.
//  Copyright (c) 2013 Jeremy Tregunna. All rights reserved.
//

#import "JInjector.h"

static NSMutableDictionary* objectCache = nil;

@interface JInjector ()
+ (NSMutableDictionary*)_objectCache;
@end

@implementation JInjector

+ (void)initialize
{
    if(self == [JInjector class])
        objectCache = [NSMutableDictionary dictionary];
}

+ (id)objectForClass:(Class)aClass
{
    NSString* className = NSStringFromClass(aClass);
    id<JInjectable> anObject = [objectCache objectForKey:className];
    if(anObject == nil)
    {
        anObject = [[aClass alloc] init];
        if([anObject respondsToSelector:@selector(awakeFromInitialization)])
            [anObject awakeFromInitialization];
        [objectCache setObject:anObject forKey:className];
    }
    
    return anObject;
}

+ (void)invalidateObject:(id<JInjectable>)anObject
{
    [objectCache removeObjectForKey:NSStringFromClass([anObject class])];
}

+ (void)invalidateAllObjects
{
    [objectCache removeAllObjects];
}

+ (NSMutableDictionary*)_objectCache
{
    return objectCache;
}

@end
