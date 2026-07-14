# RoundService Documentation

## Overview

- **Author:** sharafzada
- **Class:** `RoundService.luau`
- **Version:** `1.0.2`

RoundService is the server-side system that handles the entire process of rounds from creation, to UI updates, and lifecycle events. The system determines active player's and which team eventually win's the game.

**What RoundService Does:**
- Tracks active players in-game
- Determines the winning team
- Assign's player's to different team's
- Track's the till a match end's
- Notifies other systems when a match begins/starts

**What RoundService Does NOT Do:**
- Change the player's avatar
- Update UI directly (done VIA UIService link)
- Handle rewards

## Architecture
```
Service Required
       |
       v
RoundService (Orchestrator)
       |
       +----> _main()
                  |
                  v
       Enough Players?
                  |
          +-------+-------+
          |               |
         No              Yes
          |               |
          |        Create Round
          |               |
          |               v
          |        Round.new(...)
          |               |
          |               v
          |     Round:AssignTeams()
          |               |
          |               v
          |     Round:StartRound()
          |               |
          |               v
          |      Round Internal Loop
          |               |
          |               v
          |      Round:Tick() every second
          |               |
          |               v
          |      Round Finished?
          |               |
          |        +------+------+
          |        |             |
          |       No            Yes
          |        |             |
          |        |      RoundEnded Signal
          |        |             |
          |        +-------------+
          |                      |
          +----------------------+
                                 |
                                 v
                    RoundService Cleanup
                                 |
                                 v
                        Begin Intermission
                                 |
                                 v
                          Repeat Process
```

## File Organization
```
src/modules/Server/RoundService
├── Classes/
│   └── Round.luau              # Base round class
├── init.luau                   # Entry point, returns RoundService
├── RoundService.luau           # High-level coordinator
├── Types.luau                  # Additional types for RoundService & Modules
└── RoundServiceProfile.luau    # Additional helper functions
```

## Files Breakdown

### Core Files

#### `RoundService.luau`
The main orchestrator for the round system. This is the only file external code should interact with directly.

**Responsibilities:**
- ServiceBag lifecycle (`Init`, `Destroy`)
- Runs the main round loop (`_main`)
- Waits for the minimum player count before starting rounds
- Creates and destroys `Round` instances
- Starts rounds and intermissions
- Responds to player joins and leaves
- Coordinates with `TeamService` for team creation and cleanup
- Updates clients through `RemoteEvents`
- Observes `Round` signals (`RoundBegan`, `RoundEnded`)
- Coordinates the overall round lifecycle

#### `RoundServiceProfile.luau`
Additional helper functions for RoundService.luau and sub-modules.

#### `Types.luau`
Type definitions for all data structures.

#### `RoundServiceConstants.luau`
Central configuration for all tunable values.

```lua
DEBUG = false,
MINIMUM_PLAYERS = 2,

-- Round Information
RoundNames = {
	INTERMISSION_ROUND_NAME = "Intermission",
	BASE_ROUND_NAME = "Round",
},
INTERMISSION_DURATION = 10,
POST_GAME_DURATION = 10,
ROUND_DURATION = 5, -- Expressed in seconds

-- Team Names
Teams = {
    TEAM_RED = {
        TEAM_NAME = "Hunters",
        TEAM_COLOUR = BrickColor.Red(),
    },
    TEAM_BLUE = {
        TEAM_NAME = "Hiders",
        TEAM_COLOUR = BrickColor.Blue(),
    },
},

-- Reward Data
BASE_CASH_AMOUNT = 100,
BASE_XP_AMOUNT = 100,
CASH_MULTIPLIER = 5,
XP_MULTIPLIER = 5,
```

## API Reference Summary

### RoundService methods

| Method | Returns | Description |
|--------|---------|-------------|
| `InitializeRound(roundName, roundDuration, ...)` | void | Initalize's a new round |

### Signals

| Signal | Parameters | Description |
|--------|------------|-------------|
| `RoundEnded` | roundName | Round ending |
| `RoundBegan` | roundName | Round starting |