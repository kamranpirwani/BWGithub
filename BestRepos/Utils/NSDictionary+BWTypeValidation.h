//
//  NSDictionary+BWTypeValidation.h
//  BestRepos
//
//  Created by Kamran Pirwani on 6/3/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @category BWTypeValidation
 * @brief A category used to validate types on dictionary objects and provide default values
 * so we don't need to scatter isKindOfClass checks all over the parser
 */
@interface NSDictionary (BWTypeValidation)

/**
 * A method used to retrieve a string from the dictionary, and return the default value if the key is not a string
 * @param key The key in the dictionary we want to retrieve
 * @param defaultValue the default value we want to return if the value does not correspond to an NSString
 * @return a string from either the dictionary or our default value
 */
- (NSString *)getStringForKey:(NSString *)key defaultValue:(NSString *)defaultValue;

/**
 * A method used to retrieve a number from the dictionary, and return the default value if the key is not a number
 * @param key The key in the dictionary we want to retrieve
 * @param defaultValue the default value we want to return if the value does not correspond to an NSNumber
 * @return a number from either the dictionary or our default value
 */
- (NSNumber *)getNumberForKey:(NSString *)key defaultValue:(NSNumber *)defaultValue;

/**
 * A method used to retrieve an array from the dictionary, and return the default value if the key is not an array
 * @param key The key in the dictionary we want to retrieve
 * @param defaultValue the default value we want to return if the value does not correspond to an NSArray
 * @return an array from either the dictionary or our default value
 */
- (NSArray *)getArrayForKey:(NSString *)key defaultValue:(NSArray *)defaultValue;

/**
 * A method used to retrieve a dictionary from the dictionary, and return the default value if the key is not a dictionary
 * @param key The key in the dictionary we want to retrieve
 * @param defaultValue the default value we want to return if the value does not correspond to an NSDictionary
 * @return a dictionary from either the dictionary or our default value
 */
- (NSDictionary *)getDictionaryForKey:(NSString *)key defaultValue:(NSDictionary *)defaultValue;

/**
 * A method used to retrieve a boolean from the dictionary, and return the default value if the key is not a boolean
 * @param key The key in the dictionary we want to retrieve
 * @param defaultValue the default value we want to return if the value does not correspond to an NSNumber
 * @return a boolean from either the dictionary or our default value
 */
- (BOOL)getBoolForKey:(NSString *)key defaultValue:(BOOL)defaultValue;

@end
