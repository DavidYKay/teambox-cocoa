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

- (id)initWithURL:(NSData *)data delegate:(NSObject *)theDelegate typeParse:(NSString *)type managedObjectContext:(NSManagedObjectContext *)theManagedObjectContext;

@end

@implementation TeamboxParser

+ (id)parserWithData:(NSData *)data delegate:(NSObject *)theDelegate typeParse:(NSString *)type managedObjectContext:(NSManagedObjectContext *)theManagedObjectContext{
	id parser = [[self alloc
				  ] initWithURL:data 
                                 delegate:theDelegate 
								typeParse:type managedObjectContext:theManagedObjectContext];
    return [parser autorelease];
}

- (id)initWithURL:(NSData *)data delegate:(NSObject *)theDelegate typeParse:(NSString *)type managedObjectContext:(NSManagedObjectContext *)theManagedObjectContext {
    if (self = [super init]) {
		delegate = theDelegate;
		typeParse = type;
		managedObjectContext = theManagedObjectContext;
		parser = [[TBXML alloc] initWithXMLData:data];
		[self parse];
    }
    
    return self;
}

- (void) dealloc {
	delegate = nil;
	[super dealloc];
}

@end
