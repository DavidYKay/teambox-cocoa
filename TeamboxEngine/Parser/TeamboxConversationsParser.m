//
//  TeamboxConversationsParser.m
//  Teambox Mac
//
//  Created by Alejandro JL on 27/05/10.
//  Copyright 2010 Teambox. All rights reserved.
//

#import "TeamboxConversationsParser.h"
#import "ConversationModel.h"

@implementation TeamboxConversationsParser

- (void)parserAndAddCoreData {
	NSError *error;
	TBXMLElement *root = parser.rootXMLElement;	
	TBXMLElement *conversation = [TBXML childElementNamed:@"conversation" parentElement:root];
	#if defined(DEBUG)
		NSLog(@"Parseando conversations");
	#endif
	while (conversation != nil) {
		#if defined(DEBUG)
			NSLog(@"Enter conversation");
		#endif
		ConversationModel *aConversation = (ConversationModel *)[NSEntityDescription insertNewObjectForEntityForName:@"Conversation" inManagedObjectContext:managedObjectContext];
		aConversation.conversation_id = [NSNumber numberWithInt:[[TBXML valueOfAttributeNamed:@"id" forElement:conversation] intValue]];
		aConversation.name = [TBXML stringByDecodingXMLEntities:[TBXML textForElement:[TBXML childElementNamed:@"name" parentElement:conversation]]];

		conversation = [TBXML nextSiblingNamed:@"conversation" searchFromElement:conversation];
		#if defined(DEBUG)
			NSLog(@"Exit conversation");
		#endif
	}
	if (![managedObjectContext save:&error]) {
		
	}
	
	[delegate parserFinishedType:typeParse];
}

@end
