//
//  ListViewController.m
//  CoffeeFindr
//
//  Created by Francis Bato on 9/20/15.
//  Copyright (c) 2015 Francis Bato. All rights reserved.
//

#import "ListViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "CoffeePlace.h"
#import "DetailViewController.h"

@interface ListViewController () <CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate>

@property CLLocationManager *locationManager;
@property CLLocation *currentLocation;
@property NSArray *coffeePlacesArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    [self updateCurrentLocation];


}

-(void) updateCurrentLocation
{
    [_locationManager requestAlwaysAuthorization];
    [_locationManager startUpdatingLocation];


    
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    _currentLocation = locations.firstObject;
    NSLog(@"%@",_currentLocation);
    [_locationManager stopUpdatingLocation];
    [self findCoffeePlaces:_currentLocation];
}

-(void) findCoffeePlaces: (CLLocation *)location
{
    MKLocalSearchRequest *request = [MKLocalSearchRequest new];
    request.naturalLanguageQuery = @"coffee";
    //1º = 69 miles
    request.region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(.05, .05));

    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        NSArray *mapItems = response.mapItems;
        NSMutableArray *tempArray = [NSMutableArray new];

        for (int i=0;i<5;i++)
        {
            MKMapItem *mapItem = [mapItems objectAtIndex:i];
            CLLocationDistance metersAway = [mapItem.placemark.location distanceFromLocation:location];
            //conversion rate 1 meter = 0.000621371 miles
            float milesDifference = metersAway*0.000621371;

            CoffeePlace *coffeePlace = [CoffeePlace new];
            coffeePlace.mapItem = mapItem;
            coffeePlace.milesDifference = milesDifference;

            [tempArray addObject:coffeePlace];
            NSLog(@"%@",coffeePlace.mapItem.name);
            
        }

        NSSortDescriptor *sortDesecriptor = [NSSortDescriptor sortDescriptorWithKey:@"milesDifference" ascending:YES];

        NSArray *sortedArray =  [tempArray sortedArrayUsingDescriptors:@[sortDesecriptor]];
        _coffeePlacesArray = [NSArray arrayWithArray:sortedArray];

        [_tableView reloadData];


    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _coffeePlacesArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [[[_coffeePlacesArray objectAtIndex:indexPath.row] mapItem] name];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DetailViewController *detailVC = [segue destinationViewController];

    detailVC.coffeePlace = [_coffeePlacesArray objectAtIndex:_tableView.indexPathForSelectedRow.row];
    detailVC.currentLocation = self.currentLocation;
    
}

@end
