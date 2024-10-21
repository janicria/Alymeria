extends Node

## Card-related events
signal card_drag_started(card_ui : CardUI) # Used by card_ui, tooltip
signal card_drag_ended(card_ui : CardUI) # Used by card_ui, tooltip
signal card_aim_started(card_ui: CardUI) # Used by card_ui, card_target_selector, tooltip
signal card_aim_ended(card_ui: CardUI) # Used by card_ui, card_target_selector, tooltip
signal card_played(card : Card) # Used by player_handler
signal update_card_pile(card_pile : CardPile) # Used by settings_bar
signal update_deck_button_ui() # Used by card_pile_button`
signal update_draw_card_ui # Used by repurposing
signal update_card_variant(variant: String, value: int) # Used by hand
signal update_hand_state() # Used by hand to check if a the player has cancel
signal player_card_drawn # Used by godroll (needs to be a global)

## Player-related events
signal player_draw_cards(amount : int) # Used by player_handler
signal player_hand_drawn # Used by battle_ui
signal player_hand_discarded # Used by battle
signal player_hit # Used by red_flash
signal update_player_dmg_counter(amount: int, reset :bool) # Used by player
signal player_card_played # Used by file corruption to add nano

## Enemy-related events
signal enemy_died(enemy: Enemy) # Used by enemy_card_ui to edit its ui
signal update_battle_stats() # Emitted by console window (not visible in Ctrl+shift+F)

## UI-related events
signal toggle_console_visible() # Used by console (not visible via search)

## Battle-related events
signal update_battle_state(state: Battle.BattleState) # Used by battle, battle_over_panel, run
signal update_turn_number(number: int) # Used by battle_ui, gamemanager

## Tooltip-related events
signal show_tooltip(text: String) # Used by tooltp
signal hide_tooltip # Used by tooltip

## Floor exited-related events
signal map_exited(current_room: Room) # Used by run
signal shop_exited # Used by run
signal haven_exited # Used by run
signal battle_reward_exited # Used by run
signal treasure_room_exited # Used by run
signal events_extied # Used by run


func _init() -> void: process_mode = PROCESS_MODE_ALWAYS
