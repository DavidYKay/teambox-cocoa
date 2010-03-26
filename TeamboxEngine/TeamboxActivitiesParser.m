//
//  TeamboxActivitiesParser.m
//  Teambox
//
//  Created by Alejandro Julián López on 26/02/10.
//  Copyright 2010 Teambox. All rights reserved.
//

#import "TeamboxActivitiesParser.h"
#import "ActivityModel.h"

@interface  TeamboxActivitiesParser (Private)

- (NSString *)prettyDate:(NSString *)dateString;

@end


@implementation TeamboxActivitiesParser


- (void)parse {
						
	[delegate parserFinished:parsedElements typeParse:typeParse];
	
}

- (NSString *)prettyDate:(NSString *)dateString {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
	[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate *date = [formatter dateFromString:dateString];
	NSCalendarDate *calDate = [NSCalendarDate dateWithTimeIntervalSinceReferenceDate: [date timeIntervalSinceReferenceDate]];
	NSCalendarDate *today = [NSCalendarDate date];
	int days = [today dayOfCommonEra] - [calDate dayOfCommonEra];
	
	if (days == 0) {
		NSDate *ref = [NSDate date];
		float diff = [ref timeIntervalSinceDate:date];
		if (diff < 60) return [NSString stringWithFormat:@"%d seconds ago", (int)floor( diff )];
        if (diff < 120) return @"1 minute ago";
        if (diff < 3600) return [NSString stringWithFormat:@"%d minutes ago", (int)floor( diff / 60 )];
		[formatter setDateFormat:@"HH:mm a"];
		NSString *upperDate = [formatter stringFromDate:date];
        return [NSString stringWithFormat:@"%@", [upperDate uppercaseString]];
    } else if (days == 1) {
		[formatter setDateFormat:@"HH:mm a"];
		NSString *upperDate = [formatter stringFromDate:date];
        return [NSString stringWithFormat:@"Yesterday %@", [upperDate uppercaseString]];
    } else if (days < 7) {
		[formatter setDateFormat:@"cccc MMM d"];
        return [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
    } else if (days < 365) {
		[formatter setDateFormat:@"MMM d"];
        return [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
    } else {
        [formatter setDateFormat:@"yyyy MMM d"];
        return [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
    }
}

- (void) dealloc {
	[super dealloc];
}
@end
