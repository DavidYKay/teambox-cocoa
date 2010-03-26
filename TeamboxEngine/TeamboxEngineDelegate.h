//
//  TeamboxEngineDelegate.h
//  Teambox
//
//  Created by Alejandro Julián López on 26/02/10.
//  Copyright 2010 Teambox. All rights reserved.
//
#import "TeamboxEngineHeaders.h"

@protocol TeamboxEngineDelegate

- (void)activitiesReceivedAll:(NSArray *)activities;
- (void)activitiesReceivedAllNew:(NSArray *)activities;
- (void)activitiesReceivedAllMore:(NSArray *)activities;
- (void)projectsReceived:(NSArray *)activities;
- (void)activitiesReceivedNothing:(NSString *)type;
@end
