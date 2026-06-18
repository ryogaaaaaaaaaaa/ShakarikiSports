extends SceneTree


func _init():
	var packed = load("res://scenes/Main.tscn")
	if packed == null:
		push_error("Main scene could not be loaded.")
		quit(1)
		return
	var game = packed.instantiate()
	root.add_child(game)
	await process_frame
	game.sfx.clear()
	game.start_run()
	game.play_card(0)
	game.try_jump(1.0)
	game.change_lane(1)
	for i in range(180):
		game._process(1.0 / 60.0)
	if game.deck.size() < 10:
		push_error("Deck was not initialized.")
		quit(1)
		return
	if game.hp <= 0 and game.screen != game.Screen.GAME_OVER:
		push_error("HP/screen state mismatch.")
		quit(1)
		return
	for stage in range(5):
		game.hitstop_timer = 0.0
		game.distance = float(game.STAGES[game.stage_index]["length"]) - 0.1
		game._process(0.2)
		if game.screen != game.Screen.REWARD:
			push_error("Expected reward screen after stage %s, got %s." % [stage, game.screen])
			quit(1)
			return
		game.choose_reward(0)
		game.sfx.clear()
	game.hitstop_timer = 0.0
	game.distance = float(game.STAGES[game.stage_index]["length"]) - 0.1
	game._process(0.2)
	if game.screen != game.Screen.WIN:
		push_error("Expected win screen after final stage, got %s." % game.screen)
		quit(1)
		return
	print("Smoke OK: screen=%s stage=%s deck=%s score=%s" % [game.screen, game.stage_index, game.deck.size(), game.score])
	root.remove_child(game)
	game.queue_free()
	await process_frame
	quit(0)
