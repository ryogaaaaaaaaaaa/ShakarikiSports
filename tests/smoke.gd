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
	await pump_to_decision_or_result(game)
	var decisions = 0
	while game.screen != game.Phase.RESULT and decisions < 8:
		if game.screen != game.Phase.DECISION:
			push_error("Expected decision phase, got %s." % game.screen)
			quit(1)
			return
		play_segment_plan(game)
		game.confirm_decision()
		decisions += 1
		await pump_to_decision_or_result(game)
	if game.screen != game.Phase.RESULT:
		push_error("Stage did not reach result screen.")
		quit(1)
		return
	if decisions != 6:
		push_error("Expected 6 decisions, got %s." % decisions)
		quit(1)
		return
	if game.score <= 0:
		push_error("Score was not updated.")
		quit(1)
		return
	print("Smoke OK: result=%s decisions=%s score=%s gap=%.2f stamina=%.1f" % [game.result_title, decisions, game.score, game.gap_seconds, game.kuro_stamina])
	root.remove_child(game)
	game.queue_free()
	await process_frame
	quit(0)


func pump_to_decision_or_result(game):
	for i in range(420):
		game._process(1.0 / 60.0)
		await process_frame
		if game.screen == game.Phase.DECISION or game.screen == game.Phase.RESULT:
			return


func play_segment_plan(game):
	var plans = [
		["draft", "tempo"],
		["daigo_pull", "draft", "tempo"],
		["naruse_attack", "dance", "chase"],
		["draft", "tempo"],
		["leadout", "draft", "tempo"],
		["sprint", "chase", "tempo"]
	]
	var order = plans[min(game.segment_index, plans.size() - 1)]
	for wanted in order:
		for i in range(game.hand.size()):
			if game.hand[i] == wanted and game.card_condition_failed(wanted) == "":
				game.play_card(i)
				break
