//
//  RHRestHandler.m
//  RHIT Mobile Campus Directory
//
//  Copyright 2011 Rose-Hulman Institute of Technology
// 
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "CJSONDeserializer.h"
#import "NSDictionary_JSONExtensions.h"

#import "RHRestHandler.h"
#import "RHRemoteHandlerDelegate.h"
#import "RHLabelNode.h"
#import "RHLocation.h"


@interface RHRestHandler ()

@property (nonatomic, retain) NSManagedObjectContext *context;
@property (nonatomic, retain) NSOperationQueue *operations;

- (void)performFetchAllLocations;

@end


@implementation RHRestHandler

@synthesize delegate;
@synthesize context;
@synthesize operations;

- (id)initWithContext:(NSManagedObjectContext *)inContext
             delegate:(RHRemoteHandlerDelegate *)inDelegate {
    self = [super init];
    
    if (self) {
        self.delegate = inDelegate;
        self.context = inContext;
        self.operations = [[NSOperationQueue new] autorelease];
    }
    
    return self;
}

- (void)fetchAllLocations {
    if (self.delegate == nil) {
        return;
    }
    
    NSInvocationOperation* operation = [NSInvocationOperation alloc];
    operation = [[operation initWithTarget:self
                                  selector:@selector(performFetchAllLocations)
                                    object:nil] autorelease];
    [operations addOperation:operation];
}

#pragma mark -
#pragma mark Private Methods

- (void)performFetchAllLocations {
    NSURL *url = [NSURL URLWithString:@"http://mobilewin.csse.rose-hulman.edu:5600/mapareas"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    // Because this will be done on a background thread, we can use a
    // synchronous request for our data retrieval step.
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    if (data == nil) {
        // TODO: Handle errors here
        return;
    }
    
    error = nil;
    NSDictionary *parsedData = [NSDictionary dictionaryWithJSONData:data
                                                              error:&error];
    
    if (parsedData == nil) {
        // TODO: Handle errors here
        return;
    }
    
    NSArray *areas = [parsedData valueForKey:@"Areas"];
    
    if (areas == nil) {
        // TODO: Handle errors here
        return;
    }
    
    NSMutableSet *locations = [NSMutableSet setWithCapacity:[areas count]];
    
    for (NSDictionary *area in areas) {
        NSDictionary *center = [area valueForKey:@"Center"];
        
        if (center == nil) {
            // TODO: Handle errors here
            return;
        }
        
        RHLabelNode *centerNode = (RHLabelNode *) [RHLabelNode
                                                   fromContext:context];
        
        centerNode.latitude = [center valueForKey:@"Lat"];
        centerNode.longitude = [center valueForKey:@"Long"];
        
        RHLocation *location = (RHLocation *) [RHLocation fromContext:context];
        
        location.labelLocation = centerNode;
        location.name = [area valueForKey:@"Name"];
        
        [locations addObject:location];
    }
    
    [delegate didFetchAllLocations:locations];
}

@end
