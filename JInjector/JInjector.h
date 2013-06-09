//
//  JInjector.h
//  JInjector
//
//  Created by Jeremy Tregunna on 2013-03-08.
//  Copyright (c) 2013 Jeremy Tregunna. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const JInjectorClassNotInjectableException;

@protocol JInjectable;

/**
 * Return an instance of a class from the default injector.
 *
 * @param cls The class to create an instance of.
 * @return An instance of the class.
 */
#define JInject(cls) [[JInjector defaultInjector] objectForClass:[cls class]]

@interface JInjector : NSObject

/**
 * Returns the default injector.
 *
 * @return The default injector.
 */
+ (instancetype)defaultInjector;

/**
 * Ask the injector for the instance representing the class.
 *
 * This method will optionally invoke an instance method awakeFromInitialization on your object, exactly once per instance after it has been allocated.
 *
 * @param aClass The class to use as the lookup key
 * @return An instance of the class aClass.
 */
- (id)objectForClass:(Class)aClass;

/**
 * Ask the injector for the instance representing the class.
 *
 * This method will optionally invoke an instance method awakeFromInitialization on your object, exactly once per instance after it has been allocated.
 *
 * @param aKey The class to use as the lookup key
 * @return An instance of the class aClass.
 */
- (id)objectForKeyedSubscript:(id)aKey;

/**
 * Caches an object into the injector for a given class.
 *
 * This method will overwrite any previous cached object.
 * @param anObject The object to cache.
 * @param aClass The class to associate the object with.
 */
- (void)setObject:(id<JInjectable>)anObject forClass:(Class)aClass;

/**
 * Caches an object into the injector for a given class.
 *
 * This method will overwrite any previous cached object.
 * @param anObject The object to cache.
 * @param aKey The class to associate the object with.
 */
- (void)setObject:(id<JInjectable>)anObject forKeyedSubscript:(id)aKey;

/**
 * Remove a specific instance from the injector.
 *
 * This method is useful if you have modified the state of some object and wish to get a fresh instance. First remove the object, and then ask for a new one.
 *
 * @param anObject The object to remove
 */
- (void)invalidateObject:(id<JInjectable>)anObject;

/**
 * Remove all instances of all classes from the injector.
 */
- (void)invalidateAllObjects;

@end

@protocol JInjectable <NSObject>
@optional
/**
 * Perform any initialization that an instance may require.
 *
 * 
 */
- (void)awakeFromInitialization;
@end
