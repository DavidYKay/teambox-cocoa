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

- (id)initWithData:(NSData *)data typeParse:(NSString *)type managedObjectContext:(NSManagedObjectContext *)theManagedObjectContext delegate:(NSObject *)theDelegate;
- (void)parse;

@end

@implementation TeamboxParser

+ (id)parserWithData:(NSData *)data typeParse:(NSString *)type managedObjectContext:(NSManagedObjectContext *)theManagedObjectContext delegate:(NSObject *)theDelegate {
	id parser = [[self alloc] initWithData:data typeParse:type managedObjectContext:theManagedObjectContext delegate:theDelegate];
    return [parser autorelease];
}

- (id)initWithData:(NSData *)data typeParse:(NSString *)type managedObjectContext:(NSManagedObjectContext *)theManagedObjectContext delegate:(NSObject *)theDelegate {
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
