//
//  TeamboxEngine.m
//  Teambox
//
//  Created by 
//			Alejandro Julián López
//			Eduardo hernández Cano 
//	Created:26/02/10.
//  Copyright 2010 Teambox. All rights reserved.
//

#import "TeamboxEngine.h"
#import "TeamboxActivitiesParser.h"
#import "TeamboxProjectsParser.h"
#import "ASIHTTPRequest.h"

@implementation TeamboxEngine
@synthesize typeUser;

+ (TeamboxEngine *)teamboxEngineWithDelegate:(NSObject *)delegate {
	return [[[TeamboxEngine alloc] initWithDelegate:delegate] autorelease];
}

- (TeamboxEngine *)initWithDelegate:(NSObject *)delegate {
	if (self = [super init]) {
        engineDelegate = delegate;
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		username = @"dsdsad";
		#if TARGET_OS_MAC
			password = @"dsdsa";
		#else
			password = @"dsad";
		#endif
    }
    
    return self;
}

- (void)getActivitiesAll:(NSManagedObjectContext *)managedObjectContext {
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:KActivitiesAllXML, username, password]];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setDelegate:self];
	[request setUsername:@"all"];
	[request addRequestHeader:@"Accept" value:@"application/xml"];
	[request startSynchronous];
	[TeamboxActivitiesParser parserWithData:[request responseData] delegate:self typeParse:@"ActivitiesAll" managedObjectContext:managedObjectContext];
	
		//[TeamboxActivitiesParser parserWithURL:url delegate:self typeParse:@"ActivitiesAll"];
}

- (void)requestDone:(ASIHTTPRequest *)request {

}
- (void)getActivitiesAllNew:(NSString *)activityID {
	NSString *path = [NSString stringWithFormat:KActivitiesAllNewXML, username, password, activityID];
	[TeamboxActivitiesParser parserWithURL:[NSURL URLWithString:path] delegate:self typeParse:@"ActivitiesAllNew"];
}

- (void)getActivitiesAllMore:(NSString *)activityID {
	NSString *path = [NSString stringWithFormat:KActivitiesAllMoreXML, username, password, activityID];
	[TeamboxActivitiesParser parserWithURL:[NSURL URLWithString:path] delegate:self typeParse:@"ActivitiesAllMore"];
}

- (void)getActivities:(NSString *)projectID {
	
}

- (void)getActivitiesNew:(NSString *)projectID sinceActivityID:(NSString *)firstID {
	
}

- (void)getActivitiesMore:(NSString *)projectID sinceActivityID:(NSString *)lastID {
	
}

- (void)getUser:(NSString *)username {
	
}

- (void)getProjects {
	NSString *path = [NSString stringWithFormat:KProjectsXML, username, password];
	[TeamboxProjectsParser parserWithURL:[NSURL URLWithString:path] delegate:self typeParse:@"Projects"];
}

- (void)setUseSecureConnection:(BOOL)useSecure {
	
}

- (void)getFiles:(NSString *)projectID {
	
}

- (void)postCommentWithProject:(NSString *)comment projectName:(NSString *)name {
	name = [[name componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:@""];
	NSString *urlString = [NSString stringWithFormat:KPostComment, username, password, name]; 
	
	NSURL *url = [NSURL URLWithString:urlString];
	comment = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><comment><body>%@</body></comment>", comment];
	
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request addRequestHeader:@"Accept" value:@"application/xml"];
	[request addRequestHeader:@"Content-Type" value:@"application/xml"];
	[request addRequestHeader:@"User-Agent" value:@"Teambox Mac 0.1"];
	[request appendPostData:[comment dataUsingEncoding:NSUTF8StringEncoding]];
	[request startSynchronous];
}

- (void)parserFailedWithError:(NSError *)errorMsg {
	NSLog(@"error %@",errorMsg);
}

- (void)parserFinished:(NSArray *)parsedElements typeParse:(NSString *)type {
	if ([parsedElements count] > 0) {
		if ([type isEqualToString:@"ActivitiesAll"])
			[engineDelegate activitiesReceivedAll:parsedElements];
		else if ([type isEqualToString:@"ActivitiesAllNew"])
			[engineDelegate activitiesReceivedAllNew:parsedElements];
		else if ([type isEqualToString:@"ActivitiesAllMore"])
			[engineDelegate activitiesReceivedAllMore:parsedElements];
		else if ([type isEqualToString:@"Projects"])
			[engineDelegate projectsReceived:parsedElements];
	} else
		[engineDelegate activitiesReceivedNothing:type];
}

- (void)dealloc {
	[username release];
	[password release];
	[super dealloc];
}

@end
