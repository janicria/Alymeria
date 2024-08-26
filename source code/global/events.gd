extends Node

## Card-related events
signal card_drag_started(card_ui : CardUI)
# Emitted when when a card enters the dragging state

signal card_drag_ended(card_ui : CardUI)
# Emitted when when a card exits the dragging state

signal card_aim_started(card_ui: CardUI)
# Emitted when when a card enters the aiming state

signal card_aim_ended(card_ui: CardUI)
# Emitted when when a card exits the aiming state

signal card_played(card : Card)
# Emitted when a card is played

signal card_tooltip_requested(card : Card)
# Makes Tooltip in Battle scence visible
# and edits its size and position

signal settings_tooltip_requested(text : String)
# Makes the SettingsTooltip in TopBar scene visible

signal tooltip_hide_requested
# Hides both Tooltips

signal update_card_tooltip_position(card : CardMenuUI)
# Moves the Tooltip in CardPileView scenes to not go off screen 
# when viewing the right-most card in a CardPile

signal update_card_pile(card_pile : CardPile)
signal open_card_pile(card_pile : Array[Node])
signal update_deck_buttons(amount : int, returning : bool)
signal update_deck_counter
signal update_card_stats

# Player-related events
signal player_draw_cards(amount : int)
signal player_hand_drawn
signal player_hand_discarded
signal player_hit
signal player_died

# Enemy-related events
signal enemy_action_completed(enemy : Enemy)
signal enemy_reload_targets
signal enemy_find_enemies(original_id : String, damage : int, repeats :int)
signal enemy_give_enemies(targets : Array[Node], original_id : String)
signal enemy_card_played
signal enemy_died(enemy: Enemy)
signal enemy_turn_ended

signal enemy_add_card(stats: EnemyCard)
# Adds an enemy card to play
# Summon-related events
signal summon_do_attack(id : String, amount : int, is_ability : bool)
signal remove_self_from_group(summon : Node)

# Battle-related events
signal battle_state_updated(state : Battle.BattleState)
signal battle_find_enemies()
signal battle_give_enemies(targets : Array[Node])
signal battle_won

# Map-related events
signal map_exited

# Shop-related events
signal shop_exited

# Haven-related events
signal haven_exited

# Battle Reward-related events
signal battle_reward_exited

# Treasure room-related events
signal treasure_room_exited

# Event-related events
signal events_extied
