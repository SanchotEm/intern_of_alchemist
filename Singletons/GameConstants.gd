## GameConstants - Autoload
extends Node

#region Audio Control
const MIN_VOLUME_VALUE: int = 1
const MAX_VOLUME_VALUE: int = 100

const DEFAULT_MAIN_VOLUME: int = 30
const DEFAULT_MUSIC_VOLUME: int = 30
const DEFAULT_SFX_VOLUME: int = 30
const DEFAULT_NARRATOR_VOLUME: int = 30
#endregion 

#region Text Control
const TEXT_SPEED :float = 35 #amount of characters that become visible per second
const TEXT_TIME_TO_DISAPPEAR :float = 2 #time in seconds the speech buble will wait bere disappearing, in seconds
#Will disappear ater all text is shown or the voice finishes speaking, wichever happens last
#Won't matter if the speech bubble is deliberately dismissed with a click
#endregion
