//
//  BWUtils.h
//  BestRepos
//
//  Created by Kamran Pirwani on 5/30/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BWUtils : NSObject

+ (void)assertCondition:(BOOL)condition
                message:(NSString *)message
                  class:(Class)clazz
                 method:(SEL)method;

+ (NSDictionary *)dictionaryFromJSONFileNamed:(NSString *)fileName;
+ (NSDictionary *)dictionaryFromPlistFileNamed:(NSString *)fileName;

+ (NSString *)abbreviateNumber:(long)number;

+ (NSString *)validateString:(NSString *)stringToValidate withDefaultValue:(NSString *)defaultValue;
+ (NSNumber *)validateNumber:(NSNumber *)numberToValidate withDefaultValue:(NSNumber *)defaultValue;

@end
