//
//  RHPathRequester.m
//  Rose-Hulman Mobile
//
//  Copyright 2012 Rose-Hulman Institute of Technology
// 
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "RHPathRequester.h"

@implementation RHPathRequester

@synthesize delegate = _delegate;
@synthesize persistantStoreCoordinator = _persistantStoreCoordinator;

- (id)initWithDelegate:(NSObject<RHPathRequesterDelegate> *)delegate
persistantStoreCoordinator:(NSPersistentStoreCoordinator *)persistantStoreCoordinator {
    self = [super init];
    
    if (self) {
        self.delegate = delegate;
        self.persistantStoreCoordinator = persistantStoreCoordinator;
    }
    
    return self;
}

- (RHPath *)pathFromJSONResponse:(NSDictionary *)response {
    return nil;
}

@end
