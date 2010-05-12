//
//  TeamboxPeopleParser.m
//  Teambox Mac
//
//  Created by Alejandro JL on 12/05/10.
//  Copyright 2010 Teambox. All rights reserved.
//

#import "TeamboxPeopleParser.h"
#import "UserModel.h"

@implementation TeamboxPeopleParser

- (void)parse {
		// Obtain root element
	TBXMLElement *root = parser.rootXMLElement;	
	
		// if root element is valid
	if (root) {
		TBXMLElement *person = [TBXML childElementNamed:@"person" parentElement:root];
			// if an author element was found
		while (person != nil) {
		}
	}
	[delegate parserFinishedType:typeParse];
	
}

@end