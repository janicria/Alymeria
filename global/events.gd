extends Node

# FIXME: Everything

## Card-related events
signal card_drag_started(card_ui : CardUI)
signal card_drag_ended(card_ui : CardUI)
signal card_aim_started(card_ui: CardUI)
signal card_aim_ended(card_ui: CardUI)
signal card_played(card : Card)
signal update_card_pile(card_pile : CardPile)
signal open_card_pile(card_pile : Array[Node])
signal update_deck_buttons(amount : int, returning : bool)
signal update_deck_counter
signal update_card_stats
signal update_card_variant(variant: String, value: int, where: String)

## Player-related events
signal player_draw_cards(amount : int)
signal player_hand_drawn
signal player_hand_discarded
signal player_hit
signal player_died
signal update_player_dmg_counter(amount: int, reset :bool)

## Enemy-related events
signal enemy_action_completed(enemy : Enemy)
signal enemy_reload_targets
signal enemy_card_played
signal enemy_died(enemy: Enemy)
signal enemy_turn_ended
signal enemy_add_card(stats: EnemyCard)

## UI-related events
signal update_settings_visibility(state: bool)
signal toggle_console_visible()

## Summon-related events
signal summon_do_attack(id : String, amount : int, is_ability : bool)
signal remove_self_from_group(summon : Node)

## Battle-related events
signal battle_state_updated(state : Battle.BattleState)
signal battle_find_enemies()
signal battle_give_enemies(targets : Array[Node])
signal battle_won
signal battle_request_player_turn

## Tooltip-related events
# Makes the SettingsTooltip in TopBar scene visible
signal settings_tooltip_requested(text : String)

# Hides both regular and Settings tooltips
signal tooltip_hide_requested

# Makes Tooltip in Battle scence visible then edits its size and position
signal card_tooltip_requested(card : Card)

# Moves the Tooltip in CardPileView scenes to not go off screen 
# when viewing the right-most card in a CardPile
signal update_card_tooltip_position(card : CardMenuUI)


## Map-related events
signal map_exited(current_room: Room)

## Shop-related events
signal shop_exited

## Haven-related events
signal haven_exited

## Battle Reward-related events
signal battle_reward_exited

# Treasure room-related events
signal treasure_room_exited

# Event-related events
signal events_extied
