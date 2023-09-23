# LiveSplit files for the The Swift Sixteen Championship

LiveSplit files and AutoSplitters for the The Swift Sixteen Championship organized by the Buckyball Racing Club: <https://forums.frontier.co.uk/threads/the-buckyball-racing-club-presents-season-2-the-swift-sixteen-championship.615358/>

Don’t know what [“LiveSplit”](https://livesplit.org) is? It allows you to time speedruns of your favourite games!

Based up on the LiveSplit files created by [alterNERDtive](https://github.com/alterNERDtive/LiveSplit-Elite-Magic-8-Ball-Championship) for the Magic 8-Ball Championship 

## Setup

1. Download LiveSplit from <https://livesplit.org/downloads/> and unzip it to a directory of your choosing.
2. Download this repository (green button in the top right of the repostory view → “Download ZIP”) and extract it to a directory of your choosing. Alternatively, clone the git repository.
3. Launch LiveSplit and do the following:
   - Right click, Open Splits, select `[name of the race].lss`.
   - Right click, Open Layout, select `[name of the race].lsl`.
   - Right click, Edit Layout, Layout Settings, then in “Scriptable Auto Splitter”, set `[name of the race].asl` as the script path.
4. Right click, Save Layout As…, save to wherever. This means your changes in the layout (e.g. changing colours) and associating the auto splitter will not be lost on updates.
5. Right click, Save Splits As…, save to wherever. This ensures that your personal times will not be lost on updates.

**Please note times provided by Livesplit are for your own referance, Buckyball offical timing is done via the in-game clock.**


## Races

### Race 6 – Braking Badly

<https://forums.frontier.co.uk/threads/the-buckyball-racing-club-presents.619912/>

The AutoSplitter will start the timer once you undock from the Fleet Carrier "A1A Car Wash" or "Los Pollos Hermanos"

Since the order in which you visit the race’s stops is up to you, the splits do not have a specific order and instead just list the `n`th stop.


### Race 5 - Pareco Run

<https://forums.frontier.co.uk/threads/the-buckyball-racing-club-presents-pareco-run-swift-16-championship-race-5.619312/>

The AutoSplitter will start the timer once you undock from Neville Ring. It will enforce docking at the race’s stations in the correct order. After 20 minutes you get one last stop, then the timer will pause and reset once you dock back at Neville Ring.

There are three settings:

- `Write the number of stops to a file, e.g. for a stream overlay`: Does exactly that. You can find the file in `My Documents`, the full path will be in the tooltip. Disabled by default.
- `Automatically reset when docking back at Neville Ring`: Automatically reset when you have finished a run and dock back at Neville Ring. Enabled by default.
- `Automatically stop the timer after death`: Automatically stop the timer should you meet an untimely demise. Disabled by default.

**Note**: If your _next stop is Neville Ring_ when the time limit is reached, you will either have to reset LiveSplit manually after docking there or re-dock to have the AutoSplitter reset it for you.  
If you are using a custom layout you will need to make sure the timing method under the timer settings is set to use "game time" instead of "real time" for the 20 minute timer to work correctly.

### Race 4 – Double Trouble

<https://forums.frontier.co.uk/threads/the-buckyball-racing-club-presents-double-trouble-swift-16-championship-race-4.618478/>

The AutoSplitter will start the timer once you undock from Hoshide Dock 

Since the order in which you visit the race’s stops is up to you, the splits do not have a specific order and instead just list the `n`th stop.

### Race 3 – Tunnel-ish Vision

<https://forums.frontier.co.uk/threads/the-buckyball-racing-club-presents-tunnel-ish-vision-swift-16-championship-race-3.617429/>

The AutoSplitter will start the timer once you undock from Gaensler Station. 

Since the order in which you visit the race’s stops is up to you, the splits do not have a specific order and instead just list the `n`th stop.  
**Note:** Splits will be triggered if you drop out near the orbiting body instead of at the Installations/Captial Ships. For example if you crash into the planet.

### Race 2 – The Empire Hustle

<https://forums.frontier.co.uk/threads/the-buckyball-racing-club-presents-thargoid-structure-scramble-2-swift-16-championship-race-2.616507/>

The AutoSplitter will start the timer once you undock from Artemis Lodge.

Since you can pick any Thargoid sites, after collecting the sensor the splits will be based on landing and leaving the Thargoid sites rather than normal jump to system ones until you get back to Celaeno.


### Race 1 – The Empire Hustle

<https://forums.frontier.co.uk/threads/the-buckyball-racing-club-presents-the-empire-hustle-8th-16th-april-3309-swift-sixteen-championship-race-1.615693/>

The AutoSplitter will start the timer once you undock from Agnews` Folly. 

Since the order in which you visit the race’s stops is up to you, the splits do not have a specific order and instead just list the `n`th stop.



