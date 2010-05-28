//
//  TeamboxUsersParser.m
//  Teambox Mac
//
//  Created by Alejandro JL on 26/05/10.
//  Copyright 2010 Teambox. All rights reserved.
//

#import "TeamboxUsersParser.h"
#import "UserModel.h"

@implementation TeamboxUsersParser
- (void)parserAndAddCoreData {
	NSError *error;
	TBXMLElement *root = parser.rootXMLElement;	
	TBXMLElement *user = [TBXML childElementNamed:@"user" parentElement:root];
	
	while (user != nil) {
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		[fetchRequest setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:managedObjectContext]];
		[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"user_id == %@", [TBXML valueOfAttributeNamed:@"id" forElement:user]]];
		
		UserModel *mUser;
		@try {
			mUser = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] objectAtIndex:0];
			mUser.first_name = [TBXML stringByDecodingXMLEntities:[TBXML textForElement:[TBXML childElementNamed:@"first-name" parentElement:user]]];
			mUser.last_name = [TBXML stringByDecodingXMLEntities:[TBXML textForElement:[TBXML childElementNamed:@"last-name" parentElement:user]]];
			mUser.full_name = [NSString stringWithFormat:@"%@ %@", mUser.first_name, mUser.last_name];
			mUser.abbreviation_name = [NSString stringWithFormat:@"%c. %@", [mUser.first_name characterAtIndex:0], mUser.last_name];
			mUser.avatar_url = [TBXML stringByDecodingXMLEntities:[TBXML textForElement:[TBXML childElementNamed:@"avatar-url" parentElement:user]]];
		} @catch (NSException *e) {
				//NSLog(@"NSException");
		} @finally {
			[fetchRequest release];
		}
		user = [TBXML nextSiblingNamed:@"user" searchFromElement:user];
	}
	if (![managedObjectContext save:&error]) {
		
	}
		
	[delegate parserFinishedType:@"Projects"];
}

@end
