//
//  BWServiceLocator.m
//  BestRepos
//
//  Created by Kamran Pirwani on 5/30/16.
//  Copyright © 2016 Kamran Pirwani. All rights reserved.
//

#import "BWServiceLocator.h"
#import "BWUtils.h"

@interface BWServiceLocator()

@property(nonatomic, strong) NSMutableDictionary *services;

@end


@implementation BWServiceLocator

static BWServiceLocator *_singleton = nil;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleton = [[BWServiceLocator alloc] init];
    });
    return _singleton;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _services = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)addService:(id)service withProtocol:(Protocol *)protocol {
    [BWUtils assertCondition:service != nil
                     message:@"The service you are trying to add is nil"
                       class:[self class] method:_cmd];
    //exit early in production
    if (!service) {
        return;
    }
    NSString *protocolName = [self getStringFromProtocol:protocol];
    @synchronized(_services) {
        [_services setObject:service forKey:protocolName];
    }
}

- (id)getServiceWithProtocol:(Protocol *)protocol {
    NSString *protocolName = [self getStringFromProtocol:protocol];
    id service = nil;
    @synchronized(_services) {
        service = [_services objectForKey:protocolName];
    }
    
    [self validateService:service withProtocolName:protocolName];
    
    return service;
}

- (void)removeServiceWithProtocol:(Protocol *)protocol {
    NSString *protocolName = [self getStringFromProtocol:protocol];
    
    //check if the service exists before removing(primarily to catch developer mistakes)
    id service = [self getServiceWithProtocol:protocol];
    [self validateService:service withProtocolName:protocolName];
    
    @synchronized(_services) {
        [_services removeObjectForKey:protocolName];
    }
}

#pragma mark - Helpers

- (NSString *)getStringFromProtocol:(Protocol *)protocol {
    NSString *protocolName = NSStringFromProtocol(protocol);
    return protocolName;
}

- (void)validateService:(id)service withProtocolName:(NSString *)protocolName {
    if (!service) {
        NSString *errorString = [NSString stringWithFormat:@"There was no matching service for the protocol %@", protocolName];
        [BWUtils assertCondition:NO message:errorString class:[self class] method:_cmd];
    }
}

@end
