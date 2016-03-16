/**
 *	@file BxAppearance.m
 *	@namespace iBXVcl
 *
 *	@details реализация патерна appearance
 *	@date 06.04.2014
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxAppearance.h"

@interface BxAppearance ()

@property (strong, nonatomic) Class mainClass;
@property (strong, nonatomic) NSMutableArray *invocations;

@end

static NSMutableDictionary *dictionaryOfClasses = nil;

@implementation BxAppearance

// this method return the same object instance for each different class
+ (id) appearanceForClass:(Class)thisClass
{
    // create the dictionary if not exists
    // use a dispatch to avoid problems in case of concurrent calls
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!dictionaryOfClasses)
            dictionaryOfClasses = [[NSMutableDictionary alloc]init];
    });
    
    
    
    if (![dictionaryOfClasses objectForKey:NSStringFromClass(thisClass)])
    {
        id thisAppearance = [[self alloc]initWithClass:thisClass];
        [dictionaryOfClasses setObject:thisAppearance forKey:NSStringFromClass(thisClass)];
        return thisAppearance;
    }
    else
        return [dictionaryOfClasses objectForKey:NSStringFromClass(thisClass)];
}

- (id)initWithClass:(Class)thisClass
{
    self = [self initPrivate];
    if (self) {
        self.mainClass = thisClass;
        self.invocations = [NSMutableArray array];
    }
    return self;
}

- (id)init
{
    [NSException exceptionWithName:@"InvalidOperation" reason:@"Cannot invoke init. Use appearanceForClass: method" userInfo:nil];
    return nil;
}

- (id)initPrivate
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void) forwardInvocation:(NSInvocation *)anInvocation;
{
    // tell the invocation to retain arguments
    [anInvocation retainArguments];
    
    // add the invocation to the array
    [self.invocations addObject:anInvocation];
}

- (NSMethodSignature *) methodSignatureForSelector:(SEL)aSelector {
    return [self.mainClass instanceMethodSignatureForSelector:aSelector];
}

- (void) startForwarding:(id)sender
{
    for (NSInvocation *invocation in self.invocations) {
        [invocation setTarget:sender];
        [invocation invoke];
    }
}

@end
