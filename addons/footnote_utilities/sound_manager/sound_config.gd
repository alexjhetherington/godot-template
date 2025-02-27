extends Resource
class_name SoundConfig

@export var audio_stream : AudioStream
@export var volume_db : float = 0
@export var pitch : float = 1
@export var attenuation : Attenuation = Attenuation.NON_SPATIAL
@export var unit_size : float = 10
@export var max_vol_for_3d : float = 3
@export var aliases : String

var bus : String

enum Attenuation {INV, INV_SQUARE, LOG, CONSTANT, NON_SPATIAL}
