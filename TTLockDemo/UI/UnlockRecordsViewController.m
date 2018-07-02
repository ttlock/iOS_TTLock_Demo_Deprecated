//
//  UnlockRecordsViewController.m
//  BTstackCocoa
//
//  Created by wan on 13-3-1.
//
//

#import "UnlockRecordsViewController.h"
#import "RequestService.h"
#import "AppDelegate.h"
#import "Define.h"
#import "UnlockRecordCell.h"
#import "UnlockRecord.h"
#import "XYCUtils.h"
@interface UnlockRecordsViewController ()
{
    
    
}

@end

@implementation UnlockRecordsViewController

@synthesize selectedKey;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = NSLocalizedString(@"keydetail_item_title_records", nil);
        
        NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"7.0" options: NSNumericSearch];
        if (order == NSOrderedSame || order == NSOrderedDescending)
        {
            // OS version >= 7.0
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        
    }
    
    return self;
}

-(void)backAction:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setExtraCellLineHidden:customTableView];
    
    [aiv startAnimating];
    
    [label_no_data setHidden:YES];
    
    records = [[NSMutableArray alloc]init];
   
    [self getData];
    
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(void)getData
{

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^(void){
        
        dispatch_sync(queue, ^(void){
            
            records = [RequestService requetUnlockRecords_roomID:selectedKey.lockId page:1];
            
        });
        
        dispatch_sync(dispatch_get_main_queue(), ^(void){
            
            [customTableView reloadData];
            [aiv stopAnimating];
            [aiv removeFromSuperview];

        });
        
    });
    
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
    
    return [records count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"unlockcell";
    UnlockRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"UnlockRecordCell"
                                              owner:self
                                            options:nil] lastObject];
        
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
    }
    
    
    UnlockRecord* record = [records objectAtIndex:indexPath.row];
    
    cell.label_unlcok_type.text = NSLocalizedString(@"words_unlock", nil);
    cell.label_operator.text = [NSString stringWithFormat:@"%@",record.openid];
    
    
    cell.label_date.text = [XYCUtils formateDate:record.date format:@"yyyy-MM-dd HH::mm"];
    
    NSLog(@"date:%@",record.date);
    
    return cell;
    
}


@end
