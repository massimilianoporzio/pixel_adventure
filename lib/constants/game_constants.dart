//GAME PROPS
import 'package:flame/components.dart';

const double kMapTileSize = 16.0;
const double kStepTime = 0.06;
const double kPlayerTileSize = 32.0;
const double kScrollSpeed = 40;

//BACKGROUND TILES
const double kBackgroundTileSize = 64.0;

//*TRAPS
//SAW
const String kSawName = "Saw";
const int kSawAmountOfSprites = 8;
const String kSawOnImage = "On (38x38).png";
const double kSawTileSize = 38.0;
const double kSawSpeed = 0.03;
const int kSawMoveSpeed = 50;

const Map<String, dynamic> sawProps = {
  kSawName: {
    'stepTime': kSawSpeed,
    'textureSize': kSawTileSize,
    'amountOfSprites': kSawAmountOfSprites,
  },
};

//*CHECKPOINTS
//CHECKPOINT
const String kCheckPointNoFlagName = 'Checkpoint (No Flag).png';
const double kCheckPointNoFlagStepTime = 1;
const int kCheckPoinNoFlagAmountOfSprites = 1;
const double kCheckPointTileSize = 64.0;
const String kCheckPointFlagIdleName = 'Checkpoint (Flag Idle)(64x64).png';
const int kCheckPointFlagIdleAmountOfSprites = 10;
const double kCheckPointFlagIdleStepTime = 0.05;

const String kCheckPointFlagOutName = 'Checkpoint (Flag Out) (64x64).png';
const int kCheckPointFlagOutAmountOfSprites = 26;
const double kCheckPointFlagOutStepTime = 0.05;

const Map<String, dynamic> checkpointProps = {
  'noFlag': {
    'stepTime': kCheckPointNoFlagStepTime,
    'textureSize': kCheckPointTileSize,
    'amountOfSprites': kCheckPoinNoFlagAmountOfSprites,
  },
  'flagIdle': {
    'stepTime': kCheckPointFlagIdleStepTime,
    'textureSize': kCheckPointTileSize,
    'amountOfSprites': kCheckPointFlagIdleAmountOfSprites,
  },
  'flagOut': {
    'stepTime': kCheckPointFlagOutStepTime,
    'textureSize': kCheckPointTileSize,
    'amountOfSprites': kCheckPointFlagOutAmountOfSprites,
  },
};

//*FRUITS
//names:
const String kAppleName = 'Apple';
const String kBananasName = 'Bananas';
const String kCherriesName = 'Cherries';
const String kCollectedName = 'Collected';
const String kKiwiName = 'Kiwi';
const String kMelonName = 'Melon';
const String kOrangeName = 'Orange';
const String kPineappleName = 'Pineapple';
const String kStrawberryName = 'Strawberry';

//comuni ma potrei averne diverse ad ogni frutto
const double kFruitStepTime = 0.028;
const double kFruitTileSize = 32.0;
const int kFruitAmountOfSprite = 17;
const int kCollectedAmountOfSprite = 6;

//props for every fruit
const Map<String, dynamic> fruitProps = {
  kAppleName: {
    'stepTime': kFruitStepTime,
    'textureSize': kFruitTileSize,
    'amountOfSprites': kFruitAmountOfSprite,
    'hitbox': {
      'offsetX': 10.0,
      'offsetY': 10.0,
      'width': 12.0,
      'height': 12.0,
    },
  },
  kBananasName: {
    'stepTime': kFruitStepTime,
    'textureSize': kFruitTileSize,
    'amountOfSprites': kFruitAmountOfSprite,
    'hitbox': {
      'offsetX': 10.0,
      'offsetY': 10.0,
      'width': 12.0,
      'height': 12.0,
    },
  },
  kCherriesName: {
    'stepTime': kFruitStepTime,
    'textureSize': kFruitTileSize,
    'amountOfSprites': kFruitAmountOfSprite,
    'hitbox': {
      'offsetX': 10.0,
      'offsetY': 10.0,
      'width': 12.0,
      'height': 12.0,
    },
  },
  kCollectedName: {
    'stepTime': kFruitStepTime,
    'textureSize': kFruitTileSize,
    'amountOfSprites': kCollectedAmountOfSprite,
    'hitbox': {
      'offsetX': 10.0,
      'offsetY': 10.0,
      'width': 12.0,
      'height': 12.0,
    },
  },
  kKiwiName: {
    'stepTime': kFruitStepTime,
    'textureSize': kFruitTileSize,
    'amountOfSprites': kFruitAmountOfSprite,
    'hitbox': {
      'offsetX': 10.0,
      'offsetY': 10.0,
      'width': 12.0,
      'height': 12.0,
    },
  },
  kMelonName: {
    'stepTime': kFruitStepTime,
    'textureSize': kFruitTileSize,
    'amountOfSprites': kFruitAmountOfSprite,
    'hitbox': {
      'offsetX': 10.0,
      'offsetY': 10.0,
      'width': 12.0,
      'height': 12.0,
    },
  },
  kOrangeName: {
    'stepTime': kFruitStepTime,
    'textureSize': kFruitTileSize,
    'amountOfSprites': kFruitAmountOfSprite,
    'hitbox': {
      'offsetX': 10.0,
      'offsetY': 10.0,
      'width': 12.0,
      'height': 12.0,
    },
  },
  kPineappleName: {
    'stepTime': kFruitStepTime,
    'textureSize': kFruitTileSize,
    'amountOfSprites': kFruitAmountOfSprite,
    'hitbox': {
      'offsetX': 10.0,
      'offsetY': 10.0,
      'width': 12.0,
      'height': 12.0,
    },
  },
  kStrawberryName: {
    'stepTime': kFruitStepTime,
    'textureSize': kFruitTileSize,
    'amountOfSprites': kFruitAmountOfSprite,
    'hitbox': {
      'offsetX': 10.0,
      'offsetY': 10.0,
      'width': 12.0,
      'height': 12.0,
    },
  },
};

//*ENEMIES PROPS
//NAMES
const String kChickenName = "Chicken";

const double kChickenSpeed = 90;

final Vector2 kChickenTileSize = Vector2(32, 34);
const double kChickenIdleStepTime = 0.055;
const int kChickenIdleSprites = 13;

const double kChickenRunStepTime = 0.04;
const int kChickenRunSprites = 14;

const double kChickenHitStepTime = 0.05;
const int kChickenHitSprites = 5;

//quanto rimbalza il player?
const double kChickenBounceHeight = 260;

//PROPS
final Map<String, dynamic> enemiesProps = {
  kChickenName: {
    'tileSize': Vector2(32, 34),
    'bounceHeight': kChickenBounceHeight,
    'animations': {
      'idle': {
        'amountOfSprites': kChickenIdleSprites,
        'stepTime': kChickenIdleStepTime,
      },
      'run': {
        'amountOfSprites': kChickenRunSprites,
        'stepTime': kChickenRunStepTime,
      },
      'hit': {
        'amountOfSprites': kChickenHitSprites,
        'stepTime': kChickenHitStepTime,
      }
    },
  }
};

//*CHARACTERS PROPS
//NAMES
const String kNinjaFrogName = "Ninja Frog";
const String kMaskDudeName = "Mask Dude";
const String kPinkManName = "Pink Man";
const String kVirtualGuyName = "Virtual Guy";
//PROPERTIES
const Map<String, dynamic> characterProps = {
  kAppearingName: {
    'tileSize': kAppearingTileSize,
    'amountOfSprites': kAppearingSprites,
    'stepTime': kAppearingStepTime,
  },
  kDisappearingName: {
    'tileSize': kDisappearingTileSize,
    'amountOfSprites': kDisappearingSprites,
    'stepTime': kDisappearingStepTime,
  },
  kNinjaFrogName: {
    'tileSize': kNinjaFrogTileSize,
    'hitbox': {
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
      'hit': {
        'amountOfSprites': kFallingNinjaFrogSprites,
        'stepTime': kNinjaFrogFallingStepTime
      },
    }
  },
  kMaskDudeName: {
    'tileSize': kMaskDudeTileSize,
    'hitbox': {
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
      'hit': {
        'amountOfSprites': kHitMaskDudeSprites,
        'stepTime': kMaskDudeHitStepTime
      },
    }
  },
  kPinkManName: {
    'tileSize': kPinkManTileSize,
    'hitbox': {
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
      'hit': {
        'amountOfSprites': kHitPinkManSprites,
        'stepTime': kPinkManHitStepTime
      },
    }
  },
  kVirtualGuyName: {
    'tileSize': kVirtualGuyTileSize,
    'hitbox': {
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
      'hit': {
        'amountOfSprites': kHitVirtualGuySprites,
        'stepTime': kVirtualGuyHitStepTime
      },
    }
  }
};

//*SPECIAL ANIMATIONS FOR ALL PLAYERS
const String kAppearingName = 'Appearing';
const double kAppearingTileSize = 96.0;
const int kAppearingSprites = 7;
const double kAppearingStepTime = 0.05;

const String kDisappearingName = 'Desappearing'; //spell error on assets...
const double kDisappearingTileSize = 96.0;
const int kDisappearingSprites = 7;
const double kDisappearingStepTime = 0.05;

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
//hit
const int kHitNinjaFrogSprites = 7;
const double kNinjaFrogHitStepTime = 0.05;

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
//hit
const int kHitMaskDudeSprites = 7;
const double kMaskDudeHitStepTime = 0.05;

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
//hit
const int kHitPinkManSprites = 7;
const double kPinkManHitStepTime = 0.05;

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
//hit
const int kHitVirtualGuySprites = 7;
const double kVirtualGuyHitStepTime = 0.05;
