//
//  TeamboxPagesParser.m
//  Teambox Mac
//
//  Created by Alejandro JL on 27/05/10.
//  Copyright 2010 Teambox. All rights reserved.
//

#import "TeamboxPagesParser.h"
#import "PageModel.h"

@implementation TeamboxPagesParser

- (void)parserAndAddCoreData {
	NSError *error;
	TBXMLElement *root = parser.rootXMLElement;	
	TBXMLElement *page = [TBXML childElementNamed:@"page" parentElement:root];
	#if defined(DEBUG)
		NSLog(@"Parseando pages");
	#endif
	while (page != nil) {
		#if defined(DEBUG)
			NSLog(@"Enter page");
		#endif
		PageModel *aPage = (PageModel *)[NSEntityDescription insertNewObjectForEntityForName:@"Page" inManagedObjectContext:managedObjectContext];
		aPage.page_id = [NSNumber numberWithInt:[[TBXML valueOfAttributeNamed:@"id" forElement:page] intValue]];
		aPage.name = [TBXML stringByDecodingXMLEntities:[TBXML textForElement:[TBXML childElementNamed:@"name" parentElement:page]]];
		
		page = [TBXML nextSiblingNamed:@"page" searchFromElement:page];
		#if defined(DEBUG)
			NSLog(@"Exit page");
		#endif
	}
	if (![managedObjectContext save:&error]) {
		
	}
	
	[delegate parserFinishedType:typeParse];
}

@end
