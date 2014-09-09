//
//  GBTMazingerZ.m
//  iMazinger
//
//  Created by Jaime Yesid Leon Parada on 9/8/14.
//  Copyright (c) 2014 Globant. All rights reserved.
//

#import "GBTMazingerZ.h"

@implementation GBTMazingerZ

-(id)init
{
    if (self = [super init]) {
        _coordinate = CLLocationCoordinate2DMake(41.3827416, 1.32880926);
    }
    return self;
}


#pragma mark - MKAnnotation

@synthesize coordinate = _coordinate;

-(NSString*)title
{
    return @"Mazinger";
}

-(NSString*)subtitle
{
    return @"Meca de frikis";
}

@end
