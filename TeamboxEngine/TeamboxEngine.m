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
#import "TeamboxConnection.h"
#import "TeamboxEngineKeychain.h"
#import "ASIHTTPRequest.h"

@interface TeamboxEngine (PrivateMethods)

	//Authentication

@end


@implementation TeamboxEngine

@synthesize typeUser;
@synthesize managedObjectModel;
@synthesize managedObjectContext;
@synthesize persistentStoreCoordinator;

+ (TeamboxEngine *)teamboxEngineWithDelegate:(NSObject *)delegate {
	return [[[TeamboxEngine alloc] initWithDelegate:delegate] autorelease];
}

- (TeamboxEngine *)initWithDelegate:(NSObject *)delegate {
	if (self = [super init]) {
        engineDelegate = delegate;
		managedObjectContext = self.managedObjectContext;
		[self authenticate];
    }
    return self;
}

	//Configuration
- (void)setUsername:(NSString *)userName Password:(NSString *)Password {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setValue:userName forKey:kUserNameSettingsKey];
	[defaults synchronize];
	[TeamboxEngineKeychain storePasswordForUsername:userName Password:Password error:nil];
	[self authenticate];
}

- (void)getActivitiesAll:(NSManagedObjectContext *)managedObjectContext {
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:KActivitiesAllXML, username, password]];
		//[TeamboxActivitiesParser parserWithURL:url delegate:self typeParse:@"ActivitiesAll"];
}

- (void)getActivitiesAllNew:(NSString *)activityID {
	NSString *path = [NSString stringWithFormat:KActivitiesAllNewXML, username, password, activityID];
}

- (void)getActivitiesAllMore:(NSString *)activityID {
	NSString *path = [NSString stringWithFormat:KActivitiesAllMoreXML, username, password, activityID];
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
	[TeamboxConnection getDataWithURL:[NSURL URLWithString:[NSString stringWithFormat:KProjectsXML, username, password]] type:@"Projects" delegate:self];
}

- (void)finishedGetData:(NSData *)data withType:(NSString *)type {
	[TeamboxProjectsParser parserWithData:data typeParse:type managedObjectContext:managedObjectContext delegate:self];
}

- (void)setUseSecureConnection:(BOOL)useSecure {
	
}

- (void)getFiles:(NSString *)projectID {
	
}

- (void)postCommentWithProject:(NSString *)comment projectName:(NSString *)name {
	/*name = [[name componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:@""];
	NSString *urlString = [NSString stringWithFormat:KPostComment, username, password, name]; 
	
	NSURL *url = [NSURL URLWithString:urlString];
	comment = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><comment><body>%@</body></comment>", comment];
	
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request addRequestHeader:@"Accept" value:@"application/xml"];
	[request addRequestHeader:@"Content-Type" value:@"application/xml"];
	[request addRequestHeader:@"User-Agent" value:@"Teambox Mac 0.1"];
	[request appendPostData:[comment dataUsingEncoding:NSUTF8StringEncoding]];
	[request startSynchronous]; */
}

- (void)parserFailedWithError:(NSError *)errorMsg {
	NSLog(@"error %@",errorMsg);
}

- (void)parserFinishedType:(NSString *)type {
		/*if ([type isEqualToString:@"ActivitiesAll"])
			[engineDelegate activitiesReceivedAll:parsedElements];
		else if ([type isEqualToString:@"ActivitiesAllNew"])
			[engineDelegate activitiesReceivedAllNew:parsedElements];
		else if ([type isEqualToString:@"ActivitiesAllMore"])
			[engineDelegate activitiesReceivedAllMore:parsedElements];
		else if ([type isEqualToString:@"Projects"])
			[engineDelegate projectsReceived:parsedElements];
		//[engineDelegate activitiesReceivedNothing:type]; */
	[engineDelegate projectsReceived:managedObjectContext];
}

- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
	NSURL *storeUrl;
	#if TARGET_OS_IPHONE
		storeUrl = [NSURL fileURLWithPath: [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent: @"Teambox.sqlite"]];
	#else
		[[NSFileManager defaultManager] createDirectoryAtPath:[[NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject] 
														   stringByAppendingPathComponent: @"Teambox"] withIntermediateDirectories:TRUE  attributes:nil error:nil];
		storeUrl = [NSURL fileURLWithPath: [[NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent: @"/Teambox/Teambox.sqlite"]];
	#endif
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
	
    return persistentStoreCoordinator;
}

- (void)authenticate {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	username = [defaults valueForKey:kUserNameSettingsKey];
	if (username == nil) {
		[engineDelegate notHaveUser];
	} else {
		password = [TeamboxEngineKeychain getPasswordForUsername:username error:nil];
		if ([password isEqualToString:@""])
			[engineDelegate notCorrectUserOrPassword:username];
		else
			[TeamboxConnection authenticateWithUsername:username andPassword:password url:[NSURL URLWithString:[NSString stringWithFormat:KTeamboxURL]] type:@"Login" delegate:self];
	}
}

- (void)finishedConnectionLogin {
	[engineDelegate correctAuthentication];
}

- (void)errorConnectionLogin {
	[engineDelegate notCorrectUserOrPassword:username];
}

#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */

- (void)dealloc {
	[username release];
	[password release];
	[super dealloc];
}

@end
