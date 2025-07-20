extends Resource
class_name ItemData

@export var item_id: String
@export var item_name: String
@export var description: String
@export var Icon : Texture2D
@export var sprite : Texture2D
@export var tags :Array[String]
@export var item_sound : AudioStream = load("uid://dn860qydk3h3v")
@export var scale_factor: float = 1.0
