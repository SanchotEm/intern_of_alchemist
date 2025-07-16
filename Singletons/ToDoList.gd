extends Node

## ToDoList Singleton
# This script is simply to organize the project work in the repo. 
# This will allow for faster collaboration. 

# To use:
# Go to test branch, review the TODO singleton, and assign yourself a task in the discord.
# Do not check out work you do not plan on completing within your coding session
# Create a branch for the task you're completeing.
# When code is complete, merge into test. 
# If you do not complete your branch by the time your session is up,
# make sure to commit your changes in case somebody else can pick it up.


# Round System:
# TODO: Add narrator coding into the round one (tutorial), for the narrator to greet the player & progress through round.
# TODO: Add some kind of visual indicator to click the grimoire
# TODO: Add some kind of way to to acknowledge the reviewing the recipe (mousing over a spot on the page seems good), after reviewing the round can start, but the player can come back to review the grimiore as needed.
# TODO: Each round the player successfully completes, the next recipe is unlocked. Linear progression model.


# Grimoire System:
# Recipe: 
# TODO: Redesign grimiore to show the (1) recipe and (2) order of operations with one recipe per page. Layout options based on art work. Blur or leave out lines that will be hinted by the narrator
# TODO: Right click signal to trigger narrator input on (1) ingredients, and (2) brewing tools


# Brewing System:
# Adding:
# TODO: Add ability for player to click to drag ingredients from a region on the screen (unlimited), then drag them into the cauldron when they want to for the recipe. 
# TODO: Add ingredient trash
# TODO: Add (1) stirring stick (2) stirring mechanic (a) clockwise and (b) counterclockwise with a counter on the pot. One full rotation = one stir for the recipes. 
# TODO: Add a heating / fire function. Player can drag a log onto the fire which burns for X seconds 
# TODO: Add three ingredient limit for now, can simply be defined in the recipe and the cauldron can check the recipe for the brewing requirements. 
# TODO: Add a completion "taste" button. Once the player "completes" the potion, they can click something to "taste" the potions.
# TODO: VFX/SFX & Narrartor provides feedback about success or failure to restart the round state or will proceed automatically to the next round
# TODO: Make sure ghost narrator blocks the player. 
# TODO: Once the player tastes the potion, either restart the round (with the negative effect) guided by the narrator, or move to the next round by the narrator with the positive effect


# Recipe System:
# TODO: Somewhat implemented, but refine needed. Create a recipe tracking system that gets the following data: a. Potion name, b. Potion description, c. Potion ingredients, d. Potion brewing order of operations (add ingredient, stir, heat), VFX/SFX that occur when completing, VFX/SFX that occur when tasting
# TODO: Add basic brewing failure/success VFX, as simple as possible for now, can refine later
# TODO: Make sure narrator system receives signals for narration when steps taken


# Ingredient System:
# TODO: Add new ingredient area with 6 ingredients to start (should be enough to get us going with plenty of combination options, we can always polish with more later). Ingredients should be clicked to spawn, or clicked and dragged in the players hand.
# TODO: Add new trash can to throw away unwanted ingredients
# TODO: Add new ingredients, can use the existing items as base and build off it
