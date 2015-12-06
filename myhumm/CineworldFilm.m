//
//  CineworldFilm.m
//  myhumm
//
//  Created by Bryan Yap on 06/12/2015.
//  Copyright © 2015 Kankemwa Ishaku. All rights reserved.
//

#import "CineworldFilm.h"

@implementation CineworldFilm
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"id",
                                                       @"still_url": @"stillUrl",
                                                       @"title": @"title",
                                                       @"3D": @"is3D",
                                                       @"imax": @"imax",
                                                       @"classification": @"classification",
                                                       @"edi": @"edi",
                                                       @"film_url": @"filmUrl",
                                                       @"poster_url": @"posterUrl",
                                                       @"advisory": @"advisory"
                                                       }];
}
@end
