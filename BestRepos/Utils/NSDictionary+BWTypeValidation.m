//
//  NSDictionary+BWTypeValidation.m
//  BestRepos
//
//  Created by Kamran Pirwani on 6/3/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import "NSDictionary+BWTypeValidation.h"

@implementation NSDictionary (BWTypeValidation)

- (NSString *)getStringForKey:(NSString *)key defaultValue:(NSString *)defaultValue {
    NSString *stringValue = [self getObjectForKey:key forClass:[NSString class] defaultValue:defaultValue];
    return stringValue;
}

- (NSNumber *)getNumberForKey:(NSString *)key defaultValue:(NSNumber *)defaultValue {
    NSNumber *numberValue = [self getObjectForKey:key forClass:[NSNumber class] defaultValue:defaultValue];
    return numberValue;
}

- (NSArray *)getArrayForKey:(NSString *)key defaultValue:(NSArray *)defaultValue {
    NSArray *arrayValue = [self getObjectForKey:key forClass:[NSArray class] defaultValue:defaultValue];
    return arrayValue;
}

- (NSDictionary *)getDictionaryForKey:(NSString *)key defaultValue:(NSDictionary *)defaultValue {
    NSDictionary *dictionaryValue = [self getObjectForKey:key forClass:[NSDictionary class] defaultValue:defaultValue];
    return dictionaryValue;
}

- (BOOL)getBoolForKey:(NSString *)key defaultValue:(BOOL)defaultValue {
    NSNumber *numberValue = [self getObjectForKey:key forClass:[NSNumber class] defaultValue:@(defaultValue)];
    return [numberValue boolValue];
}

- (id)getObjectForKey:(NSString *)key forClass:(Class)clazz defaultValue:(id)defaultValue {
    id object = [self valueForKey:key];
    if ([object isKindOfClass:clazz]) {
        return object;
    } else {
        return defaultValue;
    }
}

@end
