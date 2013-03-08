//
//  JInjector.h
//  JInjector
//
//  Created by Jeremy Tregunna on 2013-03-08.
//  Copyright (c) 2013 Jeremy Tregunna. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JInjectable;

/**
 * Returns an instance of a class.
 *
 * @param cls The class to create an instance of
 * @return An instance of the class.
 */
#define JInject(cls) [JInjector objectForClass:[cls class]]

@interface JInjector : NSObject

/**
 * Ask the injector for the instance representing the class.
 *
 * This method will optionally invoke an instance method awakeFromInitialization on your object, exactly once per instance after it has been allocated.
 *
 * @param aClass The class to use as the lookup key
 * @return An instance of the class aClass.
 */
+ (id)objectForClass:(Class)aClass;

/**
 * Remove a specific instance from the injector.
 *
 * This method is useful if you have modified the state of some object and wish to get a fresh instance. First remove the object, and then ask for a new one.
 *
 * @param anObject The object to remove
 */
+ (void)invalidateObject:(id<JInjectable>)anObject;

/**
 * Remove all instances of all classes from the injector.
 */
+ (void)invalidateAllObjects;

@end

@protocol JInjectable <NSObject>
@optional
- (void)awakeFromInitialization;
@end
