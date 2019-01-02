# ETChannelEditor

`ETChannelEditor` is a clean and easy-to-use Channel editor to manager the channels on iOS.

![ETChannelEditor](https://github.com/JRJian/ETChannelEditor/blob/master/Snapshots/s1.png)

## Installation

### Manually

* Drag the `ETChannelEditor/ETChannelEditor` folder into your project.

## Usage

(see sample Xcode project in `/Demo`)

Using `ETChannelEditor` in your app will usually look as simple as this:

```objective-c
NSArray *pinChannels = @[@"Hot", @"Popular", @"Bilingual", @"China",
                             @"Business", @"Opinion", @"World", @"Culture",
                             @"Life", @"Travel", @"Sports", @"Video",
                             @"Special", @"Service", @"Newspaper"];
    
NSArray *unpinChannels = @[@"NBA", @"Trend", @"Tech", @"Music"];

ETChannelEditor *editor = [[ETChannelEditor alloc] initWithFrame:rect
                                                     pinChannels:pinChannels
                                                   unpinChannels:unpinChannels];

[editor setCanMoveChannelHandler:^BOOL(ETChannel * _Nonnull channel) {
    if ([channel isEqualToString:@"Hot"])
        return NO;
    return YES;
}];

[editor setDidSelectChannelHandler:^(ETChannel * _Nonnull channel) {
    NSLog(@"click at %@", channel);
}];

[self.view addSubview:editor];
```

## Contributing to this project

If you have feature requests or bug reports, feel free to help out by sending pull requests or by [creating new issues](https://github.com/ETChannelEditor/ETChannelEditor/issues/new). 

## License

`ETChannelEditor` is distributed under the terms and conditions of the [MIT license](https://github.com/SVProgressHUD/SVProgressHUD/blob/master/LICENSE). The success, error and info icons are made by [Freepik](http://www.freepik.com) from [Flaticon](http://www.flaticon.com) and are licensed under [Creative Commons BY 3.0](http://creativecommons.org/licenses/by/3.0/).