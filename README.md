# KTActionSheet
Custom ActionSheet With Blocks

##Usage

	KTActionSheet *sheet = [[KTActionSheet alloc]initWithlist:@[@"确认退出",@"取消"] height:0
	inView:self ItemSelectedBlock:^(KTActionSheet *sheet,NSInteger index)
	{
		[self sheet:sheet didSelectIndex:index];
	}];
	[sheet show];

![img](/img.png)