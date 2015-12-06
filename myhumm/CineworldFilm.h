//
//  CineworldFilm.h
//  myhumm
//
//  Created by Bryan Yap on 06/12/2015.
//  Copyright © 2015 Kankemwa Ishaku. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CineworldFilm : JSONModel

@property (assign, nonatomic) NSInteger id;
@property (assign, nonatomic) NSInteger edi;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *filmUrl;
@property (strong, nonatomic) NSString *stillUrl;
@property (strong, nonatomic) NSString *posterUrl;
@property (strong, nonatomic) NSString *classification;
@property (strong, nonatomic) NSString *advisory;
@property (assign, nonatomic) BOOL is3D;
@property (assign, nonatomic) BOOL imax;

@end