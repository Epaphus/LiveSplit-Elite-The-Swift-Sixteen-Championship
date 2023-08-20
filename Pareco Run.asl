// Defines the process to monitor. We are not reading anything from the game’s memory, so it’s empty.
// We still need it though, LiveSplit will only run the auto splitter if the corresponding process is present.
// See https://github.com/LiveSplit/LiveSplit.AutoSplitters/blob/master/README.md#state-descriptors
state("EliteDangerous64") {}

// Executes when LiveSplit (re-)loads the auto splitter. Does general setup tasks.
// See https://github.com/LiveSplit/LiveSplit.AutoSplitters/blob/master/README.md#script-startup
startup {
	// Relevant journal entries
	vars.journalReader = null;
	vars.journalEntries = new Dictionary<string, System.Text.RegularExpressions.Regex>();
	vars.journalEntries["start"] =
		new System.Text.RegularExpressions.Regex(@"\{ ""timestamp"":""(?<timestamp>.*)"", ""event"":""Undocked"", ""StationName"":""Neville Ring"", ""StationType"":"".*"", ""MarketID"":\d+(, ""Taxi"":(true|false), ""Multicrew"":(true|false))? \}");
	vars.journalEntries["docked"] =
		new System.Text.RegularExpressions.Regex(@"\{ ""timestamp"":""(?<timestamp>.*)"", ""event"":""Docked"", ""StationName"":""(?<station>.*)"", ""StationType"":"".*""(, ""Taxi"":(true|false), ""Multicrew"":(true|false))?, ""StarSystem"":""Pareco"", .*\}");
	vars.journalEntries["died"] =
		new System.Text.RegularExpressions.Regex(@"\{ ""timestamp"":""(?<timestamp>.*)"", ""event"":""Died"" .*\}");

	// List of stations in a lap
	vars.stations = (new string[] { "Phillips Market", "Webb Station", "Asire Dock", "Crown Orbital", "Garden Ring", "Neville Ring" }).ToList();

	// Stopwatch for keeping track of the elapsed time; time limit is 20 minutes
	vars.stopWatch = new System.Diagnostics.Stopwatch();
	vars.timeLimit = new System.TimeSpan(0, 20, 0); // 20 minutes

	// Since there is no technical “last split”, we need some way to stop the timer when the time is up
	vars.finished = false;

	// Initialize stops counter
	vars.stops = 0;

	// Initialize docking counter file
	vars.logFile = new FileInfo(Path.Combine(
			Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments),
			"LiveSplit",
			"Swift-16 Championship",
			"Pareco Run",
			"stops.txt")
		);
	vars.writeStops = (Action)delegate () {
		Directory.CreateDirectory(vars.logFile.Directory.FullName);
		File.WriteAllText(vars.logFile.FullName, vars.stops.ToString());
	};

	// Initialize settings
	settings.Add("writeStops", false, "Write the number of stops to a file, e.g. for a stream overlay");
	settings.SetToolTip("writeStops", "You will find the file at " + vars.logFile.FullName);
	settings.Add("autoReset", true, "Automatically reset when docking back at Garden Ring");
	settings.Add("resetOnDeath", false, "Automatically stop the timer after death");
	settings.SetToolTip("resetOnDeath", "Will also reset once you dock at Garden Ring afterwards if auto reset is enabled");

	// Journal file handling
	vars.journalPath = Path.Combine(
		Environment.GetFolderPath(Environment.SpecialFolder.UserProfile),
		"Saved Games",
		"Frontier Developments",
		"Elite Dangerous"
		);
	vars.currentJournal = "none";
	vars.updateJournalReader = (Action)delegate() {
		FileInfo journalFile = new DirectoryInfo(vars.journalPath).GetFiles("journal.*.log").OrderByDescending(file => file.LastWriteTime).First();
		print("Current journal file: " + vars.currentJournal + ", latest journal file: " + journalFile.Name);
		if (journalFile.Name != vars.currentJournal) {
			vars.journalReader = new StreamReader(new FileStream(journalFile.FullName, FileMode.Open, FileAccess.Read, FileShare.ReadWrite));
			vars.currentJournal = journalFile.Name;
		}
	};
	vars.updateJournalReader();
	vars.journalReader.ReadToEnd();

	// Watch for new files
	FileSystemWatcher journalWatcher = new FileSystemWatcher(vars.journalPath);
	journalWatcher.Created += (object sender, FileSystemEventArgs eventArgs) => {
		vars.updateJournalReader();
	};
	journalWatcher.EnableRaisingEvents = true;

	// Initialize split counter
	vars.currentSplit = 0;
}

// Executes when LiveSplit detects the game process (see “state” at the top of the file).
// In our case the journal and netlog files are unique to every execution of the game, so we need to prepare them here.
// We also need to check if file logging is enabled (the setting is not available in `startup`) and create/open our log file.
// See https://github.com/LiveSplit/LiveSplit.AutoSplitters/blob/master/README.md#script-initialization-game-start
init {
}

// Executes as long as the game process is running, by default 60 times per second.
// Unless explicitly returning `false`, `start`, `split` and `reset` are executed right after.
// See https://github.com/LiveSplit/LiveSplit.AutoSplitters/blob/master/README.md#generic-update
update {
	current.journalString = vars.journalReader.ReadToEnd();
	if (settings["resetOnDeath"] && !String.IsNullOrEmpty(current.journalString)
		&& vars.journalEntries["died"].Match(current.journalString).Success) {
		vars.finished = true;
	}
}

// Executes every `update`. Starts the timer if undocking from Neville Ring is detected.
// See https://github.com/LiveSplit/LiveSplit.AutoSplitters/blob/master/README.md#automatic-timer-start-1
start {
	bool start = false;

	if (vars.journalEntries["start"].Match(current.journalString).Success) {
		start = true;
		vars.finished = false;
		vars.stops = 0;
		if (settings["writeStops"]) {
			vars.writeStops();
		}
		
		vars.stopWatch = System.Diagnostics.Stopwatch.StartNew();
	}

	return start;
}

// Executes every `update`. Triggers a split if docking at the next station in the current lap is detected.
// See https://github.com/LiveSplit/LiveSplit.AutoSplitters/blob/master/README.md#automatic-splits-1
split {
	bool split = false;
	
	if (!String.IsNullOrEmpty(current.journalString)) {
		System.Text.RegularExpressions.Match match = vars.journalEntries["docked"].Match(current.journalString);
		if (match.Success) {
			if (match.Groups["station"].Value == vars.stations[vars.stops % vars.stations.Count]) {
				split = true;
				vars.stops++;
				if (settings["writeStops"]) {
					vars.writeStops();
				}
				if (vars.stopWatch.Elapsed > vars.timeLimit) {
					vars.finished = true;
				}
			}
		}
	}

	return split;
}

// Executes every `update`. Triggers a reset if a dock at Garden Ring is detected after the 20 minute time limit has
// run out.
// See https://github.com/LiveSplit/LiveSplit.AutoSplitters/blob/master/README.md#automatic-resets-1
reset {
	bool reset = false;

	if (vars.finished && settings["autoReset"] && !String.IsNullOrEmpty(current.journalString)) {
		System.Text.RegularExpressions.Match match = vars.journalEntries["docked"].Match(current.journalString);
		if (match.Success) {
			// Since you can do one last dock after the time limit has been reached, we can _not_ reset on docking at
			// Neville Ring if that is the next stop in your current lap. Otherwise `split` is not executed.
			if (match.Groups["station"].Value == "Neville Ring"
				&& vars.stations[vars.stops % vars.stations.Count] != "Neville Ring") {
				reset = true;
				vars.stops = 0;
				if (settings["writeStops"]) {
					vars.writeStops();
				}
				vars.stopWatch.Reset();
			}
		}
	}

	return reset;
}

// This one is technically used to pause the timer while a game is loading; we can abuse this to stop the timer after
// the time limit has been passed.
// See https://github.com/LiveSplit/LiveSplit.AutoSplitters/blob/5efb4201b86e4cba0f0e10e096f6049b947c6ff5/README.md#load-time-removal
isLoading {
	return vars.finished;
}

// Executes when the game process is shut down.
// In our case we’re going to close the files we opened in `init`.
// See https://github.com/LiveSplit/LiveSplit.AutoSplitters/blob/master/README.md#game-exit
exit {
	vars.journalReader.Close();
}

// Executes when LiveScript shuts the auto splitter down, e.g. on reloading it.
// When reloading the splitter with the game running, LiveSplit does **not** execute `exit`, but it does execute `shutdown`.
// see https://github.com/LiveSplit/LiveSplit.AutoSplitters/blob/master/README.md#script-shutdown
shutdown {
	if (vars.journalReader != null) {
		vars.journalReader.Close();
	}
}
