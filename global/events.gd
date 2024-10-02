extends Node

## Card-related events
signal card_drag_started(card_ui : CardUI) # Used by card_ui, tooltip
signal card_drag_ended(card_ui : CardUI) # Used by card_ui, tooltip
signal card_aim_started(card_ui: CardUI) # Used by card_ui, card_target_selector, tooltip
signal card_aim_ended(card_ui: CardUI) # Used by card_ui, card_target_selector, tooltip
signal card_played(card : Card) # Used by player_handler
signal update_card_pile(card_pile : CardPile) # Used by settings_bar
signal update_deck_buttons(amount : int, returning : bool) # Used by card_pile_view, card_pile_button
signal update_deck_counter # Used by card_pile_button
signal update_card_stats # Used by repurposing
signal update_card_variant(variant: String, value: int, where: String) # Used by hand

## Player-related events
signal player_draw_cards(amount : int) # Used by player_handler
signal player_hand_drawn # Used by battle_ui
signal player_hand_discarded # Used by battle
signal player_hit # Used by red_flash
signal player_died # Used by battle
signal update_player_dmg_counter(amount: int, reset :bool) # Used by player

## Enemy-related events
signal enemy_card_played # Used by enemy_hand
signal enemy_died(enemy: Enemy) # Used by enemy_card_ui

## UI-related events
signal update_settings_visibility(state: bool) # Used by run
signal toggle_console_visible() # Used by console (not visible via search)

## Battle-related events
signal battle_state_updated(state : Battle.BattleState) # Used by battle, battle_over_panel
signal battle_won # Used by run
signal battle_request_player_turn # Used by battle

## Tooltip-related events
signal settings_tooltip_requested(text : String) # Used by tooltp (makes visible)
signal tooltip_hide_requested # Used by tooltip

# Makes Tooltip in Battle scence visible then edits its size and position
signal card_tooltip_requested(card : Card) # Used by card_rewards, card_pile_view, card_tooltip, tooltip

signal update_card_tooltip_position(card : CardMenuUI) # Used by card_pile_View (Moves it to not go offscreen)

## Floor exited-related events
signal map_exited(current_room: Room) # Used by run
signal shop_exited # Used by run
signal haven_exited # Used by run
signal battle_reward_exited # Used by run
signal treasure_room_exited # Used by run
signal events_extied # Used by run
