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
#import "TeamboxEngineConnection.h"

@implementation TeamboxEngine

@synthesize typeUser;

+ (TeamboxEngine *)teamboxEngineWithDelegate:(NSObject *)delegate {
	return [[[TeamboxEngine alloc] initWithDelegate:delegate] autorelease];
}

- (TeamboxEngine *)initWithDelegate:(NSObject *)delegate {
	if (self = [super init]) {
        engineDelegate = delegate;
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		username = [defaults valueForKey:kUserNameSettingsKey];
		#if TARGET_OS_MAC
			password = [defaults valueForKey:kPaswordSettingsKey];
		#else
			password = [defaults valueForKey:kPaswordSettingsKey];
		#endif
		managedObjectContext = self.managedObjectContext;
    }
    return self;
}

- (void)getActivitiesAll:(NSManagedObjectContext *)managedObjectContext {
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:KActivitiesAllXML, username, password]];
		//[TeamboxActivitiesParser parserWithURL:url delegate:self typeParse:@"ActivitiesAll"];
}

- (void)requestDone:(ASIHTTPRequest *)request {

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
	[TeamboxEngineConnection getDataWithURL:[NSURL URLWithString:[NSString stringWithFormat:KProjectsXML, username, password]] type:@"project" delegate:self];
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
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Teampocket.sqlite"]];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible
		 * The schema for the persistent store is incompatible with current managed object model
		 Check the error message to determine what the actual problem was.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (void)dealloc {
	[username release];
	[password release];
	[super dealloc];
}

@end
