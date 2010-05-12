	//
	//  TeamboxParser.h
	//  Teambox
	//
	//  Created by 
	//			Alejandro Julián López
	//			Eduardo Hernández Cano 
	//  on 26/02/10.
	//  Copyright 2010 Teambox. All rights reserved.
	//

#import "TeamboxEngineHeaders.h"
#import "TeamboxParserDelegate.h"
#import "TBXML.h"

@interface TeamboxParser : NSObject {
	NSObject <TeamboxParserDelegate> *delegate;
	TBXML *parser;
	NSMutableArray *parsedElements;
	NSString *typeParse;
	NSManagedObjectContext *managedObjectContext;
}

+ (id)parserWithData:(NSData *)data typeParse:(NSString *)type managedObjectContext:(NSManagedObjectContext *)theManagedObjectContext delegate:(NSObject *)theDelegate;
- (NSString *)stringByDecodingXMLEntities:(NSString *)sSource;

@end