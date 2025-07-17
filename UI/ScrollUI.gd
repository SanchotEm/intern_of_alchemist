## Scroll UI Controller
# Will manage paging system for recipes.
extends Control

@onready var x_button: TextureButton = %ScrollXButton
@onready var page_label: Label = %PageLabel
@onready var recipe_name_label: Label = %RecipeNameLabel
@onready var recipe_instructions_label: Label = %RecipeInstructionsLabel
@onready var recipe_tags_label: Label = %RecipeTagsLabel
@onready var right_button: TextureButton = %ScrollRightButton
@onready var left_button: TextureButton = %ScrollLeftButton

var recipe_pages: Array = []
var current_page_index: int = 0

func _ready() -> void:
	SignalBus.grimoire_clicked.connect(_on_grimoire_clicked)
	x_button.pressed.connect(_on_x_button_pressed)
	right_button.pressed.connect(_on_right_button_pressed)
	left_button.pressed.connect(_on_left_button_pressed)
	hide()

func _update_page_display() -> void:
	if recipe_pages.is_empty():
		recipe_name_label.text = "No Recipes Known"
		recipe_instructions_label.text = "Discover new recipes through experimentation!"
		recipe_tags_label.text = ""
		page_label.text = "Page 0 / 0"
		right_button.disabled = true
		left_button.disabled = true
		return
	right_button.disabled = false
	left_button.disabled = false
	var current_recipe: Dictionary = recipe_pages[current_page_index]
	recipe_name_label.text = current_recipe.get("name", "Unnamed Recipe")
	recipe_instructions_label.text = current_recipe.get("instructions", "No instructions available.")
	var tags_text: String = ", ".join(current_recipe.get("tags", []))
	recipe_tags_label.text = "Tags: %s" % tags_text
	page_label.text = "Page %d / %d" % [current_page_index + 1, recipe_pages.size()]

func _on_right_button_pressed() -> void:
	if recipe_pages.is_empty(): return
	current_page_index += 1
	if current_page_index >= recipe_pages.size():
		current_page_index = 0
	_update_page_display()

func _on_left_button_pressed() -> void:
	if recipe_pages.is_empty(): return 
	current_page_index -= 1
	if current_page_index < 0:
		current_page_index = recipe_pages.size() - 1
	_update_page_display()

func _on_grimoire_clicked() -> void:
	recipe_pages = Interface.recipes.values()
	current_page_index = 0
	_update_page_display()
	show()

func _on_x_button_pressed() -> void:
	hide()
