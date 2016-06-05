//
//  BWUtils.h
//  BestRepos
//
//  Created by Kamran Pirwani on 5/30/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @class BWUtils
 * @brief A class used to provide various utilities such as assertion handling, reading from files on disk, data validation/
 *        manipulation
 */
@interface BWUtils : NSObject

/**
 * A convenience assert method we have written which provides us with more information
 * @param condition The condition to assert
 * @param message   The error message to display
 * @param class     The class we are invoking the assert from
 * @param method    The method we are invoking the assert from
 * @note By sending everything through our own assertion method, we have great flexibility in making changes,
 *       such as turning this functionality off during release builds
 */
+ (void)assertCondition:(BOOL)condition
                message:(NSString *)message
                  class:(Class)clazz
                 method:(SEL)method;

/**
 * A convenience method to retrieve a dictionary from a json file
 * @return dictionary The json file represented as a dictionary
 */
+ (NSDictionary *)dictionaryFromJSONFileNamed:(NSString *)fileName;

/**
 * A convenience method to retrieve a dictionary from a plist file
 * @return dictionary The plist file represented as a dictionary
 */
+ (NSDictionary *)dictionaryFromPlistFileNamed:(NSString *)fileName;

/**
 * A convenience method used to abbreviate long numbers to their relevant shorthand versions
 * @return returns an abbreviated version of a number
 * @note For example, 1100 would be abbreviated to 1.1k
 */
+ (NSString *)abbreviateNumber:(long)number;

@end
