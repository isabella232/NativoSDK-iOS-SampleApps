# NativoSDK-iOS-SampleApps

There are three sample apps available that are each implemented differently to show you a variety of options for how you might integrate with the Nativo SDK:

**Infinite Scroll (ObjC)** - Uses UITableView in Obj-C to display articles using the NativoSDK TableView API. Uses Nib files or dynamic prototype cells for ad templates. Articles includes bottom-of-article placement ad unit.<br/>
**Table View (Swift)** - A simple news feed using a UITableView with the NativoSDK View API. Uses dynamic prototype cells. Articles included bottom-of-article placement ad unit. <br/>
**Collection View (Swift)** - Uses UICollectionView to display articles using the NativoSDK CollectionView API. Uses self-sizing dynamic prototype cells. Articles include middle-of-article placement ad unit. <br/>
**GAM Integration (Swift)** - The same codebase as the Table View sample, except integrated with Google Ad Manager platform set to run creatives using a "Nativo tag" that ultimately places a Nativo ad in the feed.


## Setup

All apps require [Cocoapods be installed](https://cocoapods.org/). From terminal:

    cd <app path>
    pod install


## Documentation

Please refer to [sdk.nativo.com](https://sdk.nativo.com/docs/getting-started-ios) for our complete guide.


