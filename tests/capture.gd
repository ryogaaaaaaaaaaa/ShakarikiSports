extends SceneTree


func _init():
	var packed = load("res://scenes/Main.tscn")
	var game = packed.instantiate()
	root.add_child(game)
	await process_frame
	await process_frame
	var title_image = root.get_viewport().get_texture().get_image()
	title_image.save_png("res://tmp/title_capture.png")
	game.sfx.clear()
	game.start_run()
	for i in range(12):
		game._process(1.0 / 60.0)
		await process_frame
	var race_image = root.get_viewport().get_texture().get_image()
	race_image.save_png("res://tmp/race_capture.png")
	root.remove_child(game)
	game.queue_free()
	await process_frame
	quit(0)

