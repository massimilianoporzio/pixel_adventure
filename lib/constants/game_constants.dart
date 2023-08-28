//GAME PROPS
const double kTileSize = 16.0;
const double kStepTime = 0.06;
const double kPlayerTileSize = 32.0;
const double kScrollSpeed = 0.4;

//BACKGROUND TILES
const double kBackgroundTileSize = 64.0;

//*CHARACTERS NAME
const String kNinjaFrogName = "Ninja Frog";
const String kMaskDudeName = "Mask Dude";
const String kPinkManName = "Pink Man";
const String kVirtualGuyName = "Virtual Guy";

const Map<String, dynamic> characterProps = {
  kNinjaFrogName: {
    'tileSize': kNinjaFrogTileSize,
    'hitBox': {
      'offsetX': 10.0,
      'offsetY': 4.0,
      'width': 14.0,
      'height': 28.0,
    },
    'animations': {
      'idle': {
        'amountOfSprites': kIdleNinjaFrogSprites,
        'stepTime': kNinjaFrogIdleStepTime
      },
      'running': {
        'amountOfSprites': kRunningNinjaFrogSprites,
        'stepTime': kNinjaFrogRunningStepTime
      },
      'jumping': {
        'amountOfSprites': kJumpingNinjaFrogSprites,
        'stepTime': kNinjaFrogJumpingStepTime
      },
      'falling': {
        'amountOfSprites': kFallingNinjaFrogSprites,
        'stepTime': kNinjaFrogFallingStepTime
      },
    }
  },
  kMaskDudeName: {
    'tileSize': kMaskDudeTileSize,
    'hitBox': {
      'offsetX': 10.0,
      'offsetY': 4.0,
      'width': 14.0,
      'height': 28.0,
    },
    'animations': {
      'idle': {
        'amountOfSprites': kIdleMaskDudeSprites,
        'stepTime': kMaskDudeIdleStepTime
      },
      'running': {
        'amountOfSprites': kRunningMaskDudeSprites,
        'stepTime': kMaskDudeRunningStepTime
      },
      'jumping': {
        'amountOfSprites': kJumpingMaskDudeSprites,
        'stepTime': kMaskDudeJumpingStepTime
      },
      'falling': {
        'amountOfSprites': kFallingMaskDudeSprites,
        'stepTime': kMaskDudeFallingStepTime
      },
    }
  },
  kPinkManName: {
    'tileSize': kPinkManTileSize,
    'hitBox': {
      'offsetX': 10.0,
      'offsetY': 4.0,
      'width': 14.0,
      'height': 28.0,
    },
    'animations': {
      'idle': {
        'amountOfSprites': kIdlePinkManSprites,
        'stepTime': kPinkManIdleStepTime
      },
      'running': {
        'amountOfSprites': kRunningPinkManSprites,
        'stepTime': kPinkManRunningStepTime
      },
      'jumping': {
        'amountOfSprites': kJumpingPinkManSprites,
        'stepTime': kPinkManJumpingStepTime
      },
      'falling': {
        'amountOfSprites': kFallingPinkManSprites,
        'stepTime': kPinkManFallingStepTime
      },
    }
  },
  kVirtualGuyName: {
    'tileSize': kVirtualGuyTileSize,
    'hitBox': {
      'offsetX': 10.0,
      'offsetY': 4.0,
      'width': 14.0,
      'height': 28.0,
    },
    'animations': {
      'idle': {
        'amountOfSprites': kIdleVirtualGuySprites,
        'stepTime': kVirtualGuyIdleStepTime
      },
      'running': {
        'amountOfSprites': kRunningVirtualGuySprites,
        'stepTime': kVirtualGuyRunningStepTime
      },
      'jumping': {
        'amountOfSprites': kJumpingVirtualGuySprites,
        'stepTime': kVirtualGuyJumpingStepTime
      },
      'falling': {
        'amountOfSprites': kFallingVirtualGuySprites,
        'stepTime': kVirtualGuyFallingStepTime
      },
    }
  }
};

//*NINJA FROG
const double kNinjaFrogTileSize = 32.0;
//idle
const double kNinjaFrogIdleStepTime = 0.06;
const int kIdleNinjaFrogSprites = 11;
//running
const int kRunningNinjaFrogSprites = 12;
const double kNinjaFrogRunningStepTime = 0.05;
//jumping
const int kJumpingNinjaFrogSprites = 1;
const double kNinjaFrogJumpingStepTime = 0.05;
//falling
const int kFallingNinjaFrogSprites = 1;
const double kNinjaFrogFallingStepTime = 0.05;

//*MASK DUDE
const double kMaskDudeTileSize = 32.0;
//idle
const double kMaskDudeIdleStepTime = 0.06;
const int kIdleMaskDudeSprites = 11;
//running
const int kRunningMaskDudeSprites = 12;
const double kMaskDudeRunningStepTime = 0.05;
//jumping
const int kJumpingMaskDudeSprites = 1;
const double kMaskDudeJumpingStepTime = 0.05;
//falling
const int kFallingMaskDudeSprites = 1;
const double kMaskDudeFallingStepTime = 0.05;

//*PINK MAN
const double kPinkManTileSize = 32.0;
//idle
const double kPinkManIdleStepTime = 0.06;
const int kIdlePinkManSprites = 11;
//running
const int kRunningPinkManSprites = 12;
const double kPinkManRunningStepTime = 0.05;
//jumping
const int kJumpingPinkManSprites = 1;
const double kPinkManJumpingStepTime = 0.05;
//falling
const int kFallingPinkManSprites = 1;
const double kPinkManFallingStepTime = 0.05;

//*VIRTUAL GUY
const double kVirtualGuyTileSize = 32.0;
//idle
const double kVirtualGuyIdleStepTime = 0.06;
const int kIdleVirtualGuySprites = 11;
//running
const int kRunningVirtualGuySprites = 12;
const double kVirtualGuyRunningStepTime = 0.05;
//jumping
const int kJumpingVirtualGuySprites = 1;
const double kVirtualGuyJumpingStepTime = 0.05;
//falling
const int kFallingVirtualGuySprites = 1;
const double kVirtualGuyFallingStepTime = 0.05;
