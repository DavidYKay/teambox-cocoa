	//
	//  TeamboxParse.m
	//  Teambox
	//
	//  Created by 
	//			Alejandro Julián López
	//			Eduardo Hernández Cano 
	//	on 26/02/10.
	//  Copyright 2010 Teambox. All rights reserved.
	//

#import "TeamboxParser.h"

@interface  TeamboxParser (Private)

- (id)initWithActivities:(NSMutableArray *)activities managedObjectContext:(NSManagedObjectContext *)theManagedObjectContext delegate:(NSObject *)theDelegate;
- (id)initWithData:(NSData *)data typeParse:(NSString *)type managedObjectContext:(NSManagedObjectContext *)theManagedObjectContext delegate:(NSObject *)theDelegate;
- (id)initWithData:(NSData *)data typeParse:(NSString *)type projectName:(NSString *)name managedObjectContext:(NSManagedObjectContext *)theManagedObjectContext delegate:(NSObject *)theDelegate;
- (void)parserAndAddCoreData;

@end

@implementation TeamboxParser

+ (id)parserWithActivities:(NSMutableArray *)activities managedObjectContext:(NSManagedObjectContext *)theManagedObjectContext delegate:(NSObject *)theDelegate {
	id parser = [[self alloc] initWithActivities:activities managedObjectContext:theManagedObjectContext delegate:theDelegate];
	return [parser autorelease];
}

+ (id)parserWithData:(NSData *)data typeParse:(NSString *)type managedObjectContext:(NSManagedObjectContext *)theManagedObjectContext delegate:(NSObject *)theDelegate {
	id parser = [[self alloc] initWithData:data typeParse:type managedObjectContext:theManagedObjectContext delegate:theDelegate];
    return [parser autorelease];
}

+ (id)parserWithData:(NSData *)data typeParse:(NSString *)type projectName:(NSString *)name managedObjectContext:(NSManagedObjectContext *)theManagedObjectContext delegate:(NSObject *)theDelegate {
	id parser = [[self alloc] initWithData:data typeParse:type projectName:name managedObjectContext:theManagedObjectContext delegate:theDelegate];
    return [parser autorelease];
}

- (id)initWithActivities:(NSMutableArray *)activities managedObjectContext:(NSManagedObjectContext *)theManagedObjectContext delegate:(NSObject *)theDelegate {
	if (self = [super init]) {
		typeParse = @"ActivitiesAllNewWithData";
		delegate = theDelegate;
		managedObjectContext = theManagedObjectContext;
		int aux = [activities count];
		aux--;
		for (;aux >= 0; aux--) {
			parser = [[TBXML alloc] initWithXMLData:[activities objectAtIndex:aux]];
			[self parserAndAddCoreData];
		}
		[delegate parserFinishedType:@"ActivitiesAllNew"];
    }
    return self;
}

- (id)initWithData:(NSData *)data typeParse:(NSString *)type managedObjectContext:(NSManagedObjectContext *)theManagedObjectContext delegate:(NSObject *)theDelegate {
	if (self = [super init]) {
		delegate = theDelegate;
		typeParse = type;
		managedObjectContext = theManagedObjectContext;
		/*if ([typeParse isEqualToString:@"ActivitiesAll"])
			parser = [[TBXML alloc] initWithXMLFile:@"activities.xml"];
		 else */
			 parser = [[TBXML alloc] initWithXMLData:data];
		[self parserAndAddCoreData];
    }
    
    return self;
}

- (id)initWithData:(NSData *)data typeParse:(NSString *)type projectName:(NSString *)name managedObjectContext:(NSManagedObjectContext *)theManagedObjectContext delegate:(NSObject *)theDelegate {
    if (self = [super init]) {
		delegate = theDelegate;
		typeParse = type;
		projectName = name;
		managedObjectContext = theManagedObjectContext;
		/*if ([typeParse isEqualToString:@"ActivitiesAll"])
			parser = [[TBXML alloc] initWithXMLFile:@"activities.xml"];
		else*/
		parser = [[TBXML alloc] initWithXMLData:data];
		[self parserAndAddCoreData];
    }
    
    return self;
}

- (void) dealloc {
	delegate = nil;
	[super dealloc];
}

@end