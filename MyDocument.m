//
//  MyDocument.m
//  Teambox-Engine
//
//  Created by Alejandro JL on 26/03/10.
//  Copyright __MyCompanyName__ 2010 . All rights reserved.
//

#import "MyDocument.h"

@implementation MyDocument

- (id)init 
{
    self = [super init];
    if (self != nil) {
        engine = [[TeamboxEngine alloc] initWithDelegate:self];
    }
    return self;
}

- (NSString *)windowNibName 
{
    return @"MyDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)windowController 
{
    [super windowControllerDidLoadNib:windowController];
	[engine getProjects];
    // user interface preparation code
}

- (void)postComment {
}


- (void)activitiesReceivedAll:(NSArray *)activities {

}

- (void)activitiesReceivedAllNew:(NSArray *)activities {

}


- (void)activitiesReceivedAllMore:(NSArray *)activities {

}

- (void)projectsReceived:(NSArray *)activities {

}

- (void)activitiesReceivedNothing:(NSString *)type {

}

@end
