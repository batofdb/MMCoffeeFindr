//
//  DetailViewController.h
//  CoffeeFindr
//
//  Created by Francis Bato on 9/24/15.
//  Copyright (c) 2015 Francis Bato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoffeePlace.h"

@interface DetailViewController : UIViewController
@property CoffeePlace *coffeePlace;
@property CLLocation *currentLocation;

@end
