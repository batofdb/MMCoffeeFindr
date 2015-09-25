//
//  DetailViewController.m
//  CoffeeFindr
//
//  Created by Francis Bato on 9/24/15.
//  Copyright (c) 2015 Francis Bato. All rights reserved.
//

#import "DetailViewController.h"


@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _coffeePlace.mapItem.name;
    [self getPathDirections: _currentLocation.coordinate withDestination:_coffeePlace.mapItem.placemark.location.coordinate];
}

-(void) getPathDirections:(CLLocationCoordinate2D) source withDestination:(CLLocationCoordinate2D) destination
{
    MKPlacemark *placemarkSrc = [[MKPlacemark alloc] initWithCoordinate:source addressDictionary:nil];
    MKMapItem *mapItemSrc = [[MKMapItem alloc] initWithPlacemark:placemarkSrc];

    MKPlacemark *placemarkDest = [[MKPlacemark alloc] initWithCoordinate:destination addressDictionary:nil];
    MKMapItem *mapItemDest = [[MKMapItem alloc] initWithPlacemark:placemarkDest];

    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    [request setSource:mapItemSrc];
    [request setDestination:mapItemDest];
    [request setTransportType:MKDirectionsTransportTypeWalking];
    request.requestsAlternateRoutes = NO;

    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];

    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error){
        MKRoute *route = response.routes.lastObject;

        NSString *allSteps = [NSString new];
        for (int i=0;i<route.steps.count;i++)
        {
            MKRouteStep *step = [route.steps objectAtIndex:i];
            NSString *newStepString = step.instructions;
            allSteps = [allSteps stringByAppendingString:newStepString];
            allSteps = [allSteps stringByAppendingString:@"\n\n"];
        }
        _textView.text = allSteps;
    }];

}

@end
