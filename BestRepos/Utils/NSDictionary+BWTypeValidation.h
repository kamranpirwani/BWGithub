//
//  NSDictionary+BWTypeValidation.h
//  BestRepos
//
//  Created by Kamran Pirwani on 6/3/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (BWTypeValidation)

- (NSString *)getStringForKey:(NSString *)key defaultValue:(NSString *)defaultValue;
- (NSNumber *)getNumberForKey:(NSString *)key defaultValue:(NSNumber *)defaultValue;
- (NSArray *)getArrayForKey:(NSString *)key defaultValue:(NSArray *)defaultValue;
- (NSDictionary *)getDictionaryForKey:(NSString *)key defaultValue:(NSDictionary *)defaultValue;
- (BOOL)getBoolForKey:(NSString *)key defaultValue:(BOOL)defaultValue;

@end
