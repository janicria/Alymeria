extends Node

## Card-related events
signal card_drag_started(card_ui : CardUI) # Used by card_ui, tooltip
signal card_drag_ended(card_ui : CardUI) # Used by card_ui, tooltip
signal card_aim_started(card_ui: CardUI) # Used by card_ui, card_target_selector, tooltip
signal card_aim_ended(card_ui: CardUI) # Used by card_ui, card_target_selector, tooltip
signal player_card_played(card: Card) # Used by PlayerHandler and SummonAction
signal update_card_pile(card_pile : CardPile) # Used by settings_bar
signal update_deck_button_ui() # Used by card_pile_button
signal update_draw_card_ui # Used by repurposing & card
signal update_card_variant(variant: String, value: int) # Used by hand
signal update_hand_state() # Used by hand to check if a the player has cancel
signal player_card_drawn # Used by godroll (needs to be a global)

## Player-related events
signal player_draw_cards(amount : int) # Used by player_handler
signal player_hand_drawn # Used by battle_ui
signal player_hand_discarded # Used by battle
signal player_hit # Used by red_flash
signal update_player_dmg_counter(amount: int, reset :bool) # Used by player

## Enemy-related events
signal enemy_died(enemy: Enemy) # Used by enemy_card_ui to edit its ui
signal update_battle_stats() # Emitted by console window (not visible in Ctrl+shift+F)

## UI-related events
signal toggle_console_visible() # Used by console (not visible via search)

## Battle-related events
signal update_battle_state(state: Battle.State) # Used by battle, battle_over_panel, Main
signal update_turn_number(number: int) # Used by battle_ui, Data

## Tooltip-related events
signal show_tooltip(text: String) # Used by tooltp
signal hide_tooltip # Used by tooltip

## Floor exited-related events
signal shop_exited # Used by Main
signal shop_entered() # Used by Bargaining Chip
signal haven_exited # Used by Main
signal battle_reward_exited # Used by Main
signal treasure_room_exited # Used by Main
signal events_extied # Used by Main


func _init() -> void: 
	process_mode = PROCESS_MODE_ALWAYS
