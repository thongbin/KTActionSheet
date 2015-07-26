

//  Created by Kelvin Tong on 15/7/26.
//  Copyright (c) 2015年 com.thongbin. All rights reserved.


#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#import "KTActionSheet.h"
#import "UIImage+Blur.h"

@implementation UIView (rn_Screenshot)

- (UIImage *)rn_screenshot {
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImageJPEGRepresentation(image, 0.75);
    image = [UIImage imageWithData:imageData];
    return image;
}

@end

#define __rowHeight 50.0

@interface KTActionSheet()

@property(nonatomic,strong)CAShapeLayer *backgroundBlurLayer;
@end

@implementation KTActionSheet

-(CAShapeLayer *)backgroundBlurLayer
{
    if (!_backgroundBlurLayer) {
        
        UIImage *screenshotImage = [self.supViewController.navigationController.view rn_screenshot];
        screenshotImage = [screenshotImage applyBlurWithRadius:5 tintColor:UIColorFromRGBWithAlpha(0x000000, 0.8) saturationDeltaFactor:1.8 maskImage:nil];
        _backgroundBlurLayer = [CAShapeLayer layer];
        [_backgroundBlurLayer setFrame:self.bounds];
        [_backgroundBlurLayer setContents:(id)screenshotImage.CGImage];
        _backgroundBlurLayer.opacity = 0.0;
    }
    return _backgroundBlurLayer;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithlist:(NSArray *)list height:(CGFloat)height inView:(UIViewController*)supView ItemSelectedBlock:(ItemSelectedBlock)selectedBlock
{
    self = [super init];
    if(self){
        
        self.supViewController = supView;
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0);
        view = [[UITableView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth,__rowHeight * [list count]) style:UITableViewStylePlain];
        view.dataSource = self;
        view.delegate = self;
        [view setSeparatorInset:UIEdgeInsetsZero];
        [view setSeparatorColor:UIColorFromRGB(0xd8d8d8)];
        listData = list;
        view.scrollEnabled = NO;
        [self addSubview:view];
        [self.layer insertSublayer:self.backgroundBlurLayer below:view.layer];
        [self animeData];
        self.itemSelectedBlock = selectedBlock;
    }
    return self;
}

-(void)animeData{
    //self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
    [self addGestureRecognizer:tapGesture];
    tapGesture.delegate = self;
    [UIView animateWithDuration:.25 animations:^{
//        self.backgroundColor = RGBACOLOR(0, 0, 0, .6);
//        self.backgroundBlurLayer.opacity = 1.0;
        [UIView animateWithDuration:.25 animations:^{
            [view setFrame:CGRectMake(view.frame.origin.x, ScreenHeight-view.frame.size.height, view.frame.size.width, view.frame.size.height)];
        }];
    } completion:^(BOOL finished) {
    }];
    
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue=[NSNumber numberWithFloat:0.0];
    animation.toValue=[NSNumber numberWithFloat:1.0];
    animation.duration=.2;
    animation.removedOnCompletion = NO;
    animation.fillMode=kCAFillModeForwards;
    [_backgroundBlurLayer addAnimation:animation forKey:@"opacity"];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if([touch.view isKindOfClass:[self class]]){
        return YES;
    }
    return NO;
}

-(void)tappedCancel{
    
    [UIView animateWithDuration:.25 animations:^{
        [view setFrame:CGRectMake(0, ScreenHeight,ScreenWidth, 0)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (void)show
{
    if(self.supViewController == nil){
        [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
    }else{
    //[view addSubview:self];
        [self.supViewController.navigationController.view addSubview:self];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return __rowHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    KTActionSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        cell = [[KTActionSheetCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setItemTitle:[listData objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self tappedCancel];
    
//    if(_delegate!=nil && [_delegate respondsToSelector:@selector(sheet:didSelectIndex:)]){
//        [_delegate sheet:self didSelectIndex:indexPath.row];
//        return;
//    }
    if (self.itemSelectedBlock) {
        self.itemSelectedBlock(self,indexPath.row);
    }
}

@end

@implementation KTActionSheetCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        InfoLabel = [[UILabel alloc]init];
        [InfoLabel setTextAlignment:NSTextAlignmentCenter];
        InfoLabel.backgroundColor = [UIColor clearColor];
        [InfoLabel setFont:[UIFont lanTingHei_BWithSize:16.0]];
        [InfoLabel setTextColor:UIColorFromRGBWithAlpha(0xF35350,1.0)];
        [self.contentView addSubview:InfoLabel];
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = UIColorFromRGBWithAlpha(0xd8d8d8, 0.1);
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    InfoLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

-(void)setItemTitle:(NSString *)title
{
    InfoLabel.text = title;
    if ([title isEqualToString:@"取消"]) {
        [InfoLabel setTextColor:[UIColor lightGrayColor]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}

-(UIEdgeInsets)separatorInset
{
    return UIEdgeInsetsZero;
}

@end