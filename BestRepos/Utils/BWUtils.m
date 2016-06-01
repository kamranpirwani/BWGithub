//
//  BWUtils.m
//  BestRepos
//
//  Created by Kamran Pirwani on 5/30/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import "BWUtils.h"

static NSString *BWUtilsJsonSuffix = @"json";

@implementation BWUtils

+ (void)assertCondition:(BOOL)condition
                message:(NSString *)message
                  class:(Class)clazz
                 method:(SEL)method {
    if (condition == NO) {
        NSString *className = NSStringFromClass(clazz);
        NSString *methodName = NSStringFromSelector(method);
        
        NSString *errorString = [NSString stringWithFormat:@"%@ - %@:\n%@", className, methodName, message];
        NSAssert(condition, errorString);
    }
}

+ (void)logError:(NSString *)error {
    NSLog(@"%@", error);
}

+ (NSDictionary *)dictionaryFromJSONFileNamed:(NSString *)fileName {
    NSString *resource = [[NSBundle mainBundle] pathForResource:fileName ofType:BWUtilsJsonSuffix];
    NSData *jsonData = [NSData dataWithContentsOfFile:resource];
    
    NSError *error = nil;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:kNilOptions
                                                                     error:&error];
    if (error) {
        [self logError:@"Error parsing json file"];
        return nil;
    }
    
    return jsonDictionary;
}

+ (NSDictionary *)dictionaryFromPlistFileNamed:(NSString *)fileName {
    NSString* path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    NSDictionary *plistDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    return plistDictionary;
}

@end
