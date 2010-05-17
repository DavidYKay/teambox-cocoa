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
- (id)initWithData:(NSData *)data typeParse:(NSString *)type projectName:(NSString *)name managedObjectContext:(NSManagedObjectContext *)theManagedObjectContext delegate:(NSObject *)theDelegate;
- (void)parserAndAddCoreData;

@end

@implementation TeamboxParser
+ (id)parserWithData:(NSData *)data typeParse:(NSString *)type managedObjectContext:(NSManagedObjectContext *)theManagedObjectContext delegate:(NSObject *)theDelegate {
	id parser = [[self alloc] initWithData:data typeParse:type managedObjectContext:theManagedObjectContext delegate:theDelegate];
    return [parser autorelease];
}
+ (id)parserWithData:(NSData *)data typeParse:(NSString *)type projectName:(NSString *)name managedObjectContext:(NSManagedObjectContext *)theManagedObjectContext delegate:(NSObject *)theDelegate {
	id parser = [[self alloc] initWithData:data typeParse:type projectName:name managedObjectContext:theManagedObjectContext delegate:theDelegate];
    return [parser autorelease];
}

- (id)initWithData:(NSData *)data typeParse:(NSString *)type managedObjectContext:(NSManagedObjectContext *)theManagedObjectContext delegate:(NSObject *)theDelegate {
	if (self = [super init]) {
		delegate = theDelegate;
		typeParse = type;
		managedObjectContext = theManagedObjectContext;
		if ([typeParse isEqualToString:@"ActivitiesAll"])
			parser = [[TBXML alloc] initWithXMLFile:@"activities.xml"];
		 else
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

- (NSString *)stringByDecodingXMLEntities:(NSString *)sSource {
    NSUInteger myLength = [sSource length];
    NSUInteger ampIndex = [sSource rangeOfString:@"&" options:NSLiteralSearch].location;
	
		// Short-circuit if there are no ampersands.
    if (ampIndex == NSNotFound) {
        return sSource;
    }
		// Make result string with some extra capacity.
    NSMutableString *result = [NSMutableString stringWithCapacity:(myLength * 1.25)];
	
		// First iteration doesn't need to scan to & since we did that already, but for code simplicity's sake we'll do it again with the scanner.
    NSScanner *scanner = [NSScanner scannerWithString:sSource];
	
    [scanner setCharactersToBeSkipped:nil];
	
    NSCharacterSet *boundaryCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@" \t\n\r;"];
	
    do {
			// Scan up to the next entity or the end of the string.
        NSString *nonEntityString;
        if ([scanner scanUpToString:@"&" intoString:&nonEntityString]) {
            [result appendString:nonEntityString];
        }
        if ([scanner isAtEnd]) {
            goto finish;
        }
			// Scan either a HTML or numeric character entity reference.
        if ([scanner scanString:@"&amp;" intoString:NULL])
            [result appendString:@"&"];
        else if ([scanner scanString:@"&apos;" intoString:NULL])
            [result appendString:@"'"];
        else if ([scanner scanString:@"&quot;" intoString:NULL])
            [result appendString:@"\""];
        else if ([scanner scanString:@"&lt;" intoString:NULL])
            [result appendString:@"<"];
        else if ([scanner scanString:@"&gt;" intoString:NULL])
            [result appendString:@">"];
        else if ([scanner scanString:@"&#" intoString:NULL]) {
            BOOL gotNumber;
            unsigned charCode;
            NSString *xForHex = @"";
			
				// Is it hex or decimal?
            if ([scanner scanString:@"x" intoString:&xForHex]) {
                gotNumber = [scanner scanHexInt:&charCode];
            }
            else {
                gotNumber = [scanner scanInt:(int*)&charCode];
            }
			
            if (gotNumber) {
                [result appendFormat:@"%C", charCode];
				
				[scanner scanString:@";" intoString:NULL];
            }
            else {
                NSString *unknownEntity = @"";
				
				[scanner scanUpToCharactersFromSet:boundaryCharacterSet intoString:&unknownEntity];
				
				
				[result appendFormat:@"&#%@%@", xForHex, unknownEntity];
				
					//[scanner scanUpToString:@";" intoString:&unknownEntity];
					//[result appendFormat:@"&#%@%@;", xForHex, unknownEntity];
                NSLog(@"Expected numeric character entity but got &#%@%@;", xForHex, unknownEntity);
				
            }
			
        }
        else {
			NSString *amp;
			
			[scanner scanString:@"&" intoString:&amp];      //an isolated & symbol
			[result appendString:amp];
			
			/*
			 NSString *unknownEntity = @"";
			 [scanner scanUpToString:@";" intoString:&unknownEntity];
			 NSString *semicolon = @"";
			 [scanner scanString:@";" intoString:&semicolon];
			 [result appendFormat:@"%@%@", unknownEntity, semicolon];
			 NSLog(@"Unsupported XML character entity %@%@", unknownEntity, semicolon);
			 */
        }
		
    }
    while (![scanner isAtEnd]);
	
finish:
    return result;
}

- (void) dealloc {
	delegate = nil;
	[super dealloc];
}

@end