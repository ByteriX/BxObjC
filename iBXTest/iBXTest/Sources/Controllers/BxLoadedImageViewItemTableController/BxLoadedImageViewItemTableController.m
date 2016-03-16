//
//  BxLoadedImageViewItemTableController.m
//  iBXTest
//
//  Created by Sergan on 07.11.13.
//  Copyright (c) 2013 ByteriX. All rights reserved.
//

#import "BxLoadedImageViewItemTableController.h"
#import "BxLoadedImageViewItemCell.h"

@interface BxLoadedImageViewItemTableController ()

@property (nonatomic, retain) NSArray * data;

@end

@implementation BxLoadedImageViewItemTableController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.data = @[
                  @"http://www.seobook.com/images/smallfish.jpg",
                  @"http://mathworld.wolfram.com/images/gifs/smstdo-o.jpg",
                  @"http://auto.indiamart.com/cars/gifs/nissan_micra_small_car.jpg",
                  @"http://auto.indiamart.com/cars/gifs/Tata-Nano-car.jpg",
                  @"http://auto.indiamart.com/gifs/small-cars-india.jpg",
                  @"http://b.vimeocdn.com/ts/201/722/201722965_640.jpg",
                  @"http://auto.indiamart.com/gifs/small-cars-india.jpg",
                  @"http://l.yimg.com/ck/image/A4755/47553/300_47553.jpg",
                  @"http://l.yimg.com/ck/image/A4755/47553/300_47553.jpg",
                  @"http://i01.i.aliimg.com/wsphoto/v0/648863445/Free-shipping-new-arrival-small-women-s-scarf-long-designimitation-silk-scarf-air-conditioning-cape-printed.jpg",
                  @"http://image.dhgate.com/albu_210918363_00-1.0x0/2012-junior-bikini-swimwear-small-medium.jpg",
                  @"http://www.freakingnews.com/pictures/27000/Small-Baby--27176.jpg",
                  @"http://wiep.net/talk/wp-content/uploads/2008/12/liam-1year.jpg",
                  @"http://i.istockimg.com/file_thumbview_approve/18658244/2/stock-photo-18658244-beautiful-small-baby-boy-and-a-laptop.jpg",
                  @"http://www.digitalpicturezone.com/wp-content/uploads/2008/04/baby-photography1.jpg",
                  @"http://optimumsportsperformance.com/blog/wp-content/uploads/2010/05/ist2_6379522-creeping-small-baby-3-isolated2-200x300.jpg",
                  @"http://videofarm05e.kset.kz/uploaded/317/2171977_small.jpeg",
                  @"http://videofarm05f.kset.kz/uploaded/229/14227638_small.jpeg",
                  @"http://s4.afisha.net/Afisha7files/Afisha65/userimg/2006-11-14/16269765/g_dikari_small_04.jpg",
                  @"http://s3.afisha.net/Afisha7files/Afisha65/userimg/2006-11-14/16269759/g_dikari_small_03.jpg",
                  @"http://s2.afisha.net/Afisha7files/Afisha65/userimg/2006-11-14/16269753/g_dikari_small_02.jpg",
                  @"http://videofarm06g.kset.kz/uploaded/229/1789593_small.jpeg",
                  @"http://a0.fincake.ru/r1265031442/pictures/0000/1543/d_89_048_1_small.jpg",
                  @"http://t1.x-ix.ru/media/rules/images/signs/1.4.2.png",
                  @"http://t1.x-ix.ru/media/rules/images/signs/1.1.png",
                  @"http://t1.x-ix.ru/media/rules/images/signs/1.2.png",
                  @"http://t1.x-ix.ru/media/rules/images/signs/1.3.1.png",
                  @"http://t1.x-ix.ru/media/rules/images/signs/1.3.2.png",
                  @"http://t1.x-ix.ru/media/rules/images/signs/1.4.1.png",
                  @"http://t1.x-ix.ru/media/rules/images/signs/1.4.2.png",
                  @"http://t1.x-ix.ru/media/rules/images/signs/1.4.3.png",
                  @"http://t1.x-ix.ru/media/rules/images/signs/1.4.4.png",
                  @"http://t1.x-ix.ru/media/rules/images/signs/1.4.5.png"
];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BxLoadedImageViewItemCell";
    BxLoadedImageViewItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [cell.iconView setImageURL: self.data[indexPath.row]];
    
    return cell;
}

@end
