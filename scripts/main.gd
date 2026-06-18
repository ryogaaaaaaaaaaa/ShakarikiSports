extends Control

enum Screen { TITLE, RACE, REWARD, GAME_OVER, WIN }

const LANES = [405.0, 478.0, 552.0]
const PLAYER_X = 230.0
const PX_PER_METER = 0.62
const MAX_HAND = 5

const STAGES = [
	{
		"name": "Act 1-1 Neon Shopping Street",
		"tag": "TUTORIAL",
		"length": 3100.0,
		"grade": 0.0,
		"wind": 0.0,
		"hazards": ["cone", "pothole", "gel"],
		"flavor": "Watch the curbs. Turn close calls into speed."
	},
	{
		"name": "Act 1-2 Rainy Arcade Sprint",
		"tag": "CITY",
		"length": 3650.0,
		"grade": -0.2,
		"wind": 0.2,
		"hazards": ["cone", "rail", "pothole", "gel"],
		"flavor": "The road narrows. The crowd is too loud."
	},
	{
		"name": "Act 2-1 Mountain Switchbacks",
		"tag": "CLIMB",
		"length": 4300.0,
		"grade": 1.25,
		"wind": 0.4,
		"hazards": ["pothole", "rail", "hairpin", "gel"],
		"flavor": "Every meter hurts. Climb cards shine here."
	},
	{
		"name": "Act 2-2 Gravel Drop",
		"tag": "DESCENT",
		"length": 4550.0,
		"grade": -1.1,
		"wind": -0.2,
		"hazards": ["gap", "rail", "cone", "pothole", "gel"],
		"flavor": "Gravity is free. Control is not."
	},
	{
		"name": "Act 3-1 Death Peloton",
		"tag": "PACK",
		"length": 5000.0,
		"grade": 0.35,
		"wind": 0.75,
		"hazards": ["rider", "cone", "hairpin", "rail", "gel"],
		"flavor": "Draft the pack, then break it."
	},
	{
		"name": "Final: Chainbreak Boulevard",
		"tag": "BOSS",
		"length": 5650.0,
		"grade": -0.4,
		"wind": 0.9,
		"hazards": ["rider", "gap", "hairpin", "rail", "cone", "gel"],
		"flavor": "The final kilometer decides the whole tour."
	}
]

const CARD_LIBRARY = {
	"sprint": {
		"name": "Redline Sprint",
		"cost": 18,
		"color": Color(1.0, 0.32, 0.24),
		"desc": "+14 burst speed. +1 combo.",
		"rarity": "common"
	},
	"bunny": {
		"name": "Bunny Hop",
		"cost": 10,
		"color": Color(0.35, 0.9, 1.0),
		"desc": "Leap over cones, rails, gaps.",
		"rarity": "common"
	},
	"brake": {
		"name": "Feather Brake",
		"cost": 6,
		"color": Color(0.82, 0.9, 1.0),
		"desc": "Safe hairpins. Gain 1 guard.",
		"rarity": "common"
	},
	"draft": {
		"name": "Slipstream",
		"cost": 7,
		"color": Color(0.3, 0.95, 0.8),
		"desc": "4s draft, +stamina, +speed.",
		"rarity": "common"
	},
	"gel": {
		"name": "Energy Gel",
		"cost": 0,
		"color": Color(1.0, 0.82, 0.28),
		"desc": "Recover 34 stamina. Draw 1.",
		"rarity": "common"
	},
	"line": {
		"name": "Ghost Line",
		"cost": 15,
		"color": Color(0.7, 0.55, 1.0),
		"desc": "0.8s phase. Free lane swap.",
		"rarity": "uncommon"
	},
	"wheelie": {
		"name": "Manual Pop",
		"cost": 12,
		"color": Color(1.0, 0.55, 0.35),
		"desc": "2.6s pothole immunity. Guard +1.",
		"rarity": "uncommon"
	},
	"predict": {
		"name": "Road Sense",
		"cost": 8,
		"color": Color(0.64, 0.95, 1.0),
		"desc": "Reveal danger early. Draw 1.",
		"rarity": "uncommon"
	},
	"overdrive": {
		"name": "Chainbreak",
		"cost": 26,
		"color": Color(1.0, 0.18, 0.14),
		"desc": "Huge burst. +2 combo. Loud.",
		"rarity": "rare"
	},
	"climb": {
		"name": "Dancing Climb",
		"cost": 12,
		"color": Color(0.58, 1.0, 0.5),
		"desc": "7s climbing engine.",
		"rarity": "uncommon"
	},
	"chain": {
		"name": "Clean Shift",
		"cost": 4,
		"color": Color(0.95, 0.95, 0.8),
		"desc": "Draw 2. Small burst.",
		"rarity": "common"
	},
	"revive": {
		"name": "One More Pedal",
		"cost": 22,
		"color": Color(1.0, 0.78, 0.36),
		"desc": "Gain a one-use crash save.",
		"rarity": "rare"
	},
	"tuck": {
		"name": "Aero Tuck",
		"cost": 9,
		"color": Color(0.38, 0.62, 1.0),
		"desc": "Strong on descents. +burst.",
		"rarity": "common"
	},
	"surge": {
		"name": "Peloton Surge",
		"cost": 16,
		"color": Color(0.45, 1.0, 0.72),
		"desc": "If drafting, draw 2 and sprint.",
		"rarity": "uncommon"
	},
	"armor": {
		"name": "Elbow Room",
		"cost": 14,
		"color": Color(0.82, 0.78, 1.0),
		"desc": "Guard +2. Survive contact.",
		"rarity": "uncommon"
	},
	"clear": {
		"name": "Open Road",
		"cost": 18,
		"color": Color(0.72, 1.0, 0.92),
		"desc": "Remove the closest hazard.",
		"rarity": "rare"
	},
	"tempo": {
		"name": "Tempo Engine",
		"cost": 10,
		"color": Color(1.0, 0.72, 0.42),
		"desc": "6s stamina regen and speed floor.",
		"rarity": "uncommon"
	},
	"camera": {
		"name": "Photo Finish",
		"cost": 20,
		"color": Color(1.0, 0.92, 0.52),
		"desc": "Score burst. Strong near goal.",
		"rarity": "rare"
	}
}

const REWARD_CARDS = [
	"sprint", "bunny", "brake", "draft", "gel", "line", "wheelie", "predict",
	"overdrive", "climb", "chain", "revive", "tuck", "surge", "armor", "clear",
	"tempo", "camera"
]

const RELIC_LIBRARY = {
	"bearings": {
		"name": "Ceramic Bearings",
		"desc": "+4 max speed, +2 base speed."
	},
	"tires": {
		"name": "Flatline Tires",
		"desc": "Start each stage with 1 guard."
	},
	"tape": {
		"name": "Sticky Bar Tape",
		"desc": "Near misses restore extra stamina."
	},
	"fork": {
		"name": "Carbon Fork",
		"desc": "Jumps are higher and cleaner."
	},
	"radio": {
		"name": "Team Radio",
		"desc": "Start each stage with one extra card."
	},
	"cog": {
		"name": "Golden Cog",
		"desc": "Every card gives +45 score."
	},
	"brakes": {
		"name": "Rain Brakes",
		"desc": "Hairpins allow more speed."
	},
	"bottle": {
		"name": "Double Bottle Cage",
		"desc": "+18 max stamina."
	},
	"jersey": {
		"name": "Breakaway Jersey",
		"desc": "Combo starts at 2 each stage."
	},
	"computer": {
		"name": "Tiny Bike Computer",
		"desc": "Road Sense lasts longer."
	},
	"chainwax": {
		"name": "Quiet Chain Wax",
		"desc": "Card costs are 1 lower."
	},
	"helmet": {
		"name": "Lucky Helmet",
		"desc": "First crash each run costs no HP."
	}
}

const RELIC_IDS = [
	"bearings", "tires", "tape", "fork", "radio", "cog",
	"brakes", "bottle", "jersey", "computer", "chainwax", "helmet"
]

const STAGE_JA = [
	{
		"name": "Act 1-1 ネオン商店街",
		"flavor": "縁石に注意。ギリギリ回避をスピードに変えろ。"
	},
	{
		"name": "Act 1-2 雨のアーケードスプリント",
		"flavor": "道幅が狭い。歓声が判断を鈍らせる。"
	},
	{
		"name": "Act 2-1 山岳スイッチバック",
		"flavor": "1メートルごとに脚が削れる。登坂カードの出番だ。"
	},
	{
		"name": "Act 2-2 グラベル急降下",
		"flavor": "重力は無料。制御は有料級。"
	},
	{
		"name": "Act 3-1 デス・プロトン",
		"flavor": "集団の後ろにつけ。そこから引き裂け。"
	},
	{
		"name": "Final: チェーンブレイク大通り",
		"flavor": "最後の1キロがツアーの全てを決める。"
	}
]

const CARD_JA = {
	"sprint": {"name": "レッドラインスプリント", "desc": "瞬間速度+14。コンボ+1。"},
	"bunny": {"name": "バニーホップ", "desc": "コーン、柵、穴を飛び越える。"},
	"brake": {"name": "フェザーブレーキ", "desc": "ヘアピンを安全に。ガード+1。"},
	"draft": {"name": "スリップストリーム", "desc": "4秒ドラフト。スタミナと速度を得る。"},
	"gel": {"name": "エナジージェル", "desc": "スタミナ34回復。1枚ドロー。"},
	"line": {"name": "ゴーストライン", "desc": "0.8秒すり抜け。ライン変更が自由。"},
	"wheelie": {"name": "マニュアルポップ", "desc": "2.6秒ポットホール無効。ガード+1。"},
	"predict": {"name": "ロードセンス", "desc": "危険を早めに表示。1枚ドロー。"},
	"overdrive": {"name": "チェーンブレイク", "desc": "巨大加速。コンボ+2。派手。"},
	"climb": {"name": "ダンシングクライム", "desc": "7秒間、登坂エンジンを点火。"},
	"chain": {"name": "クリーンシフト", "desc": "2枚ドロー。小さく加速。"},
	"revive": {"name": "ワンモアペダル", "desc": "落車を1回だけ救う保険を得る。"},
	"tuck": {"name": "エアロタック", "desc": "下りで強い。加速を得る。"},
	"surge": {"name": "プロトンサージ", "desc": "ドラフト中なら2枚ドローして加速。"},
	"armor": {"name": "エルボールーム", "desc": "ガード+2。接触を耐える。"},
	"clear": {"name": "オープンロード", "desc": "一番近い障害物を消す。"},
	"tempo": {"name": "テンポエンジン", "desc": "6秒間スタミナ回復と速度下限。"},
	"camera": {"name": "フォトフィニッシュ", "desc": "スコア獲得。ゴール前で強い。"}
}

const RELIC_JA = {
	"bearings": {"name": "セラミックベアリング", "desc": "最高速+4、基礎速度+2。"},
	"tires": {"name": "フラットラインタイヤ", "desc": "各ステージ開始時にガード+1。"},
	"tape": {"name": "粘着バーテープ", "desc": "ニアミス時のスタミナ回復量が増える。"},
	"fork": {"name": "カーボンフォーク", "desc": "ジャンプが高く、着地が安定する。"},
	"radio": {"name": "チームラジオ", "desc": "各ステージ開始時の手札+1。"},
	"cog": {"name": "黄金のコグ", "desc": "カード使用ごとにスコア+45。"},
	"brakes": {"name": "レインブレーキ", "desc": "ヘアピンをより高速で抜けられる。"},
	"bottle": {"name": "ダブルボトルケージ", "desc": "最大スタミナ+18。"},
	"jersey": {"name": "逃げ屋ジャージ", "desc": "各ステージのコンボ開始値が2になる。"},
	"computer": {"name": "小さなサイコン", "desc": "ロードセンスの効果時間が伸びる。"},
	"chainwax": {"name": "静かなチェーンワックス", "desc": "カードコストが1下がる。"},
	"helmet": {"name": "ラッキーヘルメット", "desc": "ラン中最初の落車でHPを失わない。"}
}

const HAZARD_JA = {
	"cone": "交通コーン",
	"pothole": "ポットホール",
	"rail": "ガードレール",
	"gap": "道路の切れ目",
	"hairpin": "ヘアピン",
	"rider": "ライバル"
}

const UI_TEXT = {
	"en": {
		"subtitle": "ROGUELITE CYCLING",
		"tagline": "Deck-build your legs. Thread the death peloton. Break the final sprint.",
		"start": "START RUN",
		"title_controls": "Space/Enter: start   W/S or arrows: line   Space: hop   1-5: cards   L: language",
		"title_note": "6 stages, card rewards, parts, hit-stop near misses, and one very rude final boulevard.",
		"lang_button": "日本語",
		"stage_clear": "Stage Clear",
		"reward_prompt": "Choose a card or part for the next road.",
		"deck_summary": "Current deck: %s cards   Parts: %s   Score: %s",
		"race_over": "RACE OVER",
		"retry": "Press R / Enter / Space to run it back.",
		"win_title": "PHOTO FINISH!",
		"win_body": "You broke the peloton and survived the boulevard.",
		"win_retry": "Press R / Enter / Space for another route.",
		"result_stats": "Score %s   Best combo x%s   Stage %s/6",
		"win_stats": "Score %s   Best combo x%s   Deck %s   Parts %s",
		"score": "Score %s",
		"guard": "Guard %s",
		"save": "Save %s",
		"cost": "Cost %s",
		"slow": "SLOW",
		"touch_up": "UP",
		"touch_down": "DOWN",
		"touch_hop": "HOP",
		"added": "Added %s",
		"installed": "Installed %s",
		"crashed": "Crashed on %s",
		"stamina": "STAMINA",
		"speed": "SPEED %.1f",
		"distance": "DISTANCE"
	},
	"ja": {
		"subtitle": "ローグライト・サイクリング",
		"tagline": "脚をデッキで組み上げ、死の集団をすり抜け、最後のスプリントを叩き割れ。",
		"start": "ラン開始",
		"title_controls": "Space/Enter: 開始   W/S/矢印: ライン   Space: ホップ   1-5: カード   L: 言語",
		"title_note": "6ステージ、カード報酬、パーツ、ヒットストップ付きニアミス、そして凶悪な最終大通り。",
		"lang_button": "ENGLISH",
		"stage_clear": "ステージクリア",
		"reward_prompt": "次の道へ持っていくカードかパーツを選択。",
		"deck_summary": "デッキ: %s枚   パーツ: %s   スコア: %s",
		"race_over": "レース終了",
		"retry": "R / Enter / Space で再挑戦。",
		"win_title": "フォトフィニッシュ!",
		"win_body": "プロトンを引き裂き、大通りを生き残った。",
		"win_retry": "R / Enter / Space で別ルートへ。",
		"result_stats": "スコア %s   最大コンボ x%s   ステージ %s/6",
		"win_stats": "スコア %s   最大コンボ x%s   デッキ %s   パーツ %s",
		"score": "スコア %s",
		"guard": "ガード %s",
		"save": "保険 %s",
		"cost": "コスト %s",
		"slow": "減速",
		"touch_up": "上",
		"touch_down": "下",
		"touch_hop": "跳ぶ",
		"added": "%s を追加",
		"installed": "%s を装着",
		"crashed": "%s で落車",
		"stamina": "スタミナ",
		"speed": "速度 %.1f",
		"distance": "距離"
	}
}

var screen = Screen.TITLE
var rng = RandomNumberGenerator.new()
var language = "ja"

var bg_texture
var rider_texture
var atlas_texture
var card_texture
var sfx = {}

var stage_index = 0
var distance = 0.0
var speed = 24.0
var burst = 0.0
var stamina = 100.0
var max_stamina = 100.0
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
var start_button_rect = Rect2()
var touch_up_rect = Rect2()
var touch_down_rect = Rect2()
var touch_jump_rect = Rect2()
var language_button_rect = Rect2()


func _ready():
	rng.randomize()
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
	if screen == Screen.RACE:
		if hitstop_timer > 0.0:
			hitstop_timer = max(0.0, hitstop_timer - delta)
			_update_particles(delta * 0.25)
		else:
			_update_race(delta)
	queue_redraw()


func _update_visual_timers(delta):
	shake_timer = max(0.0, shake_timer - delta)
	flash_timer = max(0.0, flash_timer - delta)
	pulse_timer = max(0.0, pulse_timer - delta)
	flow_timer = max(0.0, flow_timer - delta)
	message_timer = max(0.0, message_timer - delta)


func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		_handle_key(event.keycode)
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_handle_click(event.position)
	if event is InputEventScreenTouch and event.pressed:
		_handle_click(event.position)


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
			try_jump(1.0)
		elif keycode == KEY_W or keycode == KEY_UP:
			change_lane(-1)
		elif keycode == KEY_S or keycode == KEY_DOWN:
			change_lane(1)
		elif keycode >= KEY_1 and keycode <= KEY_5:
			play_card(keycode - KEY_1)
	elif screen == Screen.REWARD:
		if keycode >= KEY_1 and keycode <= KEY_3:
			choose_reward(keycode - KEY_1)
	elif screen == Screen.GAME_OVER or screen == Screen.WIN:
		if keycode == KEY_R or keycode == KEY_ENTER or keycode == KEY_SPACE:
			start_run()


func _handle_click(pos):
	if language_button_rect.has_point(pos):
		toggle_language()
		return
	if screen == Screen.TITLE:
		if start_button_rect.has_point(pos):
			start_run()
	elif screen == Screen.RACE:
		if touch_up_rect.has_point(pos):
			change_lane(-1)
			return
		if touch_down_rect.has_point(pos):
			change_lane(1)
			return
		if touch_jump_rect.has_point(pos):
			try_jump(1.0)
			return
		for i in range(hand_rects.size()):
			if hand_rects[i].has_point(pos):
				play_card(i)
				return
	elif screen == Screen.REWARD:
		for i in range(reward_rects.size()):
			if reward_rects[i].has_point(pos):
				choose_reward(i)
				return
	elif screen == Screen.GAME_OVER or screen == Screen.WIN:
		start_run()


func start_run():
	stage_index = 0
	distance = 0.0
	speed = 24.0
	burst = 0.0
	max_stamina = 100.0
	stamina = max_stamina
	hp = max_hp
	score = 0
	combo = 0
	best_combo = 0
	guard = 0
	revive_tokens = 0
	lucky_helmet_ready = false
	relics.clear()
	deck = ["sprint", "sprint", "bunny", "bunny", "brake", "draft", "gel", "chain", "predict", "line"]
	setup_stage(0)
	screen = Screen.RACE
	play_sfx("stage_clear", 0.82)


func setup_stage(index):
	stage_index = index
	distance = 0.0
	speed = 24.0 + get_relic_bonus("base_speed")
	burst = 0.0
	lane = 1
	lane_visual = 1.0
	air_height = 0.0
	vertical_velocity = 0.0
	on_ground = true
	guard = 0
	if has_relic("tires"):
		guard += 1
	if has_relic("jersey"):
		combo = 2
	else:
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
	for i in range(4 + int(has_relic("radio"))):
		draw_card()
	show_message(stage_flavor(stage_index), 3.0)


func _update_race(delta):
	var stage = STAGES[stage_index]
	lane_cooldown = max(0.0, lane_cooldown - delta)
	draft_timer = max(0.0, draft_timer - delta)
	brake_timer = max(0.0, brake_timer - delta)
	evade_timer = max(0.0, evade_timer - delta)
	wheelie_timer = max(0.0, wheelie_timer - delta)
	predict_timer = max(0.0, predict_timer - delta)
	climb_timer = max(0.0, climb_timer - delta)
	tempo_timer = max(0.0, tempo_timer - delta)
	lane_visual = lerp(lane_visual, float(lane), min(1.0, delta * 9.0))

	draw_timer -= delta
	if draw_timer <= 0.0:
		if hand.size() < MAX_HAND:
			draw_card()
		draw_timer = 3.0

	_update_physics(delta, stage)
	_generate_obstacles(stage)
	_check_obstacles()
	_update_particles(delta)

	if distance >= float(stage["length"]):
		complete_stage()


func _update_physics(delta, stage):
	var regen = 7.5
	if draft_timer > 0.0:
		regen += 7.0
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
	score += int(stamina) * 4 + best_combo * 75
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
	if id == "bottle":
		max_stamina += 18.0
		stamina = max_stamina


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
	var cost = max(0, int(card["cost"]) - int(has_relic("chainwax")))
	if stamina < cost:
		_make_hitstop(0.035, 5.0)
		add_text_particle("NO LEGS", Vector2(520, 600), Color(1.0, 0.38, 0.34))
		return
	stamina -= cost
	hand.remove_at(index)
	discard.append(id)
	score += 45 if has_relic("cog") else 0
	apply_card(id)
	play_sfx("card", 1.0 + rng.randf_range(-0.06, 0.08))


func apply_card(id):
	if id == "sprint":
		burst += 14.0
		combo += 1
		_make_hitstop(0.045, 7.0)
		add_text_particle("REDLINE", Vector2(420, 260), Color(1.0, 0.35, 0.25))
	elif id == "bunny":
		try_jump(1.24 + get_relic_bonus("jump_power"))
	elif id == "brake":
		brake_timer = 2.0
		guard += 1
		speed = max(10.0, speed - 4.0)
		add_text_particle("CONTROL", Vector2(420, 260), Color(0.78, 0.92, 1.0))
	elif id == "draft":
		draft_timer = 4.5
		burst += 3.0
		stamina = min(max_stamina, stamina + 14.0)
		add_text_particle("SLIPSTREAM", Vector2(420, 260), Color(0.35, 1.0, 0.78))
	elif id == "gel":
		stamina = min(max_stamina, stamina + 34.0)
		draw_card()
		add_text_particle("+STAMINA", Vector2(420, 260), Color(1.0, 0.86, 0.34))
	elif id == "line":
		evade_timer = 0.8
		lane_cooldown = 0.0
		add_text_particle("GHOST LINE", Vector2(420, 260), Color(0.75, 0.55, 1.0))
	elif id == "wheelie":
		wheelie_timer = 2.6
		guard += 1
		add_text_particle("MANUAL", Vector2(420, 260), Color(1.0, 0.55, 0.35))
	elif id == "predict":
		predict_timer = 11.0 if has_relic("computer") else 8.0
		draw_card()
		add_text_particle("ROAD SENSE", Vector2(420, 260), Color(0.64, 0.95, 1.0))
	elif id == "overdrive":
		burst += 22.0
		combo += 2
		pulse_timer = 0.5
		_make_hitstop(0.11, 16.0)
		add_text_particle("CHAINBREAK!", Vector2(430, 220), Color(1.0, 0.22, 0.14))
	elif id == "climb":
		climb_timer = 7.0
		stamina = min(max_stamina, stamina + 7.0)
		add_text_particle("DANCING", Vector2(420, 260), Color(0.58, 1.0, 0.5))
	elif id == "chain":
		burst += 4.8
		draw_card()
		draw_card()
		add_text_particle("DRAW 2", Vector2(420, 260), Color(0.95, 0.95, 0.8))
	elif id == "revive":
		revive_tokens += 1
		add_text_particle("SAVE READY", Vector2(420, 260), Color(1.0, 0.8, 0.32))
	elif id == "tuck":
		var grade = float(STAGES[stage_index]["grade"])
		burst += 15.0 if grade < 0.0 else 7.0
		add_text_particle("AERO", Vector2(420, 260), Color(0.38, 0.62, 1.0))
	elif id == "surge":
		if draft_timer > 0.0:
			draw_card()
			draw_card()
			burst += 16.0
		else:
			burst += 5.0
		add_text_particle("SURGE", Vector2(420, 260), Color(0.45, 1.0, 0.72))
	elif id == "armor":
		guard += 2
		add_text_particle("ELBOW ROOM", Vector2(420, 260), Color(0.82, 0.78, 1.0))
	elif id == "clear":
		clear_nearest_hazard()
	elif id == "tempo":
		tempo_timer = 6.0
		burst += 2.0
		add_text_particle("TEMPO", Vector2(420, 260), Color(1.0, 0.72, 0.42))
	elif id == "camera":
		var progress = distance / float(STAGES[stage_index]["length"])
		var gained = int(450 + progress * 900 + combo * 25)
		score += gained
		burst += 6.0 if progress > 0.75 else 2.0
		add_text_particle("+%s PHOTO" % gained, Vector2(420, 260), Color(1.0, 0.92, 0.52))


func try_jump(multiplier):
	if on_ground or air_height < 8.0:
		on_ground = false
		vertical_velocity = 470.0 * multiplier
		air_height = max(air_height, 1.0)
		_make_hitstop(0.018, 2.0)
	else:
		vertical_velocity += 90.0 * multiplier


func change_lane(dir):
	if lane_cooldown > 0.0:
		return
	lane = clamp(lane + dir, 0, 2)
	lane_cooldown = 0.12


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
	if kind == "max_speed" and has_relic("bearings"):
		value += 4.0
	if kind == "base_speed" and has_relic("bearings"):
		value += 2.0
	if kind == "jump_power" and has_relic("fork"):
		value += 0.16
	if kind == "jump_gravity" and has_relic("fork"):
		value += 65.0
	if kind == "hairpin_speed" and has_relic("brakes"):
		value += 7.0
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
	draw_background(size, 0.72)
	draw_road(size)
	draw_obstacles()
	draw_rivals()
	draw_player()
	draw_particles()
	draw_hud(size)
	draw_card_hand(size)
	draw_touch_controls(size)
	if message_timer > 0.0:
		draw_centered(race_message, 102, 24, Color(1.0, 0.91, 0.58))
	if pulse_timer > 0.0:
		draw_rect(Rect2(Vector2.ZERO, size), Color(1.0, 0.18, 0.13, min(0.18, pulse_timer * 0.36)), false, 14)


func draw_reward(size):
	draw_background(size, 0.52)
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.02, 0.04, 0.05, 0.58))
	draw_centered(t("stage_clear"), 92, 54, Color(0.92, 1.0, 0.94))
	draw_centered(t("reward_prompt"), 142, 22, Color(0.8, 0.9, 0.9))
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
	var road = PackedVector2Array([
		Vector2(-80, size.y + 80),
		Vector2(size.x + 80, size.y + 80),
		Vector2(size.x + 30, 360),
		Vector2(-30, 360)
	])
	draw_colored_polygon(road, Color(0.095, 0.12, 0.13, 0.95))
	for y in LANES:
		draw_line(Vector2(0, y + 35), Vector2(size.x, y + 35), Color(1, 1, 1, 0.14), 2)
		var dash_offset = fmod(distance * 9.0, 96.0)
		for x in range(-120, int(size.x) + 140, 96):
			draw_line(Vector2(x - dash_offset, y), Vector2(x + 42 - dash_offset, y), Color(0.88, 0.94, 0.9, 0.48), 4)
	draw_line(Vector2(0, 360), Vector2(size.x, 360), Color(0.2, 0.95, 1.0, 0.25), 5)
	draw_line(Vector2(0, 640), Vector2(size.x, 640), Color(1.0, 0.25, 0.2, 0.23), 6)
	draw_speed_lines(size, min(0.85, max(0.12, speed / 70.0)))


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
	var stage = STAGES[stage_index]
	if stage["tag"] != "PACK" and stage["tag"] != "BOSS":
		return
	for i in range(3):
		var gap = 190 + i * 140 + 35 * sin(distance * 0.012 + i * 1.7)
		var pos = Vector2(PLAYER_X + gap, LANES[(i + stage_index) % 3] - 10)
		draw_simple_bike(pos, Color(1.0, 0.24 + i * 0.2, 0.18 + i * 0.18, 0.86), 0.68)


func draw_player():
	var pos = Vector2(PLAYER_X, LANES[0] + (LANES[2] - LANES[0]) * (lane_visual / 2.0) - air_height)
	if evade_timer > 0.0:
		draw_circle(pos + Vector2(42, -32), 84, Color(0.65, 0.45, 1.0, 0.16))
	if draft_timer > 0.0:
		draw_arc_ribbon(pos + Vector2(20, -34), Color(0.25, 1.0, 0.8, 0.5))
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
	var rear = pos + Vector2(-42 * scale, 0)
	var front = pos + Vector2(54 * scale, 0)
	var crank = pos + Vector2(6 * scale, -18 * scale)
	var seat = pos + Vector2(-10 * scale, -58 * scale)
	var bar = pos + Vector2(58 * scale, -54 * scale)
	draw_circle(rear, w, Color(0.05, 0.08, 0.09, 0.9))
	draw_arc(rear, w, 0, TAU, 30, Color(0.9, 1.0, 1.0, 0.9), 4 * scale)
	draw_circle(front, w, Color(0.05, 0.08, 0.09, 0.9))
	draw_arc(front, w, 0, TAU, 30, Color(0.9, 1.0, 1.0, 0.9), 4 * scale)
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
	draw_bar(Rect2(420, 24, 220, 16), stamina / max_stamina, Color(0.2, 0.95, 0.72), t("stamina"))
	draw_bar(Rect2(420, 52, 220, 16), speed / (51.0 + get_relic_bonus("max_speed")), Color(1.0, 0.36, 0.24), t("speed") % speed)
	var progress = distance / float(stage["length"])
	draw_bar(Rect2(678, 34, 245, 18), progress, Color(1.0, 0.86, 0.28), t("distance"))
	for i in range(max_hp):
		var c = Color(1.0, 0.22, 0.16) if i < hp else Color(0.18, 0.18, 0.18)
		draw_circle(Vector2(935 + i * 28, 43), 10, c)
	draw_text(t("score") % score, Vector2(1035, 34), 22, Color(0.95, 1.0, 0.94))
	draw_text("x%s" % combo, Vector2(1165, 34), 34, Color(1.0, 0.92, 0.35) if combo >= 5 else Color(0.8, 0.95, 1.0))
	if guard > 0:
		draw_text(t("guard") % guard, Vector2(1035, 64), 16, Color(1.0, 0.88, 0.35))
	if revive_tokens > 0:
		draw_text(t("save") % revive_tokens, Vector2(1115, 64), 16, Color(1.0, 0.78, 0.35))
	draw_status_chips()


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
	for i in range(hand.size()):
		var rect = Rect2(x + i * 178, size.y - 168, 168, 145)
		hand_rects.append(rect)
		draw_game_card(rect, hand[i], i + 1)


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
	var font = get_theme_default_font()
	var measured = font.get_string_size(label, HORIZONTAL_ALIGNMENT_LEFT, -1, 18)
	var pos = rect.position + Vector2((rect.size.x - measured.x) * 0.5, rect.size.y * 0.5 + 7)
	font.draw_string(get_canvas_item(), pos, label, HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color(0.86, 1.0, 0.95))


func draw_game_card(rect, id, number):
	var card = CARD_LIBRARY[id]
	draw_round_rect(rect, Color(0.035, 0.05, 0.06, 0.95), card["color"], 4.0)
	if card_texture != null:
		draw_texture_rect(card_texture, Rect2(rect.position + Vector2(10, 10), Vector2(rect.size.x - 20, 52)), false, Color(1, 1, 1, 0.42))
	draw_rect(Rect2(rect.position + Vector2(10, 10), Vector2(rect.size.x - 20, 52)), Color(card["color"], 0.16))
	draw_text(str(number), rect.position + Vector2(14, 31), 18, Color(0.04, 0.05, 0.06))
	draw_fit_text(card_name(id), rect.position + Vector2(16, 79), rect.size.x - 32, 17, 12, Color(0.95, 1.0, 0.95))
	draw_text(t("cost") % max(0, int(card["cost"]) - int(has_relic("chainwax"))), rect.position + Vector2(16, 103), 15, Color(1.0, 0.84, 0.44))
	draw_wrapped(card_desc(id), rect.position + Vector2(16, 124), rect.size.x - 28, 13, Color(0.78, 0.87, 0.86))


func draw_reward_card(rect, id, number):
	var card = CARD_LIBRARY[id]
	draw_round_rect(rect, Color(0.035, 0.05, 0.06, 0.95), card["color"], 5.0)
	if card_texture != null:
		draw_texture_rect(card_texture, Rect2(rect.position + Vector2(14, 14), Vector2(rect.size.x - 28, 116)), false, Color(1, 1, 1, 0.58))
	draw_text("%s" % number, rect.position + Vector2(20, 40), 25, Color(0.03, 0.04, 0.05))
	draw_fit_text(card_name(id), rect.position + Vector2(22, 166), rect.size.x - 44, 24, 15, Color(0.94, 1.0, 0.94))
	draw_text(card["rarity"].to_upper(), rect.position + Vector2(22, 199), 15, Color(1.0, 0.86, 0.45))
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


func draw_speed_lines(size, amount):
	for i in range(18):
		var y = 124 + i * 29 + fmod(distance * (0.2 + amount), 29.0)
		var x = fmod(distance * 14.0 + i * 87.0, size.x + 260.0) - 180.0
		var len = 80 + amount * 230
		draw_line(Vector2(x, y), Vector2(x + len, y + rng.randf_range(-6, 6)), Color(0.65, 0.95, 1.0, 0.08 + amount * 0.18), 2 + amount * 3)


func draw_bar(rect, t, color, label):
	draw_round_rect(rect, Color(0.0, 0.0, 0.0, 0.45), Color(0.35, 0.45, 0.46, 0.55), 2)
	var fill = Rect2(rect.position, Vector2(rect.size.x * clamp(t, 0.0, 1.0), rect.size.y))
	draw_rect(fill, color)
	draw_text(label, rect.position + Vector2(8, rect.size.y - 3), 12, Color(0.02, 0.035, 0.04))


func draw_round_rect(rect, fill, stroke, width):
	draw_rect(rect, fill)
	draw_rect(rect, stroke, false, width)


func draw_text(text, pos, size, color):
	var font = get_theme_default_font()
	font.draw_string(get_canvas_item(), pos, str(text), HORIZONTAL_ALIGNMENT_LEFT, -1, size, color)


func draw_fit_text(text, pos, width, max_size, min_size, color):
	var font = get_theme_default_font()
	var size = max_size
	while size > min_size and font.get_string_size(str(text), HORIZONTAL_ALIGNMENT_LEFT, -1, size).x > width:
		size -= 1
	font.draw_string(get_canvas_item(), pos, str(text), HORIZONTAL_ALIGNMENT_LEFT, -1, size, color)


func draw_centered(text, y, size, color):
	var font = get_theme_default_font()
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
	var font = get_theme_default_font()
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
