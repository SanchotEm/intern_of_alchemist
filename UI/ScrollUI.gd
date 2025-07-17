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
@onready var stats_page_label: Label = %StatsPageLabel
@onready var stats_label: Label = %StatsLabel

var recipe_pages: Array = []
var current_page_index: int = 0
var total_pages: int = 0

func _ready() -> void:
	SignalBus.grimoire_clicked.connect(_on_grimoire_clicked)
	x_button.pressed.connect(_on_x_button_pressed)
	right_button.pressed.connect(_on_right_button_pressed)
	left_button.pressed.connect(_on_left_button_pressed)
	hide()

func _update_page_display() -> void:
	if recipe_pages.is_empty() and total_pages <= 1:
		_display_stats_page()
	elif current_page_index < recipe_pages.size():
		_display_recipe_page()
	else:
		_display_stats_page()
	var buttons_disabled = total_pages <= 1
	right_button.disabled = buttons_disabled
	left_button.disabled = buttons_disabled

func _display_recipe_page() -> void:
	recipe_name_label.show()
	recipe_instructions_label.show()
	recipe_tags_label.show()
	recipe_page_label.show()
	stats_label.hide()
	stats_page_label.hide()

	var current_recipe: Dictionary = recipe_pages[current_page_index]
	recipe_name_label.text = current_recipe.get("name", "Unnamed Recipe")
	recipe_instructions_label.text = current_recipe.get("instructions", "No instructions available.")
	
	var tags_text: String = ", ".join(current_recipe.get("tags", []))
	recipe_tags_label.text = "Tags: %s" % tags_text
	recipe_page_label.text = "Page %d / %d" % [current_page_index + 1, total_pages]

func _display_stats_page() -> void:
	recipe_name_label.hide()
	recipe_instructions_label.hide()
	recipe_tags_label.hide()
	recipe_page_label.hide()
	stats_label.show()
	stats_page_label.show()
	var stats_string_builder: PackedStringArray = []
	if StatTracking:
		var all_stats: Dictionary = StatTracking.get_all_stats()
		for stat_name in all_stats:
			var value = all_stats[stat_name]
			var formatted_name = stat_name.replace("_", " ").capitalize()
			stats_string_builder.append("%s: %s" % [formatted_name, value])
	
	stats_label.text = "\n".join(stats_string_builder)
	stats_page_label.text = "Page %d / %d" % [total_pages, total_pages]

func _on_right_button_pressed() -> void:
	if total_pages == 0: return
	current_page_index = (current_page_index + 1) % total_pages
	_update_page_display()

func _on_left_button_pressed() -> void:
	if total_pages == 0: return
	current_page_index = (current_page_index - 1 + total_pages) % total_pages
	_update_page_display()

func _on_grimoire_clicked() -> void:
	recipe_pages = Interface.recipes.values()
	total_pages = recipe_pages.size() + 1
	current_page_index = 0
	_update_page_display()
	show()

func _on_x_button_pressed() -> void:
	hide()
