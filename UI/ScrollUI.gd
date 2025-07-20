## Scroll UI Controller
# Manages the paging system for both recipes and the final stats page.
extends Control

@onready var x_button: TextureButton = %ScrollXButton
@onready var right_button: TextureButton = %ScrollRightButton
@onready var left_button: TextureButton = %ScrollLeftButton

# Recipe Page UI
@onready var recipe_page_label: Label = %RecipePageLabel
@onready var recipe_name_label: Label = %RecipeNameLabel
@onready var recipe_instructions_label: Label = %RecipeInstructionsLabel
@onready var recipe_tags_label: Label = %RecipeTagsLabel

# Stats Page UI Elements


var recipe_pages: Array = []
var current_page_index: int = 0
var total_pages: int = 0

func _ready() -> void:
	SignalBus.grimoire_opened.connect(_on_grimoire_opened)
	x_button.pressed.connect(_on_x_button_pressed)
	right_button.pressed.connect(_on_right_button_pressed)
	left_button.pressed.connect(_on_left_button_pressed)
	hide()

func _update_page_display() -> void:
	left_button.visible = current_page_index > 0
	right_button.visible = current_page_index < total_pages - 1
	_display_recipe_page()
	var buttons_disabled = total_pages <= 1
	right_button.disabled = buttons_disabled
	left_button.disabled = buttons_disabled

func _display_recipe_page() -> void:
	recipe_name_label.show()
	recipe_instructions_label.show()
	recipe_tags_label.show()
	recipe_page_label.show()

	var current_recipe: Dictionary = recipe_pages[current_page_index]
	recipe_name_label.text = current_recipe.get("name", "Unnamed Recipe")
	recipe_instructions_label.text = current_recipe.get("instructions", "No instructions available.")
	
	var tags_text: String = ", ".join(current_recipe.get("tags", []))
	recipe_tags_label.text = "Tags: %s" % tags_text
	recipe_page_label.text = "Page %d / %d" % [current_page_index + 1, total_pages]


	

func _on_right_button_pressed() -> void:
	if total_pages == 0: return
	current_page_index = (current_page_index + 1) % total_pages
	_update_page_display()

func _on_left_button_pressed() -> void:
	if total_pages == 0: return
	current_page_index = (current_page_index - 1 + total_pages) % total_pages
	_update_page_display()

func _on_grimoire_opened() -> void:
	recipe_pages = Interface.recipes.values()
	total_pages = recipe_pages.size() + 1
	current_page_index = 0
	_update_page_display()
	show()

func _on_x_button_pressed() -> void:
	hide()
