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

+ (NSDictionary *)dictionaryFromJSONFileNamed:(NSString *)fileName {
    NSString *resource = [[NSBundle mainBundle] pathForResource:fileName ofType:BWUtilsJsonSuffix];
    NSData *jsonData = [NSData dataWithContentsOfFile:resource];
    
    NSError *error = nil;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:kNilOptions
                                                                     error:&error];
    if (error) {
        [BWUtils assertCondition:NO
                         message:[error description]
                           class:[self class]
                          method:_cmd];
        return nil;
    }
    
    return jsonDictionary;
}

+ (NSDictionary *)dictionaryFromPlistFileNamed:(NSString *)fileName {
    NSString* path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    NSDictionary *plistDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    return plistDictionary;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSString *)abbreviateNumber:(long)number {
    NSString *abbreviatedNumber;
    if (number >= 1000) {
        NSArray *abbreviations = @[@"K", @"M", @"B"];
        
        for (long i = abbreviations.count - 1; i >= 0; i--) {
            // Convert array index to "1000", "1000000", etc
            int size = pow(10, (i+1) * 3);
            
            if (size <= number) {
                number = number/size;
                NSString *numberString = [self floatToString:number];
                
                // Add the letter for the abbreviation
                abbreviatedNumber = [NSString stringWithFormat:@"%@%@", numberString, [abbreviations objectAtIndex:i]];
            }
            
        }
    } else {
        abbreviatedNumber = [NSString stringWithFormat:@"%d", (int)number];
    }
    return abbreviatedNumber;
}

+ (NSString *) floatToString:(float) val {
    NSString *ret = [NSString stringWithFormat:@"%.1f", val];
    unichar c = [ret characterAtIndex:[ret length] - 1];
    
    while (c == 48) { // 0
        ret = [ret substringToIndex:[ret length] - 1];
        c = [ret characterAtIndex:[ret length] - 1];
        
        //After finding the "." we know that everything left is the decimal number, so get a substring excluding the "."
        if(c == 46) { // .
            ret = [ret substringToIndex:[ret length] - 1];
        }
    }
    
    return ret;
}

+ (id)validateObject:(id)objectToValidate ofClass:(Class)clazz withDefaultValue:(id)defaultValue {
    BOOL isCorrectClass = [objectToValidate isKindOfClass:clazz];
    if (isCorrectClass) {
        return objectToValidate;
    } else {
        return defaultValue;
    }
}

+ (NSString *)validateString:(NSString *)stringToValidate withDefaultValue:(NSString *)defaultValue {
    return [self validateObject:stringToValidate ofClass:[NSString class] withDefaultValue:defaultValue];
}

+ (NSNumber *)validateNumber:(NSNumber *)numberToValidate withDefaultValue:(NSNumber *)defaultValue {
    return [self validateObject:numberToValidate ofClass:[NSNumber class] withDefaultValue:defaultValue];
}


@end
