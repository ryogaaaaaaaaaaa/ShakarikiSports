extends Control

enum Screen { TITLE, RACE, REWARD, GAME_OVER, WIN }

const LANES = [405.0, 478.0, 552.0]
const PLAYER_X = 230.0
const PX_PER_METER = 0.78
const MAX_HAND = 5

const TEAM_RIDERS = [
	{
		"id": "daigo",
		"name": "大吾",
		"en_name": "Daigo",
		"role": "牽引役",
		"en_role": "Rouleur",
		"body": "大型",
		"en_body": "Big engine",
		"max_stamina": 112.0,
		"pull": 1.16,
		"shelter": 1.28,
		"climb": 0.84,
		"sprint": 0.78,
		"corner": 0.86,
		"recovery": 0.92,
		"color": Color(0.35, 0.95, 1.0)
	},
	{
		"id": "naruse",
		"name": "鳴瀬",
		"en_name": "Naruse",
		"role": "クライマー",
		"en_role": "Climber",
		"body": "軽量",
		"en_body": "Featherweight",
		"max_stamina": 98.0,
		"pull": 0.91,
		"shelter": 0.92,
		"climb": 1.24,
		"sprint": 0.82,
		"corner": 1.08,
		"recovery": 1.08,
		"color": Color(0.62, 1.0, 0.45)
	},
	{
		"id": "kurokawa",
		"name": "黒川",
		"en_name": "Kurokawa",
		"role": "スプリンター",
		"en_role": "Sprinter",
		"body": "爆発型",
		"en_body": "Fast-twitch",
		"max_stamina": 104.0,
		"pull": 0.98,
		"shelter": 1.0,
		"climb": 0.78,
		"sprint": 1.28,
		"corner": 0.92,
		"recovery": 0.96,
		"color": Color(1.0, 0.34, 0.22)
	}
]

const STAGES = [
	{
		"name": "Act 1-1 Riverside Paceline",
		"tag": "FLAT",
		"length": 2800.0,
		"grade": 0.1,
		"wind": 0.35,
		"curve": 0.22,
		"surface": "asphalt",
		"flavor": "A flat opener. Rotate the pull and feel the draft."
	},
	{
		"name": "Act 1-2 Crosswind Farm Road",
		"tag": "WIND",
		"length": 3350.0,
		"grade": 0.0,
		"wind": 0.95,
		"curve": 0.18,
		"surface": "open fields",
		"flavor": "The wind hits from the side. Hide the light riders."
	},
	{
		"name": "Act 2-1 Olive Switchbacks",
		"tag": "CLIMB",
		"length": 3900.0,
		"grade": 1.35,
		"wind": 0.28,
		"curve": 0.78,
		"surface": "mountain road",
		"flavor": "Steep bends. The climber wants the front."
	},
	{
		"name": "Act 2-2 Canyon Descent",
		"tag": "DESCENT",
		"length": 4200.0,
		"grade": -1.15,
		"wind": 0.45,
		"curve": 0.9,
		"surface": "descent",
		"flavor": "Fast corners. Control the cadence before the road bites."
	},
	{
		"name": "Act 3-1 Industrial Crit Loop",
		"tag": "CRIT",
		"length": 4550.0,
		"grade": 0.25,
		"wind": 0.62,
		"curve": 1.05,
		"surface": "city circuit",
		"flavor": "Hard turns and short straights. Leadout timing matters."
	},
	{
		"name": "Final: Chainbreak Pass",
		"tag": "FINAL",
		"length": 5200.0,
		"grade": 0.55,
		"wind": 0.75,
		"curve": 0.72,
		"surface": "mixed",
		"flavor": "One last road. Spend every rider, but not too soon."
	}
]

const CARD_LIBRARY = {
	"rotate": {
		"name": "Rotate the Pull",
		"cost": 3,
		"duration": 5.0,
		"color": Color(0.35, 0.9, 1.0),
		"desc": "Swap leader. 5s smooth paceline, less front fatigue.",
		"rarity": "common"
	},
	"tempo": {
		"name": "Tempo Call",
		"cost": 8,
		"duration": 8.0,
		"color": Color(1.0, 0.72, 0.34),
		"desc": "8s higher cadence and steady speed.",
		"rarity": "common"
	},
	"shelter": {
		"name": "Big Man Shelter",
		"cost": 6,
		"duration": 9.0,
		"color": Color(0.34, 1.0, 0.82),
		"desc": "9s stronger draft behind the leader.",
		"rarity": "common"
	},
	"climber_pull": {
		"name": "Climber Takes Point",
		"cost": 7,
		"duration": 8.0,
		"color": Color(0.62, 1.0, 0.42),
		"desc": "8s Naruse leads. Great on climbs.",
		"rarity": "common"
	},
	"corner": {
		"name": "Inside Line",
		"cost": 5,
		"duration": 6.0,
		"color": Color(0.7, 0.55, 1.0),
		"desc": "6s corner control. Converts curves into flow.",
		"rarity": "common"
	},
	"echelon": {
		"name": "Echelon Order",
		"cost": 8,
		"duration": 9.0,
		"color": Color(0.45, 0.95, 1.0),
		"desc": "9s crosswind formation. Back riders save legs.",
		"rarity": "uncommon"
	},
	"feed": {
		"name": "Pass a Gel",
		"cost": 0,
		"duration": 0.0,
		"color": Color(1.0, 0.85, 0.28),
		"desc": "Recover weakest rider. Draw 1.",
		"rarity": "common"
	},
	"shift": {
		"name": "Clean Shift",
		"cost": 4,
		"duration": 7.0,
		"color": Color(0.92, 0.96, 0.78),
		"desc": "7s stable cadence. Draw 1.",
		"rarity": "common"
	},
	"recover": {
		"name": "Soft Pedal",
		"cost": 2,
		"duration": 8.0,
		"color": Color(0.82, 0.9, 1.0),
		"desc": "8s lower pace, back riders recover fast.",
		"rarity": "uncommon"
	},
	"aero": {
		"name": "Aero Tuck",
		"cost": 7,
		"duration": 7.0,
		"color": Color(0.38, 0.62, 1.0),
		"desc": "7s descent and headwind speed.",
		"rarity": "uncommon"
	},
	"leadout": {
		"name": "Leadout Train",
		"cost": 12,
		"duration": 7.0,
		"color": Color(1.0, 0.38, 0.22),
		"desc": "7s protect Kurokawa, then punch speed.",
		"rarity": "rare"
	},
	"chainbreak": {
		"name": "Chainbreak Order",
		"cost": 18,
		"duration": 5.0,
		"color": Color(1.0, 0.18, 0.14),
		"desc": "5s all-out command. Huge speed, heavy drain.",
		"rarity": "rare"
	}
}

const REWARD_CARDS = [
	"rotate", "tempo", "shelter", "climber_pull", "corner", "echelon",
	"feed", "shift", "recover", "aero", "leadout", "chainbreak"
]

const RELIC_LIBRARY = {
	"shimanagi_synchro": {
		"name": "SHIMANAGI Synchro-11",
		"maker": "SHIMANAGI",
		"desc": "Component group. Card load -1 and cadence stabilizes."
	},
	"valcorsa_strada": {
		"name": "Valcorsa Strada",
		"maker": "Valcorsa",
		"desc": "Italian-style climbing frame. Better grade and corner control."
	},
	"keystone_crit": {
		"name": "Keystone Crit",
		"maker": "Keystone",
		"desc": "American aero frame. Faster flats and leadouts."
	},
	"northline_boreal": {
		"name": "Northline Boreal",
		"maker": "Northline",
		"desc": "Canadian endurance frame. More stamina and crosswind comfort."
	}
}

const RELIC_IDS = ["shimanagi_synchro", "valcorsa_strada", "keystone_crit", "northline_boreal"]

const STAGE_JA = [
	{
		"name": "Act 1-1 川沿いローテーション",
		"flavor": "平坦の開幕。先頭交代とドラフトを体で覚えろ。"
	},
	{
		"name": "Act 1-2 横風の農道",
		"flavor": "横から風が叩く。軽い選手を隠せ。"
	},
	{
		"name": "Act 2-1 オリーブのつづら折り",
		"flavor": "急坂と連続カーブ。クライマーが前を求めている。"
	},
	{
		"name": "Act 2-2 キャニオン・ダウンヒル",
		"flavor": "高速コーナー。道に噛まれる前に回転を整えろ。"
	},
	{
		"name": "Act 3-1 工業地帯クリット",
		"flavor": "鋭い曲がり角と短い直線。リードアウトの時間だ。"
	},
	{
		"name": "Final: チェーンブレイク峠",
		"flavor": "最後の道。全員の脚を使い切れ、早すぎるな。"
	}
]

const CARD_JA = {
	"rotate": {"name": "先頭交代", "desc": "先頭を交代。5秒間ローテ安定、前の疲労軽減。"},
	"tempo": {"name": "テンポ指示", "desc": "8秒間ケイデンス上昇、速度を安定。"},
	"shelter": {"name": "大柄の風よけ", "desc": "9秒間、後ろのドラフト効果アップ。"},
	"climber_pull": {"name": "クライマー前へ", "desc": "8秒間、鳴瀬が牽引。登りで強い。"},
	"corner": {"name": "インを突け", "desc": "6秒間コーナー制御。カーブをフローに変える。"},
	"echelon": {"name": "エシュロン隊列", "desc": "9秒間、横風隊列。後ろの脚を守る。"},
	"feed": {"name": "ジェルを渡す", "desc": "一番弱った選手を回復。1枚ドロー。"},
	"shift": {"name": "クリーンシフト", "desc": "7秒間ケイデンス安定。1枚ドロー。"},
	"recover": {"name": "脚をゆるめろ", "desc": "8秒間ペースを落とし、後ろを大きく回復。"},
	"aero": {"name": "エアロタック", "desc": "7秒間、下りと向かい風で速度上昇。"},
	"leadout": {"name": "リードアウト列車", "desc": "7秒間、黒川を守って最後に加速。"},
	"chainbreak": {"name": "チェーンブレイク指示", "desc": "5秒間全開。巨大加速、消耗大。"}
}

const RELIC_JA = {
	"shimanagi_synchro": {"name": "シマナギ Synchro-11", "desc": "コンポ一式。カード負荷-1、ケイデンスが安定。"},
	"valcorsa_strada": {"name": "ヴァルコルサ Strada", "desc": "イタリア気質の登坂フレーム。勾配とコーナーに強い。"},
	"keystone_crit": {"name": "キーストーン Crit", "desc": "アメリカンなエアロフレーム。平坦とリードアウトが伸びる。"},
	"northline_boreal": {"name": "ノースライン Boreal", "desc": "カナディアン耐久フレーム。スタミナと横風耐性が上がる。"}
}

const HAZARD_JA = {}

const UI_TEXT = {
	"en": {
		"subtitle": "ROGUELITE CYCLING",
		"tagline": "Call the rotation. Save the legs. Break the final road.",
		"start": "START RUN",
		"title_controls": "Space: rotate pull   W/S or arrows: cadence   1-5: orders   L: language",
		"title_note": "3 riders, timed team orders, frame/component rewards, wind, curves, and climbs.",
		"lang_button": "日本語",
		"stage_clear": "Stage Clear",
		"reward_prompt": "Choose a team order or bike part for the next road.",
		"deck_summary": "Deck: %s orders   Parts: %s   Score: %s",
		"race_over": "RACE OVER",
		"retry": "Press R / Enter / Space to run it back.",
		"win_title": "PHOTO FINISH!",
		"win_body": "Your trio held the line and broke the final pass.",
		"win_retry": "Press R / Enter / Space for another route.",
		"result_stats": "Score %s   Best combo x%s   Stage %s/6",
		"win_stats": "Score %s   Best combo x%s   Deck %s   Parts %s",
		"score": "Score %s",
		"guard": "Guard %s",
		"save": "Save %s",
		"cost": "Load %s",
		"slow": "SLOW",
		"touch_up": "CAD+",
		"touch_down": "CAD-",
		"touch_hop": "PULL",
		"added": "Added %s",
		"installed": "Installed %s",
		"crashed": "Team cracked on %s",
		"stamina": "STAMINA",
		"speed": "SPEED %.1f",
		"distance": "DISTANCE",
		"leader": "PULL",
		"protected": "DRAFT",
		"cadence": "CAD %s",
		"grade": "GRADE %+.1f%%",
		"wind": "WIND %.1f",
		"curve": "CURVE %.1f",
		"formation": "FORM %s",
		"active_orders": "ORDERS",
		"no_legs": "NO LEGS",
		"rotate_call": "%s pulls through",
		"weak_recover": "%s recovered",
		"flow": "FLOW x%s",
		"team_cracked": "The group split apart.",
		"stage_bonus": "Team tempo bonus +%s"
	},
	"ja": {
		"subtitle": "ローグライト・サイクリング",
		"tagline": "ローテを指示し、脚を残し、最後の道を叩き割れ。",
		"start": "ラン開始",
		"title_controls": "Space: 先頭交代   W/S/矢印: ケイデンス   1-5: 指示カード   L: 言語",
		"title_note": "3人チーム、数秒間の指示、フレーム/コンポ報酬、風・カーブ・勾配。",
		"lang_button": "ENGLISH",
		"stage_clear": "ステージクリア",
		"reward_prompt": "次の道へ持っていくチーム指示か自転車パーツを選択。",
		"deck_summary": "デッキ: %s指示   パーツ: %s   スコア: %s",
		"race_over": "レース終了",
		"retry": "R / Enter / Space で再挑戦。",
		"win_title": "フォトフィニッシュ!",
		"win_body": "3人の脚をつなぎ、最後の峠を割った。",
		"win_retry": "R / Enter / Space で別ルートへ。",
		"result_stats": "スコア %s   最大コンボ x%s   ステージ %s/6",
		"win_stats": "スコア %s   最大コンボ x%s   デッキ %s   パーツ %s",
		"score": "スコア %s",
		"guard": "ガード %s",
		"save": "保険 %s",
		"cost": "負荷 %s",
		"slow": "減速",
		"touch_up": "回転+",
		"touch_down": "回転-",
		"touch_hop": "交代",
		"added": "%s を追加",
		"installed": "%s を装着",
		"crashed": "%s でチーム崩壊",
		"stamina": "スタミナ",
		"speed": "速度 %.1f",
		"distance": "距離",
		"leader": "先頭",
		"protected": "温存",
		"cadence": "CAD %s",
		"grade": "勾配 %+.1f%%",
		"wind": "風 %.1f",
		"curve": "カーブ %.1f",
		"formation": "隊列 %s",
		"active_orders": "指示中",
		"no_legs": "脚がない",
		"rotate_call": "%s が前へ",
		"weak_recover": "%s 回復",
		"flow": "フロー x%s",
		"team_cracked": "集団が千切れた。",
		"stage_bonus": "チームテンポボーナス +%s"
	}
}

var screen = Screen.TITLE
var rng = RandomNumberGenerator.new()
var language = "ja"

var bg_texture
var rider_texture
var atlas_texture
var card_texture
var ui_font
var sfx = {}

var stage_index = 0
var distance = 0.0
var speed = 24.0
var rival_distance = 0.0
var rival_speed = 25.0
var rival_lane = 1
var rival_lane_visual = 1.0
var rival_last_gap = 0.0
var rival_flash_timer = 0.0
var rival_beaten = 0
var last_stage_rival_result = ""
var burst = 0.0
var stamina = 100.0
var max_stamina = 100.0
var team = []
var leader_index = 0
var target_cadence = 86.0
var cadence = 86.0
var formation = "paceline"
var active_commands = {}
var road_grade = 0.0
var road_wind = 0.0
var road_curve = 0.0
var road_tilt = 0.0
var road_phase = 0.0
var team_pressure = 0.0
var crack_timer = 0.0
var stage_result = ""
var hp = 3
var max_hp = 3
var score = 0
var combo = 0
var best_combo = 0
var guard = 0
var revive_tokens = 0
var lucky_helmet_ready = false

var lane = 1
var lane_visual = 1.0
var lane_cooldown = 0.0
var air_height = 0.0
var vertical_velocity = 0.0
var on_ground = true

var deck = []
var draw_pile = []
var hand = []
var discard = []
var reward_choices = []
var relics = []
var obstacles = []
var particles = []

var draw_timer = 0.0
var next_obstacle_distance = 220.0
var race_message = ""
var message_timer = 0.0
var death_reason = ""

var hitstop_timer = 0.0
var shake_timer = 0.0
var shake_strength = 0.0
var flash_timer = 0.0
var pulse_timer = 0.0
var flow_timer = 0.0

var draft_timer = 0.0
var brake_timer = 0.0
var evade_timer = 0.0
var wheelie_timer = 0.0
var predict_timer = 0.0
var climb_timer = 0.0
var tempo_timer = 0.0

var hand_rects = []
var reward_rects = []
var team_rects = []
var start_button_rect = Rect2()
var touch_up_rect = Rect2()
var touch_down_rect = Rect2()
var touch_jump_rect = Rect2()
var language_button_rect = Rect2()
var selected_card_index = -1
var selected_card_pinned = false
var selected_card_rect = Rect2()
var suppress_mouse_click_timer = 0.0


func _ready():
	rng.randomize()
	ui_font = ResourceLoader.load("res://assets/fonts/MPLUS1p-Regular.ttf")
	if ui_font == null:
		var dynamic_font = FontFile.new()
		if dynamic_font.load_dynamic_font("res://assets/fonts/MPLUS1p-Regular.ttf") == OK:
			ui_font = dynamic_font
	if ui_font != null:
		add_theme_font_override("font", ui_font)
	bg_texture = load_texture_file("res://assets/generated/background_neon_downhill.png")
	rider_texture = load_texture_file("res://assets/generated/rider_sprinter.png")
	atlas_texture = load_texture_file("res://assets/generated/object_atlas.png")
	card_texture = load_texture_file("res://assets/generated/card_cadence.png")
	_load_sfx()
	mouse_filter = Control.MOUSE_FILTER_STOP
	set_process(true)


func load_texture_file(path):
	var resource = ResourceLoader.load(path, "Texture2D")
	if resource != null:
		return resource
	var image = Image.new()
	var err = image.load(path)
	if err != OK:
		return null
	return ImageTexture.create_from_image(image)


func _load_sfx():
	var names = ["card", "near_miss", "crash", "pickup", "stage_clear", "win"]
	for id in names:
		var path = "res://assets/sfx/%s.wav" % id
		var stream = ResourceLoader.load(path, "AudioStreamWAV")
		if stream == null:
			stream = AudioStreamWAV.load_from_file(path)
		if stream != null:
			sfx[id] = stream


func t(key):
	return UI_TEXT[language].get(key, UI_TEXT["en"].get(key, key))


func toggle_language():
	language = "en" if language == "ja" else "ja"
	if screen == Screen.RACE and message_timer > 0.0:
		race_message = stage_flavor(stage_index)


func stage_name(index):
	if language == "ja":
		return STAGE_JA[index]["name"]
	return STAGES[index]["name"]


func stage_flavor(index):
	if language == "ja":
		return STAGE_JA[index]["flavor"]
	return STAGES[index]["flavor"]


func card_name(id):
	if language == "ja" and CARD_JA.has(id):
		return CARD_JA[id]["name"]
	return CARD_LIBRARY[id]["name"]


func card_desc(id):
	if language == "ja" and CARD_JA.has(id):
		return CARD_JA[id]["desc"]
	return CARD_LIBRARY[id]["desc"]


func relic_name(id):
	if language == "ja" and RELIC_JA.has(id):
		return RELIC_JA[id]["name"]
	return RELIC_LIBRARY[id]["name"]


func relic_desc(id):
	if language == "ja" and RELIC_JA.has(id):
		return RELIC_JA[id]["desc"]
	return RELIC_LIBRARY[id]["desc"]


func hazard_name_localized(kind):
	if language == "ja" and HAZARD_JA.has(kind):
		return HAZARD_JA[kind]
	return hazard_name(kind)


func _process(delta):
	_update_visual_timers(delta)
	suppress_mouse_click_timer = max(0.0, suppress_mouse_click_timer - delta)
	if screen == Screen.RACE:
		if hitstop_timer > 0.0:
			hitstop_timer = max(0.0, hitstop_timer - delta)
			_update_particles(delta * 0.25)
		else:
			_update_race(delta)
	_update_card_selection()
	queue_redraw()


func _update_visual_timers(delta):
	shake_timer = max(0.0, shake_timer - delta)
	flash_timer = max(0.0, flash_timer - delta)
	pulse_timer = max(0.0, pulse_timer - delta)
	flow_timer = max(0.0, flow_timer - delta)
	rival_flash_timer = max(0.0, rival_flash_timer - delta)
	message_timer = max(0.0, message_timer - delta)


func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		_handle_key(event.keycode)
	if event is InputEventScreenTouch and event.pressed:
		suppress_mouse_click_timer = 0.35
		_handle_click(event.position, true)
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if suppress_mouse_click_timer <= 0.0:
			_handle_click(event.position, false)


func _handle_key(keycode):
	if keycode == KEY_L:
		toggle_language()
		return
	if keycode == KEY_ESCAPE:
		screen = Screen.TITLE
		return
	if screen == Screen.TITLE:
		if keycode == KEY_ENTER or keycode == KEY_SPACE:
			start_run()
	elif screen == Screen.RACE:
		if keycode == KEY_SPACE:
			rotate_leader()
		elif keycode == KEY_W or keycode == KEY_UP:
			adjust_cadence(3.0)
		elif keycode == KEY_S or keycode == KEY_DOWN:
			adjust_cadence(-3.0)
		elif keycode >= KEY_1 and keycode <= KEY_5:
			play_card(keycode - KEY_1)
			clear_card_selection()
	elif screen == Screen.REWARD:
		if keycode >= KEY_1 and keycode <= KEY_3:
			choose_reward(keycode - KEY_1)
	elif screen == Screen.GAME_OVER or screen == Screen.WIN:
		if keycode == KEY_R or keycode == KEY_ENTER or keycode == KEY_SPACE:
			start_run()


func _handle_click(pos, is_touch := false):
	if language_button_rect.has_point(pos):
		toggle_language()
		clear_card_selection()
		return
	if screen == Screen.TITLE:
		if start_button_rect.has_point(pos):
			start_run()
	elif screen == Screen.RACE:
		if selected_card_index >= 0 and selected_card_rect.has_point(pos):
			play_card(selected_card_index)
			clear_card_selection()
			return
		for i in range(team_rects.size()):
			if team_rects[i].has_point(pos):
				set_leader(i)
				clear_card_selection()
				return
		if touch_up_rect.has_point(pos):
			adjust_cadence(3.0)
			clear_card_selection()
			return
		if touch_down_rect.has_point(pos):
			adjust_cadence(-3.0)
			clear_card_selection()
			return
		if touch_jump_rect.has_point(pos):
			rotate_leader()
			clear_card_selection()
			return
		for i in range(hand_rects.size()):
			if hand_rects[i].has_point(pos):
				if not is_touch or selected_card_index == i:
					play_card(i)
					clear_card_selection()
				else:
					selected_card_index = i
					selected_card_pinned = is_touch
				return
		clear_card_selection()
	elif screen == Screen.REWARD:
		for i in range(reward_rects.size()):
			if reward_rects[i].has_point(pos):
				choose_reward(i)
				return
	elif screen == Screen.GAME_OVER or screen == Screen.WIN:
		start_run()


func clear_card_selection():
	selected_card_index = -1
	selected_card_pinned = false
	selected_card_rect = Rect2()


func _update_card_selection():
	if screen != Screen.RACE:
		clear_card_selection()
		return
	if selected_card_index >= hand.size():
		clear_card_selection()
		return
	if selected_card_pinned:
		return
	var pos = get_local_mouse_position()
	if selected_card_index >= 0 and selected_card_rect.has_point(pos):
		return
	selected_card_index = -1
	for i in range(hand_rects.size()):
		if hand_rects[i].has_point(pos):
			selected_card_index = i
			return


func start_run():
	stage_index = 0
	distance = 0.0
	speed = 27.0
	burst = 0.0
	max_stamina = 100.0
	stamina = max_stamina
	setup_team()
	hp = max_hp
	score = 0
	combo = 0
	best_combo = 0
	rival_beaten = 0
	last_stage_rival_result = ""
	stage_result = ""
	guard = 0
	revive_tokens = 0
	lucky_helmet_ready = false
	relics.clear()
	deck = ["rotate", "rotate", "tempo", "tempo", "shelter", "feed", "shift", "corner", "climber_pull", "recover"]
	setup_stage(0)
	screen = Screen.RACE
	play_sfx("stage_clear", 0.82)


func setup_team():
	team.clear()
	for rider in TEAM_RIDERS:
		var member = rider.duplicate()
		member["stamina"] = float(member["max_stamina"])
		member["max_stamina_current"] = float(member["max_stamina"])
		team.append(member)
	leader_index = 0
	target_cadence = 86.0
	cadence = 86.0
	formation = "paceline"


func setup_stage(index):
	stage_index = index
	distance = 0.0
	speed = 27.0 + get_relic_bonus("base_speed")
	recover_team_for_stage()
	target_cadence = 84.0
	cadence = 84.0
	formation = "paceline"
	active_commands.clear()
	road_phase = rng.randf_range(0.0, 100.0)
	road_grade = float(STAGES[stage_index]["grade"])
	road_wind = float(STAGES[stage_index]["wind"])
	road_curve = 0.0
	road_tilt = 0.0
	team_pressure = 0.0
	crack_timer = 0.0
	last_stage_rival_result = ""
	stage_result = ""
	burst = 0.0
	lane = 1
	lane_visual = 1.0
	air_height = 0.0
	vertical_velocity = 0.0
	on_ground = true
	guard = 0
	combo = 0
	obstacles.clear()
	particles.clear()
	next_obstacle_distance = 210.0
	draw_pile = deck.duplicate()
	draw_pile.shuffle()
	hand.clear()
	discard.clear()
	draw_timer = 0.2
	draft_timer = 0.0
	brake_timer = 0.0
	evade_timer = 0.0
	wheelie_timer = 0.0
	predict_timer = 0.0
	climb_timer = 0.0
	tempo_timer = 0.0
	for i in range(5):
		draw_card()
	show_message(stage_flavor(stage_index), 3.0)


func recover_team_for_stage():
	if team.is_empty():
		return
	for member in team:
		var frame_bonus = get_relic_bonus("team_stamina")
		var base_max = float(member["max_stamina"]) + frame_bonus
		member["max_stamina_current"] = base_max
		var recovery = 24.0 + float(member["recovery"]) * 8.0 + get_relic_bonus("stage_recovery")
		member["stamina"] = min(base_max, float(member["stamina"]) + recovery)


func _update_race(delta):
	var stage = STAGES[stage_index]
	update_command_timers(delta)
	update_road_state(delta, stage)
	draw_timer -= delta
	if draw_timer <= 0.0:
		if hand.size() < MAX_HAND:
			draw_card()
		draw_timer = 3.5 - min(0.8, combo * 0.04)
	update_team_ride(delta, stage)
	_update_particles(delta)

	if distance >= float(stage["length"]):
		complete_stage()


func update_command_timers(delta):
	var expired = []
	for id in active_commands.keys():
		active_commands[id] = float(active_commands[id]) - delta
		if float(active_commands[id]) <= 0.0:
			expired.append(id)
	for id in expired:
		active_commands.erase(id)
	if command_active("echelon"):
		formation = "echelon"
	elif command_active("recover"):
		formation = "recovery"
	else:
		formation = "paceline"


func update_road_state(delta, stage):
	road_phase += delta * (0.7 + speed * 0.018)
	var progress = distance / float(stage["length"])
	var grade_wave = sin(progress * TAU * 2.0 + stage_index * 0.8 + road_phase * 0.18)
	var curve_wave = sin(progress * TAU * 3.0 + stage_index * 1.1 + road_phase * 0.26)
	var gust_wave = sin(progress * TAU * 1.6 + road_phase * 0.35)
	road_grade = float(stage["grade"]) + grade_wave * (0.55 + stage_index * 0.06)
	road_wind = max(0.0, float(stage["wind"]) + gust_wave * 0.35)
	road_curve = clamp(curve_wave * float(stage["curve"]), -1.2, 1.2)
	road_tilt = lerp(road_tilt, road_curve * 0.07, min(1.0, delta * 3.0))


func update_team_ride(delta, stage):
	if team.is_empty():
		return
	var leader = team[leader_index]
	var team_avg = team_stamina_average()
	var cadence_target = 84.0 + get_relic_bonus("cadence")
	if command_active("tempo"):
		cadence_target += 9.0
	if command_active("chainbreak"):
		cadence_target += 14.0
	if command_active("recover"):
		cadence_target -= 9.0
	if road_grade > 0.8:
		cadence_target -= 4.0
	if road_grade < -0.6:
		cadence_target += 3.0
	target_cadence = clamp(target_cadence, 68.0, 112.0)
	cadence_target = (cadence_target + target_cadence) * 0.5
	var cadence_rate = 5.0 + get_relic_bonus("shift_speed")
	if command_active("shift"):
		cadence_rate += 8.0
	cadence = move_toward(cadence, cadence_target, delta * cadence_rate)

	var cadence_eff = clamp(1.0 - abs(cadence - cadence_target) / 32.0, 0.62, 1.08)
	var grade_penalty = max(0.0, road_grade) * (3.2 - float(leader["climb"]) * 1.25 - get_relic_bonus("climb"))
	var downhill_bonus = max(0.0, -road_grade) * (2.5 + (0.8 if command_active("aero") else 0.0))
	var wind_penalty = road_wind * (2.2 - get_relic_bonus("wind"))
	if command_active("aero"):
		wind_penalty *= 0.72
	var curve_penalty = abs(road_curve) * (2.5 - float(leader["corner"]) - get_relic_bonus("corner"))
	if command_active("corner"):
		curve_penalty *= 0.32
	var leader_power = 26.0 + float(leader["pull"]) * 4.2 + get_relic_bonus("base_speed")
	if command_active("climber_pull"):
		leader_power += max(0.0, road_grade) * 2.5
	if command_active("leadout"):
		leader_power += float(team[2]["sprint"]) * 3.0
	if command_active("chainbreak"):
		leader_power += 11.0
		pulse_timer = max(pulse_timer, 0.08)
	if command_active("tempo"):
		leader_power += 3.5
	if command_active("recover"):
		leader_power -= 5.0

	var fatigue = clamp(team_avg / 92.0, 0.42, 1.08)
	var target = clamp((leader_power + downhill_bonus - grade_penalty - wind_penalty - curve_penalty) * cadence_eff * fatigue + burst, 10.0, 55.0 + get_relic_bonus("max_speed"))
	speed = move_toward(speed, target, delta * (7.2 if target > speed else 5.2))
	distance += max(7.0, speed) * delta
	score += int(max(0.0, speed - 18.0) * delta * 2.0)
	burst = max(0.0, burst - delta * 4.2)

	var crosswind = road_wind * (0.7 + abs(road_curve) * 0.25)
	var shelter_bonus = float(leader["shelter"]) + get_relic_bonus("shelter")
	if command_active("shelter"):
		shelter_bonus += 0.42
	if command_active("echelon"):
		shelter_bonus += crosswind * 0.7
	var road_load = max(0.0, road_grade) * 0.45 + crosswind * 0.38 + abs(road_curve) * 0.18
	for i in range(team.size()):
		var member = team[i]
		var drain = 1.2 + road_load
		if i == leader_index:
			drain += 2.7 + max(0.0, cadence - 86.0) * 0.045
			if command_active("chainbreak"):
				drain += 4.4
			if command_active("tempo"):
				drain += 1.4
		else:
			drain *= clamp(1.0 - shelter_bonus * 0.23, 0.34, 0.82)
			if command_active("recover"):
				drain -= 2.8
			if command_active("leadout") and i == 2:
				drain -= 1.5
		if command_active("shift"):
			drain -= 0.35
		if command_active("climber_pull") and i == 1:
			drain -= max(0.0, road_grade) * 0.55
		member["stamina"] = clamp(float(member["stamina"]) - drain * delta, 0.0, float(member["max_stamina_current"]))
	team_pressure = clamp(1.0 - team_stamina_average() / 100.0 + road_load * 0.08, 0.0, 1.0)
	stamina = team_stamina_average()
	max_stamina = 100.0 + get_relic_bonus("team_stamina")

	if abs(road_curve) > 0.88 and not command_active("corner"):
		shake_timer = max(shake_timer, 0.04)
		shake_strength = max(shake_strength, abs(road_curve) * 2.8)
	if team_lowest_stamina() <= 0.5:
		crack_timer += delta
		if crack_timer > 1.4:
			death_reason = t("team_cracked")
			screen = Screen.GAME_OVER
			play_sfx("crash", 0.9)
	else:
		crack_timer = max(0.0, crack_timer - delta * 2.0)


func _update_physics(delta, stage):
	var regen = 7.5
	var chase_draft = rival_draft_strength()
	if draft_timer > 0.0:
		regen += 7.0
	elif chase_draft > 0.0:
		regen += 4.5 * chase_draft
	if tempo_timer > 0.0:
		regen += 11.0
	if combo >= 5:
		regen += 2.0
	stamina = min(max_stamina, stamina + regen * delta)

	if speed > 22.0:
		stamina = max(0.0, stamina - max(0.0, speed - 22.0) * 0.07 * delta)

	var grade = float(stage["grade"])
	var wind = float(stage["wind"])
	var base = 25.5 + get_relic_bonus("base_speed")
	if grade > 0.0:
		base -= grade * 4.4
		if climb_timer > 0.0:
			base += 7.2
	else:
		base += abs(grade) * 4.0
	if wind > 0.0 and draft_timer <= 0.0:
		base -= wind * 3.8
	if draft_timer <= 0.0 and chase_draft > 0.0:
		base += 2.4 * chase_draft
	if brake_timer > 0.0:
		base -= 4.2
	if tempo_timer > 0.0:
		base = max(base, 26.0)
	if stamina < 12.0:
		base -= 9.0
	burst = max(0.0, burst - delta * (3.7 + float(stage_index) * 0.25))
	var max_speed = 47.0 + get_relic_bonus("max_speed")
	var target = clamp(base + burst, 9.5, max_speed)
	speed = move_toward(speed, target, delta * (6.0 if target > speed else 4.0))
	distance += max(6.0, speed) * delta

	if not on_ground or vertical_velocity > 0.0:
		air_height += vertical_velocity * delta
		vertical_velocity -= (880.0 - get_relic_bonus("jump_gravity")) * delta
		if air_height <= 0.0:
			air_height = 0.0
			vertical_velocity = 0.0
			if not on_ground and speed > 28.0:
				_make_hitstop(0.025, 3.0)
				add_text_particle("clean landing", Vector2(PLAYER_X + 35, current_player_y() - 34), Color(0.8, 1.0, 0.9))
			on_ground = true


func _update_rival(delta, stage):
	var grade = float(stage["grade"])
	var wind = float(stage["wind"])
	var base = 26.1 + stage_index * 0.65
	if grade > 0.0:
		base -= grade * 3.0
	else:
		base += abs(grade) * 2.5
	base -= wind * 0.9
	if stage["tag"] == "BOSS":
		base += 1.2
	if stage["tag"] == "PACK":
		base += 0.8

	var gap = rival_distance - distance
	base += clamp(-gap / 92.0, -2.8, 4.2)
	if gap > 180.0:
		base -= 2.0
	if combo >= 5:
		base -= 1.4
	var target = clamp(base, 18.0, 43.0)
	rival_speed = move_toward(rival_speed, target, delta * 3.0)
	rival_distance += rival_speed * delta

	rival_lane = int(clamp(round(1.0 + sin((rival_distance + stage_index * 140.0) * 0.011)), 0.0, 2.0))
	rival_lane_visual = lerp(rival_lane_visual, float(rival_lane), min(1.0, delta * 3.2))

	var new_gap = rival_distance - distance
	if rival_last_gap > 10.0 and new_gap <= 0.0:
		var bonus = 220 + stage_index * 60 + combo * 25
		score += bonus
		rival_flash_timer = 1.15
		pulse_timer = max(pulse_timer, 0.32)
		flow_timer = max(flow_timer, 1.2)
		_make_hitstop(0.06, 10.0)
		add_text_particle(t("rival_pass") % bonus, Vector2(390, current_player_y() - 116), Color(1.0, 0.38, 0.22))
		play_sfx("near_miss", 1.14)
	elif rival_last_gap < -55.0 and new_gap > 18.0:
		rival_flash_timer = 0.75
		add_text_particle(t("rival_attack"), Vector2(565, 260), Color(1.0, 0.24, 0.16))
	rival_last_gap = new_gap


func rival_gap():
	return rival_distance - distance


func rival_draft_strength():
	var gap = rival_gap()
	if gap <= 18.0 or gap >= 150.0:
		return 0.0
	return clamp(1.0 - abs(gap - 72.0) / 78.0, 0.0, 1.0)


func _generate_obstacles(stage):
	var spacing_base = max(95.0, 175.0 - stage_index * 11.0)
	while next_obstacle_distance < distance + 1450.0 and next_obstacle_distance < float(stage["length"]) - 120.0:
		var hazards = stage["hazards"]
		var kind = hazards[rng.randi_range(0, hazards.size() - 1)]
		if rng.randf() < 0.14:
			kind = "gel"
		var obstacle = {
			"kind": kind,
			"dist": next_obstacle_distance,
			"lane": rng.randi_range(0, 2),
			"done": false,
			"skim": false,
			"wiggle": rng.randf_range(0.0, 100.0)
		}
		obstacles.append(obstacle)
		next_obstacle_distance += rng.randf_range(spacing_base * 0.74, spacing_base * 1.35)


func _check_obstacles():
	for obstacle in obstacles:
		if obstacle["done"]:
			continue
		var gap = float(obstacle["dist"]) - distance
		if gap < -42.0:
			obstacle["done"] = true
			continue
		var same_lane = int(obstacle["lane"]) == lane
		if same_lane and abs(gap) <= 14.5:
			resolve_obstacle(obstacle)
		elif not obstacle["skim"] and abs(gap) <= 12.0 and abs(int(obstacle["lane"]) - lane) == 1 and obstacle["kind"] != "gel":
			obstacle["skim"] = true
			near_miss(obstacle)


func resolve_obstacle(obstacle):
	obstacle["done"] = true
	var kind = obstacle["kind"]
	if kind == "gel":
		stamina = min(max_stamina, stamina + 22.0)
		draw_card()
		score += 90 + combo * 12
		add_text_particle("+gel", obstacle_screen_pos(obstacle), Color(1.0, 0.9, 0.35))
		play_sfx("pickup", 1.0 + rng.randf_range(-0.05, 0.08))
		return

	if evade_timer > 0.0:
		perfect_clear(obstacle, "ghost")
		return

	var cleared = false
	if kind == "cone":
		cleared = air_height >= 36.0
	elif kind == "pothole":
		cleared = air_height >= 22.0 or wheelie_timer > 0.0
	elif kind == "rail":
		cleared = air_height >= 62.0
	elif kind == "gap":
		cleared = air_height >= 82.0
	elif kind == "hairpin":
		var allowed_speed = 37.5 + get_relic_bonus("hairpin_speed")
		cleared = brake_timer > 0.0 or speed <= allowed_speed
	elif kind == "rider":
		cleared = draft_timer > 0.0 or guard > 0

	if cleared:
		perfect_clear(obstacle, kind)
	elif guard > 0:
		guard -= 1
		perfect_clear(obstacle, "guard")
	else:
		crash(kind)


func near_miss(obstacle):
	combo += 1
	best_combo = max(best_combo, combo)
	score += 80 + combo * 22
	burst += 1.4
	stamina = min(max_stamina, stamina + (5.0 if has_relic("tape") else 2.5))
	flow_timer = 1.2
	_make_hitstop(0.065, 8.0)
	flash_timer = 0.055
	add_text_particle("NEAR MISS x%s" % combo, obstacle_screen_pos(obstacle) + Vector2(0, -34), Color(0.65, 1.0, 1.0))
	play_sfx("near_miss", 1.0 + min(0.32, combo * 0.025))


func perfect_clear(obstacle, label):
	combo += 1
	best_combo = max(best_combo, combo)
	score += 120 + combo * 30
	burst += 1.8
	flow_timer = 1.6
	_make_hitstop(0.078 if label != "guard" else 0.11, 9.0)
	flash_timer = 0.07
	add_text_particle("FLOW x%s" % combo, obstacle_screen_pos(obstacle) + Vector2(0, -44), Color(1.0, 0.96, 0.48))
	play_sfx("near_miss", 1.08 + min(0.38, combo * 0.03))
	if combo % 5 == 0:
		pulse_timer = 0.42
		burst += 4.0
		stamina = min(max_stamina, stamina + 12.0)
		add_text_particle("COMBO BREAK!", Vector2(560, 250), Color(1.0, 0.36, 0.28))


func crash(kind):
	combo = 0
	shake_timer = 0.34
	shake_strength = 18.0
	flash_timer = 0.13
	hitstop_timer = 0.13
	speed = max(8.0, speed - 12.0)
	stamina = max(0.0, stamina - 28.0)
	if revive_tokens > 0:
		revive_tokens -= 1
		guard += 1
		add_text_particle("ONE MORE PEDAL", Vector2(430, 238), Color(1.0, 0.82, 0.32))
		play_sfx("stage_clear", 1.2)
		return
	if has_relic("helmet") and not lucky_helmet_ready:
		lucky_helmet_ready = true
		guard += 1
		add_text_particle("LUCKY HELMET", Vector2(430, 238), Color(0.8, 0.95, 1.0))
		play_sfx("stage_clear", 0.9)
		return
	hp -= 1
	death_reason = t("crashed") % hazard_name_localized(kind)
	play_sfx("crash", 1.0)
	add_text_particle("CRASH!", Vector2(PLAYER_X + 70, current_player_y() - 80), Color(1.0, 0.2, 0.16))
	if hp <= 0:
		screen = Screen.GAME_OVER


func complete_stage():
	var bonus = int(team_stamina_average() * 4.0 + best_combo * 55.0 + max(0.0, speed - 24.0) * 18.0)
	score += bonus
	stage_result = t("stage_bonus") % bonus
	_make_hitstop(0.15, 13.0)
	if stage_index >= STAGES.size() - 1:
		screen = Screen.WIN
		play_sfx("win", 1.0)
	else:
		build_reward_choices()
		screen = Screen.REWARD
		play_sfx("stage_clear", 1.0)


func build_reward_choices():
	reward_choices.clear()
	var card_ids = REWARD_CARDS.duplicate()
	card_ids.shuffle()
	for i in range(2):
		reward_choices.append({"kind": "card", "id": card_ids[i]})
	var relic_ids = []
	for id in RELIC_IDS:
		if not relics.has(id):
			relic_ids.append(id)
	relic_ids.shuffle()
	if relic_ids.size() > 0:
		reward_choices.append({"kind": "relic", "id": relic_ids[0]})
	else:
		reward_choices.append({"kind": "card", "id": card_ids[2]})


func choose_reward(index):
	if index < 0 or index >= reward_choices.size():
		return
	var choice = reward_choices[index]
	if choice["kind"] == "card":
		deck.append(choice["id"])
		show_message(t("added") % card_name(choice["id"]), 1.4)
	else:
		relics.append(choice["id"])
		apply_relic_immediate(choice["id"])
		show_message(t("installed") % relic_name(choice["id"]), 1.4)
	setup_stage(stage_index + 1)
	screen = Screen.RACE


func apply_relic_immediate(id):
	if id == "northline_boreal":
		for member in team:
			member["max_stamina_current"] = float(member["max_stamina_current"]) + 8.0
			member["stamina"] = min(float(member["max_stamina_current"]), float(member["stamina"]) + 8.0)


func draw_card():
	if draw_pile.is_empty():
		if discard.is_empty():
			return
		draw_pile = discard.duplicate()
		draw_pile.shuffle()
		discard.clear()
	if hand.size() >= MAX_HAND:
		return
	hand.append(draw_pile.pop_back())


func play_card(index):
	if index < 0 or index >= hand.size():
		return
	var id = hand[index]
	var card = CARD_LIBRARY[id]
	var cost = max(0, int(card["cost"]) - int(get_relic_bonus("cost_cut")))
	if team.is_empty():
		return
	if float(team[leader_index]["stamina"]) < cost:
		_make_hitstop(0.035, 5.0)
		add_text_particle(t("no_legs"), Vector2(520, 600), Color(1.0, 0.38, 0.34))
		return
	team[leader_index]["stamina"] = max(0.0, float(team[leader_index]["stamina"]) - cost)
	hand.remove_at(index)
	discard.append(id)
	apply_card(id)
	play_sfx("card", 1.0 + rng.randf_range(-0.06, 0.08))


func apply_card(id):
	var card = CARD_LIBRARY[id]
	var duration = float(card.get("duration", 0.0))
	combo += 1
	best_combo = max(best_combo, combo)
	score += 25 + combo * 8
	if duration > 0.0:
		set_command(id, duration)
	if id == "rotate":
		rotate_leader()
		burst += 1.2
	elif id == "tempo":
		target_cadence += 5.0
		burst += 2.5
	elif id == "shelter":
		if leader_index != 0:
			set_leader(0)
		burst += 1.0
	elif id == "climber_pull":
		set_leader(1)
		burst += max(0.0, road_grade) * 3.0
	elif id == "corner":
		flow_timer = 1.0
		burst += abs(road_curve) * 2.8
	elif id == "echelon":
		formation = "echelon"
		flow_timer = 1.2
	elif id == "feed":
		var idx = weakest_rider_index()
		var member = team[idx]
		member["stamina"] = min(float(member["max_stamina_current"]), float(member["stamina"]) + 26.0 + get_relic_bonus("stage_recovery"))
		draw_card()
		add_text_particle(t("weak_recover") % rider_display_name(idx), Vector2(405, 260), Color(1.0, 0.86, 0.34))
	elif id == "shift":
		target_cadence = round(cadence)
		draw_card()
		burst += 1.5
	elif id == "recover":
		target_cadence -= 7.0
		for i in range(team.size()):
			if i != leader_index:
				team[i]["stamina"] = min(float(team[i]["max_stamina_current"]), float(team[i]["stamina"]) + 5.0)
	elif id == "aero":
		burst += 5.0 if road_grade < -0.4 else 2.0
	elif id == "leadout":
		if distance / float(STAGES[stage_index]["length"]) > 0.65:
			burst += 8.0 + float(team[2]["sprint"]) * 4.0
		else:
			burst += 3.0
	elif id == "chainbreak":
		burst += 15.0
		pulse_timer = 0.5
		_make_hitstop(0.08, 15.0)
	add_text_particle(card_name(id), Vector2(430, 250), card["color"])


func try_jump(multiplier):
	rotate_leader()


func change_lane(dir):
	adjust_cadence(-3.0 if dir > 0 else 3.0)


func set_command(id, duration):
	active_commands[id] = max(float(active_commands.get(id, 0.0)), duration)


func command_active(id):
	return active_commands.has(id) and float(active_commands[id]) > 0.0


func rotate_leader():
	if team.is_empty():
		return
	leader_index = (leader_index + 1) % team.size()
	_make_hitstop(0.025, 3.0)
	add_text_particle(t("rotate_call") % rider_display_name(leader_index), Vector2(420, 255), team[leader_index]["color"])


func set_leader(index):
	if index < 0 or index >= team.size():
		return
	leader_index = index
	add_text_particle(t("rotate_call") % rider_display_name(index), Vector2(420, 255), team[index]["color"])


func adjust_cadence(amount):
	target_cadence = clamp(target_cadence + amount, 68.0, 112.0)
	flow_timer = max(flow_timer, 0.2)


func rider_display_name(index):
	if index < 0 or index >= team.size():
		return ""
	return team[index]["name"] if language == "ja" else team[index]["en_name"]


func rider_role(index):
	if index < 0 or index >= team.size():
		return ""
	return team[index]["role"] if language == "ja" else team[index]["en_role"]


func rider_body(index):
	if index < 0 or index >= team.size():
		return ""
	return team[index]["body"] if language == "ja" else team[index]["en_body"]


func team_stamina_average():
	if team.is_empty():
		return 0.0
	var total = 0.0
	for member in team:
		var max_value = max(1.0, float(member["max_stamina_current"]))
		total += float(member["stamina"]) / max_value * 100.0
	return total / team.size()


func team_lowest_stamina():
	if team.is_empty():
		return 0.0
	var lowest = 999.0
	for member in team:
		var max_value = max(1.0, float(member["max_stamina_current"]))
		lowest = min(lowest, float(member["stamina"]) / max_value * 100.0)
	return lowest


func weakest_rider_index():
	var best = 0
	var best_value = 9999.0
	for i in range(team.size()):
		var member = team[i]
		var value = float(member["stamina"]) / max(1.0, float(member["max_stamina_current"]))
		if value < best_value:
			best_value = value
			best = i
	return best


func formation_name():
	if language == "ja":
		if formation == "echelon":
			return "エシュロン"
		if formation == "recovery":
			return "回復"
		return "ローテ"
	if formation == "echelon":
		return "ECHELON"
	if formation == "recovery":
		return "RECOVER"
	return "PACELINE"


func clear_nearest_hazard():
	var best = null
	var best_gap = 99999.0
	for obstacle in obstacles:
		if obstacle["done"] or obstacle["kind"] == "gel":
			continue
		var gap = float(obstacle["dist"]) - distance
		if gap > 0.0 and gap < best_gap:
			best_gap = gap
			best = obstacle
	if best != null:
		best["done"] = true
		score += 180 + combo * 20
		_make_hitstop(0.085, 9.0)
		add_text_particle("OPEN ROAD", obstacle_screen_pos(best), Color(0.72, 1.0, 0.92))
	else:
		add_text_particle("CLEAR", Vector2(420, 260), Color(0.72, 1.0, 0.92))


func get_relic_bonus(kind):
	var value = 0.0
	if kind == "cost_cut" and has_relic("shimanagi_synchro"):
		value += 1.0
	if kind == "shift_speed" and has_relic("shimanagi_synchro"):
		value += 3.2
	if kind == "cadence" and has_relic("shimanagi_synchro"):
		value += 1.5
	if kind == "climb" and has_relic("valcorsa_strada"):
		value += 0.65
	if kind == "corner" and has_relic("valcorsa_strada"):
		value += 0.35
	if kind == "base_speed" and has_relic("keystone_crit"):
		value += 1.9
	if kind == "max_speed" and has_relic("keystone_crit"):
		value += 3.5
	if kind == "shelter" and has_relic("northline_boreal"):
		value += 0.22
	if kind == "wind" and has_relic("northline_boreal"):
		value += 0.45
	if kind == "team_stamina" and has_relic("northline_boreal"):
		value += 8.0
	if kind == "stage_recovery" and has_relic("northline_boreal"):
		value += 5.0
	return value


func has_relic(id):
	return relics.has(id)


func _make_hitstop(duration, shake):
	hitstop_timer = max(hitstop_timer, duration)
	shake_timer = max(shake_timer, duration + 0.08)
	shake_strength = max(shake_strength, shake)


func show_message(text, duration):
	race_message = text
	message_timer = duration


func add_text_particle(text, pos, color):
	particles.append({
		"text": text,
		"pos": pos,
		"vel": Vector2(rng.randf_range(-8, 8), rng.randf_range(-62, -38)),
		"life": 1.0,
		"color": color
	})


func add_spark(pos, color):
	particles.append({
		"text": "",
		"pos": pos,
		"vel": Vector2(rng.randf_range(-120, 80), rng.randf_range(-120, 40)),
		"life": rng.randf_range(0.35, 0.75),
		"color": color
	})


func _update_particles(delta):
	for p in particles:
		p["pos"] += p["vel"] * delta
		p["vel"].y += 85.0 * delta
		p["life"] = float(p["life"]) - delta
	for i in range(particles.size() - 1, -1, -1):
		if float(particles[i]["life"]) <= 0.0:
			particles.remove_at(i)
	if flow_timer > 0.0 and rng.randf() < 0.45:
		add_spark(Vector2(PLAYER_X + rng.randf_range(0, 110), current_player_y() + rng.randf_range(-34, 30)), Color(1.0, 0.88, 0.35, 0.95))


func play_sfx(id, pitch := 1.0):
	if not sfx.has(id):
		return
	var player = AudioStreamPlayer.new()
	player.stream = sfx[id]
	player.volume_db = -7.0
	player.pitch_scale = pitch
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)


func current_player_y():
	return LANES[int(round(lane_visual))] - air_height


func obstacle_screen_pos(obstacle):
	var x = PLAYER_X + (float(obstacle["dist"]) - distance) * PX_PER_METER
	var y = LANES[int(obstacle["lane"])]
	return Vector2(x, y)


func hazard_name(kind):
	if kind == "cone":
		return "traffic cone"
	if kind == "pothole":
		return "pothole"
	if kind == "rail":
		return "guard rail"
	if kind == "gap":
		return "road gap"
	if kind == "hairpin":
		return "hairpin"
	if kind == "rider":
		return "rival rider"
	return str(kind)


func _draw():
	var size = get_viewport_rect().size
	var offset = Vector2.ZERO
	if shake_timer > 0.0:
		var amp = shake_strength * (shake_timer / max(0.001, shake_timer + 0.08))
		offset = Vector2(rng.randf_range(-amp, amp), rng.randf_range(-amp, amp))
	draw_set_transform(offset, 0.0, Vector2.ONE)
	if screen == Screen.TITLE:
		draw_title(size)
	elif screen == Screen.RACE:
		draw_race(size)
	elif screen == Screen.REWARD:
		draw_reward(size)
	elif screen == Screen.GAME_OVER:
		draw_game_over(size)
	elif screen == Screen.WIN:
		draw_win(size)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	if flash_timer > 0.0:
		draw_rect(Rect2(Vector2.ZERO, size), Color(1, 1, 1, min(0.42, flash_timer * 5.0)))
	draw_language_button(size)


func draw_title(size):
	draw_background(size, 0.78)
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.01, 0.03, 0.05, 0.34))
	draw_speed_lines(size, 0.38)
	draw_centered("CHAINBREAK", 138, 82, Color(0.93, 1.0, 0.96))
	draw_centered(t("subtitle"), 205, 27, Color(0.55, 0.95, 1.0))
	draw_centered(t("tagline"), 265, 23, Color(0.88, 0.93, 0.91))
	start_button_rect = Rect2(size.x * 0.5 - 150, 332, 300, 62)
	draw_round_rect(start_button_rect, Color(1.0, 0.28, 0.2), Color(1.0, 0.82, 0.55), 4.0)
	draw_centered(t("start"), 374, 28, Color(0.03, 0.05, 0.06))
	draw_centered(t("title_controls"), 455, 21, Color(0.78, 0.88, 0.88))
	draw_centered(t("title_note"), 492, 18, Color(0.68, 0.76, 0.76))


func draw_race(size):
	draw_first_person_road(size)
	draw_particles()
	draw_hud(size)
	draw_team_panel(size)
	draw_active_orders(size)
	draw_card_hand(size)
	draw_touch_controls(size)
	if message_timer > 0.0:
		draw_centered(race_message, 112, 23, Color(1.0, 0.91, 0.58))
	if pulse_timer > 0.0:
		draw_rect(Rect2(Vector2.ZERO, size), Color(1.0, 0.18, 0.13, min(0.18, pulse_timer * 0.36)), false, 14)


func draw_first_person_road(size):
	var horizon = 260.0 - clamp(road_grade, -2.0, 2.0) * 16.0
	var bend = road_curve * 130.0
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.025, 0.04, 0.065))
	if bg_texture != null:
		draw_texture_rect(bg_texture, Rect2(Vector2(0, 0), Vector2(size.x, horizon + 110)), false, Color(1, 1, 1, 0.34))
	draw_rect(Rect2(0, 0, size.x, horizon + 40), Color(0.02, 0.04, 0.07, 0.25))
	for i in range(4):
		var y = horizon - 60 + i * 24
		draw_line(Vector2(-40, y + road_tilt * 80.0), Vector2(size.x + 40, y - road_tilt * 80.0), Color(0.25, 0.5, 0.55, 0.14), 2)
	var road = PackedVector2Array([
		Vector2(size.x * 0.5 - 95 + bend * 0.24, horizon),
		Vector2(size.x * 0.5 + 95 + bend * 0.24, horizon),
		Vector2(size.x + 260 + bend, size.y + 80),
		Vector2(-260 + bend, size.y + 80)
	])
	draw_colored_polygon(road, Color(0.07, 0.085, 0.09, 0.98))
	draw_line(Vector2(size.x * 0.5 - 95 + bend * 0.24, horizon), Vector2(-260 + bend, size.y + 80), Color(0.45, 0.95, 1.0, 0.22), 4)
	draw_line(Vector2(size.x * 0.5 + 95 + bend * 0.24, horizon), Vector2(size.x + 260 + bend, size.y + 80), Color(0.45, 0.95, 1.0, 0.22), 4)
	var rush = speed_feel()
	for i in range(18):
		var depth = float(i) / 17.0
		var p = pow(depth, 1.85)
		var y = lerp(horizon + 10.0, size.y + 55.0, p)
		var width = lerp(120.0, size.x * 1.34, p)
		var center_x = size.x * 0.5 + bend * p
		var shade = 0.05 + p * 0.12
		draw_line(Vector2(center_x - width * 0.5, y), Vector2(center_x + width * 0.5, y), Color(0.72, 0.92, 0.9, shade), 1.0 + p * 4.0)
	for lane_mark in [-0.33, 0.33]:
		for i in range(14):
			var d = fmod(distance * (0.018 + rush * 0.018) + i * 0.12, 1.0)
			var p1 = pow(d, 1.9)
			var p2 = pow(min(1.0, d + 0.055 + rush * 0.035), 1.9)
			var y1 = lerp(horizon + 4.0, size.y + 40.0, p1)
			var y2 = lerp(horizon + 4.0, size.y + 40.0, p2)
			var w1 = lerp(90.0, size.x * 1.18, p1)
			var w2 = lerp(90.0, size.x * 1.18, p2)
			var c1 = size.x * 0.5 + bend * p1 + w1 * lane_mark
			var c2 = size.x * 0.5 + bend * p2 + w2 * lane_mark
			draw_line(Vector2(c1, y1), Vector2(c2, y2), Color(0.95, 1.0, 0.96, 0.42 + rush * 0.28), 2.0 + p2 * 7.0)
	draw_wind_and_curve_fx(size, horizon, rush)
	draw_handlebar_overlay(size)


func draw_wind_and_curve_fx(size, horizon, rush):
	var wind_alpha = clamp(road_wind / 1.5, 0.0, 1.0)
	for i in range(10):
		var y = horizon + 40 + i * 38 + fmod(distance * 0.8, 38.0)
		var x = fmod(i * 157.0 + distance * (2.0 + road_wind * 5.0), size.x + 240.0) - 120.0
		var slant = road_curve * 34.0 + road_wind * 42.0
		draw_line(Vector2(x, y), Vector2(x + 90 + rush * 120.0 + slant, y - 8 - road_wind * 8.0), Color(0.65, 0.95, 1.0, 0.05 + wind_alpha * 0.13), 2 + rush * 2.0)
	if abs(road_curve) > 0.35:
		var side = -1 if road_curve > 0 else 1
		draw_rect(Rect2(Vector2(0 if side < 0 else size.x - 130, 0), Vector2(130, size.y)), Color(1.0, 0.65, 0.24, min(0.12, abs(road_curve) * 0.08)))


func draw_handlebar_overlay(size):
	var y = size.y - 116
	draw_line(Vector2(size.x * 0.5 - 280, y + 68), Vector2(size.x * 0.5 - 80, y + 10), Color(0.02, 0.025, 0.026, 0.82), 16)
	draw_line(Vector2(size.x * 0.5 + 80, y + 10), Vector2(size.x * 0.5 + 280, y + 68), Color(0.02, 0.025, 0.026, 0.82), 16)
	draw_arc(Vector2(size.x * 0.5 - 300, y + 74), 42, -1.0, 1.4, 18, Color(0.02, 0.025, 0.026, 0.86), 14)
	draw_arc(Vector2(size.x * 0.5 + 300, y + 74), 42, 1.75, 4.15, 18, Color(0.02, 0.025, 0.026, 0.86), 14)


func draw_reward(size):
	draw_background(size, 0.52)
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.02, 0.04, 0.05, 0.58))
	draw_centered(t("stage_clear"), 92, 54, Color(0.92, 1.0, 0.94))
	draw_centered(t("reward_prompt"), 142, 22, Color(0.8, 0.9, 0.9))
	if stage_result != "":
		draw_centered(stage_result, 178, 22, Color(1.0, 0.68, 0.42))
	reward_rects.clear()
	var start_x = size.x * 0.5 - 435
	for i in range(reward_choices.size()):
		var rect = Rect2(start_x + i * 300, 216, 270, 310)
		reward_rects.append(rect)
		var choice = reward_choices[i]
		if choice["kind"] == "card":
			draw_reward_card(rect, choice["id"], i + 1)
		else:
			draw_reward_relic(rect, choice["id"], i + 1)
	draw_centered(t("deck_summary") % [deck.size(), relics.size(), score], 602, 21, Color(0.75, 0.86, 0.86))


func draw_game_over(size):
	draw_background(size, 0.4)
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.08, 0.02, 0.025, 0.72))
	draw_centered(t("race_over"), 184, 68, Color(1.0, 0.28, 0.22))
	draw_centered(death_reason, 255, 26, Color(1.0, 0.8, 0.7))
	draw_centered(t("result_stats") % [score, best_combo, stage_index + 1], 312, 26, Color(0.88, 0.95, 0.95))
	draw_centered(t("retry"), 394, 23, Color(0.72, 0.88, 0.9))


func draw_win(size):
	draw_background(size, 0.8)
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.02, 0.03, 0.03, 0.36))
	draw_speed_lines(size, 0.65)
	draw_centered(t("win_title"), 168, 68, Color(1.0, 0.92, 0.45))
	draw_centered(t("win_body"), 238, 27, Color(0.9, 1.0, 0.94))
	draw_centered(t("win_stats") % [score, best_combo, deck.size(), relics.size()], 306, 26, Color(0.86, 0.94, 0.95))
	draw_centered(t("win_retry"), 406, 23, Color(0.75, 0.9, 0.92))


func draw_language_button(size):
	var y = 88 if screen == Screen.RACE else 12
	language_button_rect = Rect2(size.x - 132, y, 110, 34)
	draw_rect(language_button_rect, Color(0.02, 0.04, 0.05, 0.78))
	draw_rect(language_button_rect, Color(0.55, 0.95, 1.0, 0.72), false, 3)
	draw_text(t("lang_button"), language_button_rect.position + Vector2(13, 23), 15, Color(0.86, 1.0, 0.95))


func draw_background(size, alpha):
	if bg_texture != null:
		draw_texture_rect(bg_texture, Rect2(Vector2.ZERO, size), false, Color(1, 1, 1, alpha))
	else:
		draw_rect(Rect2(Vector2.ZERO, size), Color(0.02, 0.04, 0.07))
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.0, 0.0, 0.0, 0.10))


func draw_road(size):
	var rush = speed_feel()
	var road = PackedVector2Array([
		Vector2(-80, size.y + 80),
		Vector2(size.x + 80, size.y + 80),
		Vector2(size.x + 30, 360),
		Vector2(-30, 360)
	])
	draw_colored_polygon(road, Color(0.095, 0.12, 0.13, 0.95))
	for y in LANES:
		draw_line(Vector2(0, y + 35), Vector2(size.x, y + 35), Color(1, 1, 1, 0.14), 2)
		var dash_offset = fmod(distance * (14.0 + rush * 20.0), 112.0)
		var dash_len = 46.0 + rush * 58.0
		for x in range(-120, int(size.x) + 140, 96):
			draw_line(Vector2(x - dash_offset, y), Vector2(x + dash_len - dash_offset, y), Color(0.88, 0.94, 0.9, 0.42 + rush * 0.22), 4 + rush * 2.0)
	draw_line(Vector2(0, 360), Vector2(size.x, 360), Color(0.2, 0.95, 1.0, 0.25), 5)
	draw_line(Vector2(0, 640), Vector2(size.x, 640), Color(1.0, 0.25, 0.2, 0.23), 6)
	draw_ground_rush(size, rush)
	draw_speed_lines(size, min(1.15, 0.22 + rush))


func draw_obstacles():
	for obstacle in obstacles:
		if obstacle["done"]:
			continue
		var pos = obstacle_screen_pos(obstacle)
		if pos.x < -80 or pos.x > get_viewport_rect().size.x + 120:
			continue
		if predict_timer > 0.0 and pos.x > PLAYER_X + 100:
			draw_line(Vector2(pos.x, 344), Vector2(pos.x, 628), Color(0.6, 1.0, 1.0, 0.18), 2)
		draw_obstacle_icon(str(obstacle["kind"]), pos, 72.0)


func draw_obstacle_icon(kind, pos, size):
	var index = 0
	if kind == "cone":
		index = 0
	elif kind == "pothole":
		index = 1
	elif kind == "rail":
		index = 2
	elif kind == "gel":
		index = 3
	elif kind == "rider":
		index = 4
	elif kind == "gap" or kind == "hairpin":
		index = 5
	var rect = Rect2(pos.x - size * 0.5, pos.y - size * 0.88, size, size)
	if atlas_texture != null:
		var region = Rect2((index % 3) * 128, int(index / 3) * 128, 128, 128)
		draw_texture_rect_region(atlas_texture, rect, region)
	else:
		draw_circle(pos, size * 0.35, Color(1.0, 0.25, 0.2))
	if kind == "hairpin":
		draw_text(t("slow"), pos + Vector2(-24, -74), 14, Color(1.0, 0.88, 0.42))


func draw_rivals():
	draw_main_rival()
	var stage = STAGES[stage_index]
	if stage["tag"] != "PACK" and stage["tag"] != "BOSS":
		return
	for i in range(3):
		var gap = 190 + i * 140 + 35 * sin(distance * 0.012 + i * 1.7)
		var pos = Vector2(PLAYER_X + gap, LANES[(i + stage_index) % 3] - 10)
		draw_simple_bike(pos, Color(1.0, 0.24 + i * 0.2, 0.18 + i * 0.18, 0.86), 0.68)


func draw_main_rival():
	var size = get_viewport_rect().size
	var gap = rival_gap()
	var x = PLAYER_X + 250.0 + gap * 1.35
	if gap < 0.0:
		x = PLAYER_X + 96.0 + gap * 0.65
	x = clamp(x, PLAYER_X - 26.0, size.x - 150.0)
	var y = LANES[0] + (LANES[2] - LANES[0]) * (rival_lane_visual / 2.0) - 8.0
	var pos = Vector2(x, y)
	var pressure = clamp(1.0 - abs(gap) / 165.0, 0.0, 1.0)
	if gap > 8.0 and gap < 150.0:
		draw_arc_ribbon(pos + Vector2(-58, -34), Color(1.0, 0.32, 0.18, 0.22 + pressure * 0.3))
	for i in range(3, 0, -1):
		var alpha = (0.05 + pressure * 0.08) * i
		draw_simple_bike(pos + Vector2(i * 20.0, -i * 3.0), Color(1.0, 0.22, 0.14, alpha), 0.72)
	draw_simple_bike(pos, Color(1.0, 0.24, 0.14, 0.96), 0.78 + pressure * 0.05)
	draw_text(t("rival"), pos + Vector2(-36, -88), 14, Color(1.0, 0.5, 0.32))
	if rival_flash_timer > 0.0:
		draw_circle(pos + Vector2(6, -42), 82 + rival_flash_timer * 24.0, Color(1.0, 0.22, 0.12, 0.08 + rival_flash_timer * 0.08))


func draw_player():
	var pos = Vector2(PLAYER_X, LANES[0] + (LANES[2] - LANES[0]) * (lane_visual / 2.0) - air_height)
	var rush = speed_feel()
	if rider_texture != null:
		for i in range(3, 0, -1):
			var ghost_rect = Rect2(pos.x - 94 - i * (18.0 + rush * 20.0), pos.y - 134 + i * 3.0, 188, 188)
			draw_texture_rect(rider_texture, ghost_rect, false, Color(0.35, 1.0, 0.95, 0.035 + rush * 0.05 * i))
	for i in range(5):
		var trail_y = pos.y - 42 + i * 13
		draw_line(Vector2(pos.x - 28 - i * 18, trail_y), Vector2(pos.x - 145 - rush * 120.0, trail_y + 6), Color(0.55, 1.0, 0.95, 0.08 + rush * 0.12), 2 + rush * 2.0)
	if evade_timer > 0.0:
		draw_circle(pos + Vector2(42, -32), 84, Color(0.65, 0.45, 1.0, 0.16))
	if draft_timer > 0.0 or rival_draft_strength() > 0.0:
		draw_arc_ribbon(pos + Vector2(20, -34), Color(0.25, 1.0, 0.8, 0.35 + rival_draft_strength() * 0.25))
	if rider_texture != null:
		var rect = Rect2(pos.x - 94, pos.y - 134, 188, 188)
		draw_texture_rect(rider_texture, rect, false, Color(1, 1, 1, 0.96))
	else:
		draw_simple_bike(pos, Color(0.35, 0.95, 1.0), 1.0)
	if guard > 0:
		draw_circle(pos + Vector2(8, -46), 78, Color(1.0, 0.9, 0.35, 0.08 + min(0.18, guard * 0.035)))
		draw_arc(pos + Vector2(8, -46), 72, 0.0, TAU, 32, Color(1.0, 0.88, 0.35, 0.5), 4)


func draw_simple_bike(pos, color, scale):
	var w = 42.0 * scale
	var alpha = color.a
	var rear = pos + Vector2(-42 * scale, 0)
	var front = pos + Vector2(54 * scale, 0)
	var crank = pos + Vector2(6 * scale, -18 * scale)
	var seat = pos + Vector2(-10 * scale, -58 * scale)
	var bar = pos + Vector2(58 * scale, -54 * scale)
	draw_circle(rear, w, Color(0.05, 0.08, 0.09, 0.9 * alpha))
	draw_arc(rear, w, 0, TAU, 30, Color(0.9, 1.0, 1.0, 0.9 * alpha), 4 * scale)
	draw_circle(front, w, Color(0.05, 0.08, 0.09, 0.9 * alpha))
	draw_arc(front, w, 0, TAU, 30, Color(0.9, 1.0, 1.0, 0.9 * alpha), 4 * scale)
	draw_line(rear, crank, color, 6 * scale)
	draw_line(crank, front, color, 6 * scale)
	draw_line(crank, seat, color, 6 * scale)
	draw_line(seat, bar, color, 6 * scale)
	draw_line(bar, front, color, 6 * scale)
	draw_circle(seat + Vector2(15 * scale, -38 * scale), 20 * scale, color)
	draw_line(seat + Vector2(8 * scale, -18 * scale), bar + Vector2(-20 * scale, 0), color, 13 * scale)


func draw_arc_ribbon(pos, color):
	for i in range(3):
		draw_arc(pos + Vector2(-i * 18, i * 3), 58 + i * 16, -0.8, 0.8, 18, color, 4)


func draw_hud(size):
	var stage = STAGES[stage_index]
	draw_rect(Rect2(0, 0, size.x, 82), Color(0.01, 0.018, 0.022, 0.72))
	draw_text(stage_name(stage_index), Vector2(24, 32), 21, Color(0.92, 1.0, 0.94))
	draw_text("%s / 6" % (stage_index + 1), Vector2(24, 61), 16, Color(0.58, 0.9, 1.0))
	draw_bar(Rect2(342, 24, 190, 16), team_stamina_average() / 100.0, Color(0.2, 0.95, 0.72), t("stamina"))
	draw_bar(Rect2(342, 52, 190, 16), speed / (55.0 + get_relic_bonus("max_speed")), Color(1.0, 0.36, 0.24), t("speed") % speed)
	var progress = distance / float(stage["length"])
	var progress_rect = Rect2(555, 34, 210, 18)
	draw_bar(progress_rect, progress, Color(1.0, 0.86, 0.28), t("distance"))
	draw_text(t("cadence") % int(round(cadence)), Vector2(792, 30), 20, Color(0.88, 1.0, 0.94))
	draw_text(t("formation") % formation_name(), Vector2(792, 60), 15, Color(0.62, 0.95, 1.0))
	draw_text(t("grade") % road_grade, Vector2(940, 25), 16, Color(1.0, 0.9, 0.55))
	draw_text(t("wind") % road_wind, Vector2(940, 49), 16, Color(0.66, 0.95, 1.0))
	draw_text(t("curve") % abs(road_curve), Vector2(1040, 49), 16, Color(1.0, 0.68, 0.4))
	draw_text(t("score") % score, Vector2(1080, 28), 20, Color(0.95, 1.0, 0.94))
	draw_text("x%s" % combo, Vector2(1190, 32), 26, Color(1.0, 0.92, 0.35) if combo >= 5 else Color(0.8, 0.95, 1.0))


func draw_team_panel(size):
	team_rects.clear()
	var x = 18.0
	var y = 104.0
	for i in range(team.size()):
		var member = team[i]
		var rect = Rect2(x, y + i * 78.0, 326, 68)
		team_rects.append(rect)
		var is_leader = i == leader_index
		var fill = Color(0.02, 0.04, 0.045, 0.82) if not is_leader else Color(0.07, 0.035, 0.03, 0.9)
		var stroke = member["color"] if is_leader else Color(0.28, 0.45, 0.48, 0.7)
		draw_round_rect(rect, fill, stroke, 3.0 if is_leader else 2.0)
		draw_circle(rect.position + Vector2(28, 34), 18, member["color"])
		draw_text(rider_display_name(i), rect.position + Vector2(56, 24), 18, Color(0.95, 1.0, 0.94))
		draw_text("%s / %s" % [rider_role(i), rider_body(i)], rect.position + Vector2(56, 44), 13, Color(0.66, 0.82, 0.82))
		var ratio = float(member["stamina"]) / max(1.0, float(member["max_stamina_current"]))
		var bar = Rect2(rect.position + Vector2(188, 19), Vector2(116, 12))
		draw_rect(bar, Color(0.0, 0.0, 0.0, 0.42))
		draw_rect(Rect2(bar.position, Vector2(bar.size.x * clamp(ratio, 0.0, 1.0), bar.size.y)), Color(0.2, 0.95, 0.72) if ratio > 0.35 else Color(1.0, 0.32, 0.22))
		draw_text("%s%%" % int(ratio * 100.0), rect.position + Vector2(188, 54), 13, Color(0.88, 0.95, 0.92))
		draw_text(t("leader") if is_leader else t("protected"), rect.position + Vector2(248, 54), 13, Color(1.0, 0.72, 0.42) if is_leader else Color(0.58, 0.95, 1.0))


func draw_active_orders(size):
	var x = size.x - 250
	var y = 100
	draw_text(t("active_orders"), Vector2(x, y), 15, Color(0.72, 0.92, 0.92))
	var row = 0
	for id in active_commands.keys():
		if float(active_commands[id]) <= 0.0:
			continue
		var rect = Rect2(x, y + 14 + row * 31, 224, 25)
		draw_round_rect(rect, Color(0.02, 0.04, 0.045, 0.76), CARD_LIBRARY[id]["color"], 2.0)
		draw_fit_text(card_name(id), rect.position + Vector2(8, 18), 152, 13, 10, Color(0.94, 1.0, 0.94))
		draw_text("%.1fs" % float(active_commands[id]), rect.position + Vector2(168, 18), 12, Color(1.0, 0.86, 0.42))
		row += 1


func draw_rival_progress_marker(rect, stage_length):
	var rival_progress = clamp(rival_distance / stage_length, 0.0, 1.0)
	var x = rect.position.x + rect.size.x * rival_progress
	var color = Color(1.0, 0.24, 0.14)
	draw_line(Vector2(x, rect.position.y - 8), Vector2(x, rect.position.y + rect.size.y + 8), color, 3)
	draw_colored_polygon(PackedVector2Array([
		Vector2(x, rect.position.y - 11),
		Vector2(x - 7, rect.position.y - 2),
		Vector2(x + 7, rect.position.y - 2)
	]), color)
	var gap = rival_gap()
	var gap_text = t("rival_ahead") % int(max(0.0, gap)) if gap >= 0.0 else t("rival_behind") % int(abs(gap))
	draw_text(gap_text, Vector2(rect.position.x, rect.position.y + 42), 14, Color(1.0, 0.54, 0.36))


func draw_status_chips():
	var chips = []
	if draft_timer > 0.0:
		chips.append("DRAFT")
	if brake_timer > 0.0:
		chips.append("BRAKE")
	if evade_timer > 0.0:
		chips.append("GHOST")
	if wheelie_timer > 0.0:
		chips.append("MANUAL")
	if climb_timer > 0.0:
		chips.append("CLIMB")
	if tempo_timer > 0.0:
		chips.append("TEMPO")
	for i in range(chips.size()):
		var rect = Rect2(22 + i * 86, 94, 76, 26)
		draw_round_rect(rect, Color(0.05, 0.15, 0.17, 0.82), Color(0.42, 1.0, 0.9, 0.72), 3)
		draw_text(chips[i], rect.position + Vector2(10, 18), 13, Color(0.88, 1.0, 0.95))


func draw_card_hand(size):
	hand_rects.clear()
	var total_w = hand.size() * 168 + max(0, hand.size() - 1) * 10
	var x = size.x * 0.5 - total_w * 0.5
	var active = selected_card_index if selected_card_index >= 0 and selected_card_index < hand.size() else -1
	for i in range(hand.size()):
		var rect = Rect2(x + i * 178, size.y - 168, 168, 145)
		hand_rects.append(rect)
		if i != active:
			draw_game_card(rect, hand[i], i + 1)
	if active >= 0:
		var base = hand_rects[active]
		var preview_size = Vector2(236, 250)
		var preview_x = clamp(base.position.x + base.size.x * 0.5 - preview_size.x * 0.5, 18.0, size.x - preview_size.x - 18.0)
		var preview_y = max(118.0, size.y - 430.0)
		selected_card_rect = Rect2(Vector2(preview_x, preview_y), preview_size)
		var glow_rect = Rect2(selected_card_rect.position - Vector2(9, 9), selected_card_rect.size + Vector2(18, 18))
		draw_rect(glow_rect, Color(0.25, 0.95, 1.0, 0.13))
		draw_rect(glow_rect, Color(0.62, 1.0, 0.92, 0.76), false, 4)
		draw_game_card(selected_card_rect, hand[active], active + 1, true)
	else:
		selected_card_rect = Rect2()


func draw_touch_controls(size):
	touch_up_rect = Rect2(24, size.y - 234, 72, 56)
	touch_down_rect = Rect2(24, size.y - 116, 72, 56)
	touch_jump_rect = Rect2(size.x - 150, size.y - 150, 112, 78)
	draw_touch_button(touch_up_rect, t("touch_up"))
	draw_touch_button(touch_down_rect, t("touch_down"))
	draw_touch_button(touch_jump_rect, t("touch_hop"))


func draw_touch_button(rect, label):
	draw_rect(rect, Color(0.02, 0.04, 0.05, 0.72))
	draw_rect(rect, Color(0.55, 0.95, 1.0, 0.7), false, 3)
	var font = get_ui_font()
	var measured = font.get_string_size(label, HORIZONTAL_ALIGNMENT_LEFT, -1, 18)
	var pos = rect.position + Vector2((rect.size.x - measured.x) * 0.5, rect.size.y * 0.5 + 7)
	font.draw_string(get_canvas_item(), pos, label, HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color(0.86, 1.0, 0.95))


func draw_game_card(rect, id, number, large := false):
	var card = CARD_LIBRARY[id]
	draw_round_rect(rect, Color(0.035, 0.05, 0.06, 0.95), card["color"], 4.0)
	var art_height = 88 if large else 52
	var title_y = 123 if large else 79
	var cost_y = 153 if large else 103
	var desc_y = 181 if large else 124
	var number_size = 24 if large else 18
	var title_size = 22 if large else 17
	var cost_size = 17 if large else 15
	var desc_size = 16 if large else 13
	if card_texture != null:
		draw_texture_rect(card_texture, Rect2(rect.position + Vector2(10, 10), Vector2(rect.size.x - 20, art_height)), false, Color(1, 1, 1, 0.46 if large else 0.42))
	draw_rect(Rect2(rect.position + Vector2(10, 10), Vector2(rect.size.x - 20, art_height)), Color(card["color"], 0.16))
	draw_text(str(number), rect.position + Vector2(14, 36 if large else 31), number_size, Color(0.04, 0.05, 0.06))
	draw_fit_text(card_name(id), rect.position + Vector2(16, title_y), rect.size.x - 32, title_size, 12, Color(0.95, 1.0, 0.95))
	draw_text(t("cost") % max(0, int(card["cost"]) - int(get_relic_bonus("cost_cut"))), rect.position + Vector2(16, cost_y), cost_size, Color(1.0, 0.84, 0.44))
	draw_wrapped(card_desc(id), rect.position + Vector2(16, desc_y), rect.size.x - 28, desc_size, Color(0.78, 0.87, 0.86))


func draw_reward_card(rect, id, number):
	var card = CARD_LIBRARY[id]
	draw_round_rect(rect, Color(0.035, 0.05, 0.06, 0.95), card["color"], 5.0)
	if card_texture != null:
		draw_texture_rect(card_texture, Rect2(rect.position + Vector2(14, 14), Vector2(rect.size.x - 28, 116)), false, Color(1, 1, 1, 0.58))
	draw_text("%s" % number, rect.position + Vector2(20, 40), 25, Color(0.03, 0.04, 0.05))
	draw_fit_text(card_name(id), rect.position + Vector2(22, 166), rect.size.x - 44, 24, 15, Color(0.94, 1.0, 0.94))
	draw_text("%s  /  %s" % [card["rarity"].to_upper(), t("cost") % max(0, int(card["cost"]) - int(get_relic_bonus("cost_cut")))], rect.position + Vector2(22, 199), 15, Color(1.0, 0.86, 0.45))
	draw_wrapped(card_desc(id), rect.position + Vector2(22, 234), rect.size.x - 44, 18, Color(0.8, 0.9, 0.9))


func draw_reward_relic(rect, id, number):
	var relic = RELIC_LIBRARY[id]
	draw_round_rect(rect, Color(0.04, 0.045, 0.045, 0.95), Color(1.0, 0.74, 0.24), 5.0)
	if atlas_texture != null:
		draw_texture_rect_region(atlas_texture, Rect2(rect.position + Vector2(74, 38), Vector2(122, 122)), Rect2(256, 128, 128, 128))
	draw_text("%s" % number, rect.position + Vector2(20, 40), 25, Color(0.03, 0.04, 0.05))
	draw_fit_text(relic_name(id), rect.position + Vector2(22, 196), rect.size.x - 44, 24, 15, Color(1.0, 0.92, 0.55))
	draw_wrapped(relic_desc(id), rect.position + Vector2(22, 234), rect.size.x - 44, 18, Color(0.86, 0.9, 0.86))


func draw_particles():
	for p in particles:
		var alpha = clamp(float(p["life"]), 0.0, 1.0)
		var color = p["color"]
		color.a *= alpha
		if str(p["text"]) == "":
			draw_circle(p["pos"], 3.5 + alpha * 3.0, color)
		else:
			draw_text(str(p["text"]), p["pos"], 20, color)


func speed_feel():
	var order_boost = 0.12 if active_commands.size() > 0 else 0.0
	var pressure_boost = team_pressure * 0.18
	return clamp((speed - 17.0) / 24.0 + min(0.42, burst * 0.018) + min(0.3, combo * 0.018) + order_boost + pressure_boost, 0.0, 1.35)


func draw_ground_rush(size, amount):
	for i in range(22):
		var depth = float(i) / 21.0
		var y = lerp(370.0, size.y + 34.0, depth)
		var drift = fmod(distance * (18.0 + amount * 42.0) * (0.35 + depth), size.x + 360.0)
		var x = fmod(i * 137.0 - drift, size.x + 360.0) - 180.0
		var len = (60.0 + depth * 260.0) * (0.35 + amount)
		var alpha = (0.025 + depth * 0.08) * amount
		draw_line(Vector2(x, y), Vector2(x - len, y + 8.0 + depth * 16.0), Color(0.88, 1.0, 0.96, alpha), 1.2 + depth * 4.0)


func draw_speed_lines(size, amount):
	var count = 18 + int(amount * 18.0)
	for i in range(count):
		var y = 116 + i * 21 + fmod(distance * (0.8 + amount * 2.5), 33.0)
		var x = fmod(distance * (18.0 + amount * 34.0) + i * 87.0, size.x + 320.0) - 220.0
		var len = 100 + amount * 420
		draw_line(Vector2(x, y), Vector2(x + len, y + rng.randf_range(-8, 8)), Color(0.65, 0.95, 1.0, 0.07 + amount * 0.2), 2 + amount * 3.5)


func draw_bar(rect, t, color, label):
	draw_round_rect(rect, Color(0.0, 0.0, 0.0, 0.45), Color(0.35, 0.45, 0.46, 0.55), 2)
	var fill = Rect2(rect.position, Vector2(rect.size.x * clamp(t, 0.0, 1.0), rect.size.y))
	draw_rect(fill, color)
	draw_text(label, rect.position + Vector2(8, rect.size.y - 3), 12, Color(0.02, 0.035, 0.04))


func draw_round_rect(rect, fill, stroke, width):
	draw_rect(rect, fill)
	draw_rect(rect, stroke, false, width)


func get_ui_font():
	if ui_font != null:
		return ui_font
	return get_theme_default_font()


func draw_text(text, pos, size, color):
	var font = get_ui_font()
	font.draw_string(get_canvas_item(), pos, str(text), HORIZONTAL_ALIGNMENT_LEFT, -1, size, color)


func draw_fit_text(text, pos, width, max_size, min_size, color):
	var font = get_ui_font()
	var size = max_size
	while size > min_size and font.get_string_size(str(text), HORIZONTAL_ALIGNMENT_LEFT, -1, size).x > width:
		size -= 1
	font.draw_string(get_canvas_item(), pos, str(text), HORIZONTAL_ALIGNMENT_LEFT, -1, size, color)


func draw_centered(text, y, size, color):
	var font = get_ui_font()
	var measured = font.get_string_size(str(text), HORIZONTAL_ALIGNMENT_LEFT, -1, size)
	var x = (get_viewport_rect().size.x - measured.x) * 0.5
	font.draw_string(get_canvas_item(), Vector2(x, y), str(text), HORIZONTAL_ALIGNMENT_LEFT, -1, size, color)


func draw_wrapped(text, pos, width, size, color):
	var source = str(text)
	var words = source.split(" ")
	var joiner = " "
	if words.size() <= 1 and source.length() > 0:
		words = []
		joiner = ""
		for i in range(source.length()):
			words.append(source.substr(i, 1))
	var line = ""
	var y = pos.y
	var font = get_ui_font()
	for word in words:
		var candidate = word if line == "" else line + joiner + word
		if font.get_string_size(candidate, HORIZONTAL_ALIGNMENT_LEFT, -1, size).x > width and line != "":
			draw_text(line, Vector2(pos.x, y), size, color)
			y += size + 4
			line = word
		else:
			line = candidate
	if line != "":
		draw_text(line, Vector2(pos.x, y), size, color)
