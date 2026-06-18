extends Control

enum Phase { TITLE, STAGE_INTRO, DECISION, RESOLVE, FINISH, RESULT }

const MAX_HAND = 5
const DECISION_ENERGY = 3
const FINISH_INDEX = 5

const SEGMENTS = [
	{
		"id": "riverside",
		"terrain": "flat",
		"event": "",
		"finish": false,
		"duration": 3.4,
		"grade": 0.05,
		"wind": 0.22,
		"curve": 0.12,
		"speed": 40.0,
		"name_en": "Riverside Flat",
		"name_ja": "河川敷の平坦",
		"brief_en": "The rival is measuring you. Spend little, stay close.",
		"brief_ja": "宿敵は様子見。脚を使いすぎず、近くに残る。"
	},
	{
		"id": "echelon",
		"terrain": "crosswind",
		"event": "",
		"finish": false,
		"duration": 3.8,
		"grade": 0.0,
		"wind": 0.94,
		"curve": 0.18,
		"speed": 38.0,
		"name_en": "Crosswind Farm Road",
		"name_ja": "横風の農道",
		"brief_en": "Wind is ripping from the side. Drafting matters here.",
		"brief_ja": "横風が強い。ここは番手と大吾の価値が跳ねる。"
	},
	{
		"id": "olive_wall",
		"terrain": "climb",
		"event": "rival_attack",
		"finish": false,
		"duration": 4.4,
		"grade": 1.35,
		"wind": 0.34,
		"curve": 0.72,
		"speed": 31.0,
		"name_en": "Olive Wall",
		"name_ja": "オリーブ坂",
		"brief_en": "The climb is where attacks bite. Naruse can answer it.",
		"brief_ja": "登りのアタック予告。鳴瀬なら刺し返せる。"
	},
	{
		"id": "reset_flat",
		"terrain": "flat",
		"event": "",
		"finish": false,
		"duration": 3.6,
		"grade": 0.12,
		"wind": 0.35,
		"curve": -0.16,
		"speed": 41.0,
		"name_en": "Town Approach",
		"name_ja": "街へ向かう平坦",
		"brief_en": "A chance to rebuild position before the fast run-in.",
		"brief_ja": "終盤前の立て直し。差と脚を整える。"
	},
	{
		"id": "canyon_drop",
		"terrain": "descent",
		"event": "",
		"finish": false,
		"duration": 3.3,
		"grade": -1.1,
		"wind": 0.45,
		"curve": -0.86,
		"speed": 50.0,
		"name_en": "Canyon Descent",
		"name_ja": "渓谷の下り",
		"brief_en": "High speed, little time. A leadout here sets the finish.",
		"brief_ja": "高速の下り。ここで列車を組むと決着が変わる。"
	},
	{
		"id": "final_km",
		"terrain": "flat",
		"event": "final_km",
		"finish": true,
		"duration": 4.6,
		"grade": 0.18,
		"wind": 0.62,
		"curve": 0.28,
		"speed": 48.0,
		"name_en": "Final Kilometer",
		"name_ja": "最終1km",
		"brief_en": "The road opens. If Kurokawa has legs, sprint now.",
		"brief_ja": "道が開けた。黒川の脚が残っているなら、今だ。"
	}
]

const CARD_LIBRARY = {
	"draft": {
		"name": "Hold Wheel",
		"cost": 0,
		"color": Color(0.34, 0.95, 1.0),
		"tag": "DRAFT",
		"desc": "Draft this segment. Recover stamina and keep the gap stable."
	},
	"tempo": {
		"name": "Raise Tempo",
		"cost": 1,
		"color": Color(1.0, 0.72, 0.32),
		"tag": "PACE",
		"desc": "Moderate acceleration. Close a small gap for a small cost."
	},
	"chase": {
		"name": "Chase",
		"cost": 2,
		"color": Color(1.0, 0.36, 0.22),
		"tag": "BURN",
		"desc": "Close a large gap. Costs heavy stamina and adds fatigue."
	},
	"dance": {
		"name": "Out of Saddle",
		"cost": 2,
		"color": Color(0.72, 1.0, 0.42),
		"tag": "CLIMB",
		"desc": "Climb only. Dance on the pedals and pull back time."
	},
	"sprint": {
		"name": "Kurokawa Sprint",
		"cost": 3,
		"color": Color(1.0, 0.18, 0.12),
		"tag": "FINISH",
		"desc": "Finish only, stamina 30+. Explosive acceleration."
	},
	"daigo_pull": {
		"name": "Daigo Pull",
		"cost": 2,
		"color": Color(0.35, 0.7, 1.0),
		"tag": "ALLY",
		"desc": "Twice per stage. Strong draft, stamina recovery, gap control."
	},
	"naruse_attack": {
		"name": "Naruse Attack",
		"cost": 2,
		"color": Color(0.58, 1.0, 0.48),
		"tag": "ALLY",
		"desc": "Climb only, once. Naruse counters the rival and drains them."
	},
	"leadout": {
		"name": "Leadout Train",
		"cost": 3,
		"color": Color(1.0, 0.52, 0.18),
		"tag": "SETUP",
		"desc": "Last two segments, once. Gives the next sprint a huge bonus."
	},
	"fatigue": {
		"name": "Fatigue",
		"cost": -1,
		"color": Color(0.32, 0.34, 0.36),
		"tag": "DEAD",
		"desc": "Unplayable. It clogs your hand until the stage ends."
	}
}

const CARD_JA = {
	"draft": {"name": "番手キープ", "desc": "この区間はドラフト。スタミナ微回復、差を維持。"},
	"tempo": {"name": "ペースアップ", "desc": "中程度に前へ出る。少し脚を使って差を詰める。"},
	"chase": {"name": "追走", "desc": "大きく差を詰める。スタミナ大消費、疲労を1枚追加。"},
	"dance": {"name": "ダンシング", "desc": "登り専用。立ち漕ぎで差を詰める。"},
	"sprint": {"name": "黒川スプリント", "desc": "決着専用、スタミナ30以上。爆発的に加速。"},
	"daigo_pull": {"name": "大吾に引かせる", "desc": "1ステージ2回。強ドラフトで脚を戻し、差を抑える。"},
	"naruse_attack": {"name": "鳴瀬のアタック", "desc": "登り専用、1回。宿敵を消耗させアタックを潰す。"},
	"leadout": {"name": "リードアウト列車", "desc": "終盤2区間で1回。次のスプリントに巨大ボーナス。"},
	"fatigue": {"name": "疲労", "desc": "プレイ不可。手札を圧迫する。"}
}

const INITIAL_DECK = [
	"draft", "draft", "draft",
	"tempo", "tempo",
	"chase", "chase",
	"sprint",
	"daigo_pull",
	"leadout",
	"naruse_attack"
]

const UI_TEXT = {
	"ja": {
		"subtitle": "Roguelite Cycling",
		"tagline": "決め所で指示し、区間を見届けるロードレース・デッキバトル",
		"start": "スタート",
		"lang_button": "EN",
		"stage_intro": "Stage 1  Chainbreak Trial",
		"intro_body": "黒川の脚を残し、宿敵チームより先に最終スプリントへ。",
		"decision": "判断区間",
		"resolve": "解決",
		"resolving": "区間解決中",
		"finish_phase": "FINISH",
		"energy": "脚",
		"energy_short": "脚",
		"stamina": "黒川",
		"gap": "差",
		"front": "先頭",
		"rival": "宿敵",
		"terrain": "地形",
		"next": "次",
		"combo": "COMBO",
		"cards": "手札",
		"committed": "指示",
		"threat_attack": "アタック予告",
		"threat_finish": "決着区間",
		"leadout_ready": "列車完成",
		"fatigue_added": "疲労 +1",
		"no_energy": "脚が足りない",
		"condition_climb": "登りでのみ使用可",
		"condition_finish": "決着区間でのみ使用可",
		"condition_late": "終盤2区間でのみ使用可",
		"condition_stamina": "スタミナ30以上が必要",
		"condition_used": "このステージではもう使えない",
		"unplayable": "プレイ不可",
		"note_coast": "見送った",
		"note_draft": "番手で脚を戻した",
		"note_crosswind_safe": "横風をいなした",
		"note_crosswind_hit": "横風を直撃で受けた",
		"note_tempo": "テンポで詰めた",
		"note_chase": "脚を燃やして追走",
		"note_dance": "登りで踏み切った",
		"note_daigo": "大吾の牽引で楽になった",
		"note_naruse": "鳴瀬が宿敵を削った",
		"note_attack_counter": "アタックを潰した",
		"note_attack_hit": "宿敵のアタックが刺さった",
		"note_leadout": "列車を組んだ",
		"note_sprint": "黒川がもがいた",
		"note_leadout_sprint": "列車から黒川発射",
		"note_no_sprint": "スプリントに乗り遅れた",
		"note_dropped": "黒川が千切れた",
		"win_title": "WIN",
		"lose_title": "LOSE",
		"win_body": "黒川がハンドルを投げ、宿敵を差し切った。",
		"lose_body": "脚か位置が足りず、決着に絡めなかった。",
		"retry": "R / Enter で再走",
		"score": "Score %s / Best Combo x%s",
		"deck": "山札 %s  捨て札 %s  疲労 %s",
		"help_decision": "Enterで区間解決 / 1-5でカード",
		"photo": "PHOTO FINISH",
		"dropped": "DROPPED"
	},
	"en": {
		"subtitle": "Roguelite Cycling",
		"tagline": "Make the call, then watch the segment explode.",
		"start": "Start",
		"lang_button": "JP",
		"stage_intro": "Stage 1  Chainbreak Trial",
		"intro_body": "Save Kurokawa's legs and beat the rival into the sprint.",
		"decision": "Decision",
		"resolve": "Resolve",
		"resolving": "Resolving Segment",
		"finish_phase": "FINISH",
		"energy": "Legs",
		"energy_short": "E",
		"stamina": "Kurokawa",
		"gap": "Gap",
		"front": "Front",
		"rival": "Rival",
		"terrain": "Terrain",
		"next": "Next",
		"combo": "COMBO",
		"cards": "Hand",
		"committed": "Orders",
		"threat_attack": "Attack warning",
		"threat_finish": "Finish segment",
		"leadout_ready": "Leadout ready",
		"fatigue_added": "Fatigue +1",
		"no_energy": "Not enough legs",
		"condition_climb": "Climb only",
		"condition_finish": "Finish only",
		"condition_late": "Last two segments only",
		"condition_stamina": "Needs 30+ stamina",
		"condition_used": "Already used this stage",
		"unplayable": "Unplayable",
		"note_coast": "Held position",
		"note_draft": "Recovered in the draft",
		"note_crosswind_safe": "Survived the crosswind",
		"note_crosswind_hit": "Hit by the crosswind",
		"note_tempo": "Closed with tempo",
		"note_chase": "Burned legs to chase",
		"note_dance": "Danced up the climb",
		"note_daigo": "Daigo pulled hard",
		"note_naruse": "Naruse hurt the rival",
		"note_attack_counter": "Countered the attack",
		"note_attack_hit": "The rival attack landed",
		"note_leadout": "Built the train",
		"note_sprint": "Kurokawa opened the sprint",
		"note_leadout_sprint": "Launched from the train",
		"note_no_sprint": "Missed the sprint",
		"note_dropped": "Kurokawa was dropped",
		"win_title": "WIN",
		"lose_title": "LOSE",
		"win_body": "Kurokawa threw the bike and beat the rival at the line.",
		"lose_body": "The legs or position were not there when it mattered.",
		"retry": "R / Enter to retry",
		"score": "Score %s / Best Combo x%s",
		"deck": "Draw %s  Discard %s  Fatigue %s",
		"help_decision": "Enter to resolve / 1-5 for cards",
		"photo": "PHOTO FINISH",
		"dropped": "DROPPED"
	}
}

const TERRAIN_JA = {
	"flat": "平坦",
	"crosswind": "横風",
	"climb": "登り",
	"descent": "下り"
}

const TERRAIN_EN = {
	"flat": "Flat",
	"crosswind": "Crosswind",
	"climb": "Climb",
	"descent": "Descent"
}

var rng = RandomNumberGenerator.new()
var language = "ja"
var screen = Phase.TITLE

var ui_font = null
var bg_texture = null
var rider_texture = null
var atlas_texture = null
var card_texture = null
var sfx = {}

var deck = []
var draw_pile = []
var discard_pile = []
var hand = []
var committed_cards = []
var resolve_effects = {}

var segment_index = 0
var intro_timer = 0.0
var resolve_timer = 0.0
var resolve_duration = 3.5
var resolve_start_gap = 0.0
var resolve_target_gap = 0.0
var resolve_start_stamina = 100.0
var resolve_target_stamina = 100.0
var resolve_start_distance = 0.0
var resolve_speed = 40.0
var resolve_summary = ""

var energy = DECISION_ENERGY
var kuro_stamina = 100.0
var gap_seconds = 2.6
var rival_distance = 0.0
var rival_stamina = 100.0
var rival_pace = 1.0
var distance = 0.0
var speed = 36.0
var road_grade = 0.0
var road_wind = 0.0
var road_curve = 0.0
var road_tilt = 0.0

var daigo_uses = 0
var naruse_used = false
var leadout_used = false
var leadout_ready = false
var dropped = false
var won = false

var combo = 0
var best_combo = 0
var score = 0
var fatigue_count = 0

var race_message = ""
var message_timer = 0.0
var result_title = ""
var result_body = ""
var result_detail = ""

var particles = []
var hitstop_timer = 0.0
var shake_timer = 0.0
var shake_strength = 0.0
var flash_timer = 0.0
var pulse_timer = 0.0
var flow_timer = 0.0
var finish_photo_timer = 0.0

var hand_rects = []
var start_button_rect = Rect2()
var resolve_button_rect = Rect2()
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
	update_road_from_segment()


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


func set_phase(next_phase):
	screen = next_phase
	clear_card_selection()


func _process(delta):
	_update_visual_timers(delta)
	suppress_mouse_click_timer = max(0.0, suppress_mouse_click_timer - delta)
	if hitstop_timer > 0.0:
		hitstop_timer = max(0.0, hitstop_timer - delta)
		_update_particles(delta * 0.25)
	else:
		if screen == Phase.STAGE_INTRO:
			intro_timer -= delta
			if intro_timer <= 0.0:
				begin_decision()
		elif screen == Phase.RESOLVE or screen == Phase.FINISH:
			_update_resolve(delta)
		_update_particles(delta)
	_update_card_selection()
	queue_redraw()


func _update_visual_timers(delta):
	shake_timer = max(0.0, shake_timer - delta)
	flash_timer = max(0.0, flash_timer - delta)
	pulse_timer = max(0.0, pulse_timer - delta)
	flow_timer = max(0.0, flow_timer - delta)
	finish_photo_timer = max(0.0, finish_photo_timer - delta)
	message_timer = max(0.0, message_timer - delta)
	if shake_timer <= 0.0:
		shake_strength = 0.0


func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		_handle_key(event.keycode)
	if event is InputEventScreenTouch and event.pressed:
		suppress_mouse_click_timer = 0.35
		_handle_click(event.position)
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if suppress_mouse_click_timer <= 0.0:
			_handle_click(event.position)


func _handle_key(keycode):
	if keycode == KEY_L:
		toggle_language()
		return
	if keycode == KEY_ESCAPE:
		set_phase(Phase.TITLE)
		return
	if screen == Phase.TITLE:
		if keycode == KEY_ENTER or keycode == KEY_SPACE:
			start_run()
	elif screen == Phase.STAGE_INTRO:
		if keycode == KEY_ENTER or keycode == KEY_SPACE:
			begin_decision()
	elif screen == Phase.DECISION:
		if keycode == KEY_ENTER or keycode == KEY_SPACE:
			confirm_decision()
		elif keycode >= KEY_1 and keycode <= KEY_5:
			play_card(keycode - KEY_1)
	elif screen == Phase.RESULT:
		if keycode == KEY_R or keycode == KEY_ENTER or keycode == KEY_SPACE:
			start_run()


func _handle_click(pos):
	if language_button_rect.has_point(pos):
		toggle_language()
		return
	if screen == Phase.TITLE:
		if start_button_rect.has_point(pos):
			start_run()
	elif screen == Phase.STAGE_INTRO:
		begin_decision()
	elif screen == Phase.DECISION:
		if resolve_button_rect.has_point(pos):
			confirm_decision()
			return
		if selected_card_index >= 0 and selected_card_rect.has_point(pos):
			play_card(selected_card_index)
			return
		for i in range(hand_rects.size()):
			if hand_rects[i].has_point(pos):
				if selected_card_pinned and selected_card_index == i:
					play_card(i)
				else:
					selected_card_index = i
					selected_card_pinned = true
					play_sfx("pickup", 1.08)
				return
		clear_card_selection()
	elif screen == Phase.RESULT:
		start_run()


func _update_card_selection():
	if screen != Phase.DECISION:
		return
	if selected_card_index >= hand.size():
		clear_card_selection()
		return
	if selected_card_pinned:
		return
	var mouse = get_local_mouse_position()
	for i in range(hand_rects.size()):
		if hand_rects[i].has_point(mouse):
			selected_card_index = i
			return
	selected_card_index = -1


func clear_card_selection():
	selected_card_index = -1
	selected_card_pinned = false
	selected_card_rect = Rect2()


func start_run():
	deck = INITIAL_DECK.duplicate()
	draw_pile = deck.duplicate()
	draw_pile.shuffle()
	discard_pile.clear()
	hand.clear()
	committed_cards.clear()
	resolve_effects.clear()
	segment_index = 0
	energy = DECISION_ENERGY
	kuro_stamina = 100.0
	gap_seconds = 2.6
	rival_distance = 26.0
	rival_stamina = 100.0
	rival_pace = 1.0
	distance = 0.0
	speed = 36.0
	daigo_uses = 0
	naruse_used = false
	leadout_used = false
	leadout_ready = false
	dropped = false
	won = false
	combo = 0
	best_combo = 0
	score = 0
	fatigue_count = 0
	result_title = ""
	result_body = ""
	result_detail = ""
	resolve_summary = ""
	particles.clear()
	update_road_from_segment()
	intro_timer = 1.0
	show_message(t("intro_body"), 1.4)
	set_phase(Phase.STAGE_INTRO)


func begin_decision():
	if segment_index >= SEGMENTS.size():
		resolve_finish()
		return
	energy = DECISION_ENERGY
	committed_cards.clear()
	resolve_effects.clear()
	resolve_summary = ""
	update_road_from_segment()
	draw_to_hand()
	ensure_showcase_card()
	var seg = current_segment()
	var warning = segment_warning(seg)
	if warning != "":
		show_message(warning, 2.6)
	else:
		show_message(segment_brief(seg), 2.2)
	set_phase(Phase.DECISION)


func draw_to_hand():
	while hand.size() < MAX_HAND:
		if draw_pile.is_empty():
			if discard_pile.is_empty():
				return
			draw_pile = discard_pile.duplicate()
			discard_pile.clear()
			draw_pile.shuffle()
		hand.append(draw_pile.pop_back())


func ensure_showcase_card():
	if segment_index == SEGMENTS.size() - 2 and not leadout_used:
		pull_card_into_hand("leadout")
	elif segment_index == SEGMENTS.size() - 1:
		pull_card_into_hand("sprint")


func pull_card_into_hand(card_id):
	if hand.has(card_id):
		return
	if not remove_card_from_pile(draw_pile, card_id):
		if not remove_card_from_pile(discard_pile, card_id):
			return
	if hand.size() >= MAX_HAND:
		var replace_index = hand.find("fatigue")
		if replace_index < 0:
			replace_index = hand.find("draft")
		if replace_index < 0:
			replace_index = hand.size() - 1
		discard_pile.append(hand[replace_index])
		hand[replace_index] = card_id
	else:
		hand.append(card_id)


func remove_card_from_pile(pile, card_id):
	var index = pile.find(card_id)
	if index < 0:
		return false
	pile.remove_at(index)
	return true


func play_card(index):
	if screen != Phase.DECISION:
		return false
	if index < 0 or index >= hand.size():
		return false
	var id = hand[index]
	var fail = card_condition_failed(id)
	if fail != "":
		show_message(fail, 1.2)
		add_text_particle(fail, Vector2(get_viewport_rect().size.x * 0.5 - 70, get_viewport_rect().size.y - 240), Color(1.0, 0.55, 0.38))
		_make_hitstop(0.08, 4.0)
		play_sfx("near_miss", 0.86)
		return false
	energy -= card_cost(id)
	committed_cards.append(id)
	hand.remove_at(index)
	discard_pile.append(id)
	if id == "daigo_pull":
		daigo_uses += 1
	elif id == "naruse_attack":
		naruse_used = true
	elif id == "leadout":
		leadout_used = true
	show_message(card_name(id), 1.0)
	add_text_particle(card_name(id), Vector2(get_viewport_rect().size.x * 0.5 - 70, get_viewport_rect().size.y - 230), CARD_LIBRARY[id]["color"])
	play_sfx("card", 1.0 + float(committed_cards.size()) * 0.04)
	clear_card_selection()
	return true


func confirm_decision():
	if screen != Phase.DECISION:
		return
	for id in hand:
		discard_pile.append(id)
	hand.clear()
	set_phase(Phase.FINISH if bool(current_segment().get("finish", false)) else Phase.RESOLVE)
	begin_resolve()


func begin_resolve():
	var seg = current_segment()
	update_road_from_segment()
	resolve_duration = float(seg["duration"])
	resolve_timer = 0.0
	resolve_start_gap = gap_seconds
	resolve_target_gap = gap_seconds
	resolve_start_stamina = kuro_stamina
	resolve_target_stamina = kuro_stamina
	resolve_start_distance = distance
	resolve_effects.clear()
	for id in committed_cards:
		resolve_effects[id] = true

	var terrain = str(seg["terrain"])
	var gap_delta = 0.22
	var stamina_delta = -1.6
	var speed_bonus = 0.0
	var fatigue_to_add = 0
	var quality = 0
	var reset_combo = false
	var notes = []
	var leadout_bonus_available = leadout_ready
	var set_leadout_ready = false
	var consumed_leadout = false

	if committed_cards.is_empty():
		gap_delta += 0.46
		stamina_delta += 1.8
		notes.append(t("note_coast"))
		if gap_seconds > 2.8:
			reset_combo = true

	if terrain == "crosswind":
		gap_delta += 0.48
		stamina_delta -= 3.4
		if not has_committed("draft") and not has_committed("daigo_pull"):
			gap_delta += 0.55
			stamina_delta -= 2.8
			notes.append(t("note_crosswind_hit"))
			if not has_committed("tempo") and not has_committed("chase"):
				reset_combo = true
		else:
			gap_delta -= 0.52
			stamina_delta += 3.6
			quality += 1
			notes.append(t("note_crosswind_safe"))
	elif terrain == "climb":
		gap_delta += 0.62
		stamina_delta -= 5.4
		speed_bonus -= 6.0
	elif terrain == "descent":
		gap_delta -= 0.12
		stamina_delta -= 0.8
		speed_bonus += 8.0

	for id in committed_cards:
		if id == "draft":
			gap_delta -= 0.25
			stamina_delta += 5.2
			speed_bonus -= 0.8
			quality += 1 if terrain == "crosswind" or terrain == "flat" else 0
			notes.append(t("note_draft"))
		elif id == "tempo":
			gap_delta -= 0.62
			stamina_delta -= 4.2
			speed_bonus += 2.7
			quality += 1
			notes.append(t("note_tempo"))
		elif id == "chase":
			gap_delta -= 1.35
			stamina_delta -= 12.5
			speed_bonus += 5.5
			fatigue_to_add += 1
			quality += 1
			notes.append(t("note_chase"))
		elif id == "dance":
			gap_delta -= 1.28
			stamina_delta -= 8.2
			speed_bonus += 2.2
			quality += 2
			notes.append(t("note_dance"))
		elif id == "daigo_pull":
			gap_delta -= 0.36
			stamina_delta += 8.6
			speed_bonus += 0.8
			quality += 1
			notes.append(t("note_daigo"))
		elif id == "naruse_attack":
			gap_delta -= 0.82
			stamina_delta -= 2.0
			rival_stamina = clamp(rival_stamina - 14.0, 0.0, 100.0)
			speed_bonus += 1.2
			quality += 2
			notes.append(t("note_naruse"))
		elif id == "leadout":
			gap_delta -= 0.52
			stamina_delta -= 3.0
			speed_bonus += 4.0
			set_leadout_ready = true
			quality += 2
			notes.append(t("note_leadout"))
		elif id == "sprint":
			stamina_delta -= 38.0
			if leadout_bonus_available:
				gap_delta -= 3.85
				speed_bonus += 18.0
				quality += 5
				consumed_leadout = true
				notes.append(t("note_leadout_sprint"))
				_make_hitstop(0.18, 14.0)
			else:
				gap_delta -= 2.12
				speed_bonus += 12.0
				quality += 3
				notes.append(t("note_sprint"))
			pulse_timer = max(pulse_timer, 1.0)
			flow_timer = max(flow_timer, resolve_duration + 0.5)
			play_sfx("stage_clear", 1.05)

	if str(seg["event"]) == "rival_attack":
		if has_committed("naruse_attack") or has_committed("chase") or has_committed("daigo_pull"):
			gap_delta -= 0.42
			quality += 2
			notes.append(t("note_attack_counter"))
			flash_timer = max(flash_timer, 0.12)
			play_sfx("near_miss", 1.16)
		else:
			gap_delta += 1.55
			stamina_delta -= 4.8
			speed_bonus += 2.4
			reset_combo = true
			notes.append(t("note_attack_hit"))
			_make_hitstop(0.13, 9.0)
			pulse_timer = max(pulse_timer, 0.75)

	if bool(seg.get("finish", false)) and not has_committed("sprint"):
		gap_delta += 0.78
		reset_combo = true
		notes.append(t("note_no_sprint"))

	var rival_cost = 2.0
	if terrain == "climb":
		rival_cost += 5.5
	if str(seg["event"]) == "rival_attack":
		rival_cost += 9.0
	if gap_delta < -1.0:
		rival_cost += 2.5
	rival_stamina = clamp(rival_stamina - rival_cost, 0.0, 100.0)

	resolve_target_gap = clamp(resolve_start_gap + gap_delta, -3.8, 7.8)
	resolve_target_stamina = clamp(resolve_start_stamina + stamina_delta, 0.0, 100.0)
	if resolve_target_stamina <= 0.1:
		dropped = true
		reset_combo = true
		resolve_target_gap = min(7.8, resolve_target_gap + 1.25)
		notes.append(t("note_dropped"))

	if set_leadout_ready:
		leadout_ready = true
	if consumed_leadout:
		leadout_ready = false

	if reset_combo:
		combo = 0
	else:
		combo += max(0, quality)
	best_combo = max(best_combo, combo)
	score += int(80 + max(0.0, -gap_delta) * 90.0 + combo * 24 + max(0.0, stamina_delta) * 4.0)

	for i in range(fatigue_to_add):
		add_fatigue()

	resolve_speed = max(22.0, float(seg["speed"]) + speed_bonus + combo * 0.35)
	if gap_delta < -0.8:
		flow_timer = max(flow_timer, resolve_duration * 0.75)
		shake_timer = max(shake_timer, 0.12)
		shake_strength = max(shake_strength, 5.0)
	resolve_summary = join_text(notes, " / ")
	show_message(resolve_summary, resolve_duration)


func _update_resolve(delta):
	resolve_timer += delta
	var p = clamp(resolve_timer / max(0.01, resolve_duration), 0.0, 1.0)
	var eased = p * p * (3.0 - 2.0 * p)
	gap_seconds = lerp(resolve_start_gap, resolve_target_gap, eased)
	kuro_stamina = lerp(resolve_start_stamina, resolve_target_stamina, eased)
	speed = lerp(speed, resolve_speed, 0.08 + p * 0.05)
	distance = resolve_start_distance + speed * resolve_timer * (0.8 + p * 0.28)
	_update_rival(delta)
	if screen == Phase.FINISH and p > 0.62:
		finish_photo_timer = max(finish_photo_timer, 0.25)
		pulse_timer = max(pulse_timer, 0.18)
	if p >= 1.0:
		finish_segment()


func finish_segment():
	gap_seconds = resolve_target_gap
	kuro_stamina = resolve_target_stamina
	if bool(current_segment().get("finish", false)):
		resolve_finish()
		return
	segment_index += 1
	begin_decision()


func resolve_finish():
	var sprinted = committed_cards.has("sprint")
	var photo_close = abs(gap_seconds) < 0.34
	won = not dropped and (gap_seconds <= 0.0 or (sprinted and gap_seconds <= 0.28 and combo >= 3))
	result_title = t("win_title") if won else t("lose_title")
	result_body = t("win_body") if won else t("lose_body")
	if dropped:
		result_detail = t("dropped")
	elif photo_close:
		result_detail = t("photo")
	elif gap_seconds <= 0.0:
		result_detail = "%s %.1fs" % [t("front"), abs(gap_seconds)]
	else:
		result_detail = "%s +%.1fs" % [t("rival"), gap_seconds]
	if won:
		score += 900 + combo * 80 + int(kuro_stamina * 3.0)
		flash_timer = max(flash_timer, 0.45)
		play_sfx("win", 1.08)
	else:
		play_sfx("crash", 0.72)
	pulse_timer = max(pulse_timer, 0.8)
	set_phase(Phase.RESULT)


func add_fatigue():
	discard_pile.append("fatigue")
	fatigue_count += 1
	add_text_particle(t("fatigue_added"), Vector2(get_viewport_rect().size.x * 0.5 + rng.randf_range(-120, 120), 270), Color(0.92, 0.95, 1.0))


func _update_rival(delta):
	var correction = clamp(-gap_seconds / 8.0, -0.18, 0.18)
	var fatigue_drag = (100.0 - rival_stamina) * 0.002
	rival_pace = clamp(1.0 + correction - fatigue_drag, 0.78, 1.18)
	rival_distance = distance + gap_seconds * 11.0 + rival_pace * delta * 2.0


func card_condition_failed(id):
	if id == "fatigue":
		return t("unplayable")
	if card_cost(id) > energy:
		return t("no_energy")
	var terrain = str(current_segment()["terrain"])
	var is_finish = bool(current_segment().get("finish", false))
	if id == "dance" and terrain != "climb":
		return t("condition_climb")
	if id == "naruse_attack":
		if naruse_used:
			return t("condition_used")
		if terrain != "climb":
			return t("condition_climb")
	if id == "sprint":
		if not is_finish:
			return t("condition_finish")
		if kuro_stamina < 30.0:
			return t("condition_stamina")
	if id == "daigo_pull" and daigo_uses >= 2:
		return t("condition_used")
	if id == "leadout":
		if leadout_used:
			return t("condition_used")
		if segment_index < SEGMENTS.size() - 2:
			return t("condition_late")
	return ""


func is_card_playable_now(id):
	return screen == Phase.DECISION and card_condition_failed(id) == ""


func card_cost(id):
	return int(CARD_LIBRARY[id]["cost"])


func has_committed(id):
	return committed_cards.has(id)


func current_segment():
	var index = int(clamp(segment_index, 0, SEGMENTS.size() - 1))
	return SEGMENTS[index]


func update_road_from_segment():
	var seg = current_segment()
	road_grade = float(seg["grade"])
	road_wind = float(seg["wind"])
	road_curve = float(seg["curve"])
	road_tilt = road_curve * 0.18


func segment_name(seg):
	return str(seg["name_ja"]) if language == "ja" else str(seg["name_en"])


func segment_brief(seg):
	return str(seg["brief_ja"]) if language == "ja" else str(seg["brief_en"])


func terrain_name(id):
	if language == "ja":
		return TERRAIN_JA.get(id, id)
	return TERRAIN_EN.get(id, id)


func segment_warning(seg):
	if str(seg["event"]) == "rival_attack":
		return t("threat_attack")
	if str(seg["event"]) == "final_km":
		return t("threat_finish")
	return ""


func card_name(id):
	if language == "ja" and CARD_JA.has(id):
		return CARD_JA[id]["name"]
	return CARD_LIBRARY[id]["name"]


func card_desc(id):
	if language == "ja" and CARD_JA.has(id):
		return CARD_JA[id]["desc"]
	return CARD_LIBRARY[id]["desc"]


func join_text(parts, separator):
	var out = ""
	for i in range(parts.size()):
		if i > 0:
			out += separator
		out += str(parts[i])
	return out


func show_message(text, duration):
	race_message = str(text)
	message_timer = duration


func _make_hitstop(duration, shake):
	hitstop_timer = max(hitstop_timer, duration)
	shake_timer = max(shake_timer, duration + 0.08)
	shake_strength = max(shake_strength, shake)


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
	if flow_timer > 0.0 and rng.randf() < 0.48:
		var size = get_viewport_rect().size
		add_spark(Vector2(size.x * 0.5 + rng.randf_range(-170, 170), size.y - rng.randf_range(170, 330)), Color(1.0, 0.86, 0.28, 0.95))


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


func _draw():
	var size = get_viewport_rect().size
	var offset = Vector2.ZERO
	if shake_timer > 0.0:
		var amp = shake_strength * clamp(shake_timer / 0.22, 0.0, 1.0)
		offset = Vector2(rng.randf_range(-amp, amp), rng.randf_range(-amp, amp))
	draw_set_transform(offset, 0.0, Vector2.ONE)
	if screen == Phase.TITLE:
		draw_title(size)
	elif screen == Phase.STAGE_INTRO:
		draw_stage_intro(size)
	elif screen == Phase.DECISION or screen == Phase.RESOLVE or screen == Phase.FINISH:
		draw_race(size)
	elif screen == Phase.RESULT:
		draw_result(size)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	if flash_timer > 0.0:
		draw_rect(Rect2(Vector2.ZERO, size), Color(1, 1, 1, min(0.44, flash_timer * 4.0)))
	draw_language_button(size)


func draw_title(size):
	draw_first_person_road(size)
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.01, 0.025, 0.035, 0.40))
	draw_speed_lines(size, 0.42)
	draw_centered("CHAINBREAK", 120, 88, Color(0.94, 1.0, 0.96))
	draw_centered(t("subtitle"), 184, 27, Color(0.55, 0.95, 1.0))
	draw_centered(t("tagline"), 240, 22, Color(0.86, 0.94, 0.92))
	start_button_rect = Rect2(size.x * 0.5 - 150, 318, 300, 64)
	draw_round_rect(start_button_rect, Color(1.0, 0.28, 0.18), Color(1.0, 0.82, 0.52), 4.0)
	draw_centered(t("start"), 360, 28, Color(0.03, 0.045, 0.05))
	draw_title_cards(size)


func draw_title_cards(size):
	var ids = ["draft", "chase", "leadout", "sprint"]
	var start_x = size.x * 0.5 - 330
	for i in range(ids.size()):
		var rect = Rect2(start_x + i * 170, 468 + sin(float(i) + distance * 0.01) * 8.0, 148, 128)
		draw_game_card(rect, ids[i], i + 1)


func draw_stage_intro(size):
	draw_first_person_road(size)
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.0, 0.0, 0.0, 0.32))
	draw_centered(t("stage_intro"), 150, 48, Color(0.94, 1.0, 0.95))
	draw_centered(t("intro_body"), 214, 23, Color(0.82, 0.94, 0.92))
	draw_centered("Kurokawa / Daigo / Naruse", 266, 18, Color(0.62, 0.95, 1.0))
	draw_speed_lines(size, 0.38)


func draw_race(size):
	draw_first_person_road(size)
	draw_riders_first_person(size)
	draw_hud(size)
	if message_timer > 0.0 and race_message != "" and screen != Phase.DECISION:
		draw_message(size)
	if screen == Phase.DECISION:
		draw_decision_panel(size)
		draw_card_hand(size)
	else:
		draw_resolve_overlay(size)
	draw_particles()
	if pulse_timer > 0.0:
		draw_rect(Rect2(Vector2.ZERO, size), Color(1.0, 0.16, 0.12, min(0.18, pulse_timer * 0.32)), false, 14)
	if finish_photo_timer > 0.0:
		draw_photo_finish(size)


func draw_result(size):
	draw_first_person_road(size)
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.01, 0.018, 0.022, 0.58))
	var title_color = Color(1.0, 0.88, 0.35) if won else Color(1.0, 0.34, 0.24)
	draw_centered(result_title, 150, 76, title_color)
	draw_centered(result_detail, 222, 30, Color(0.72, 1.0, 0.94) if won else Color(1.0, 0.72, 0.58))
	draw_centered(result_body, 286, 24, Color(0.9, 0.96, 0.94))
	draw_centered(t("score") % [score, best_combo], 350, 22, Color(0.84, 0.94, 0.95))
	draw_centered(t("deck") % [draw_pile.size(), discard_pile.size(), fatigue_count], 388, 18, Color(0.66, 0.82, 0.84))
	draw_centered(t("retry"), 472, 22, Color(0.72, 0.9, 0.92))


func draw_first_person_road(size):
	var horizon = 262.0 - clamp(road_grade, -2.0, 2.0) * 20.0
	var bend = road_curve * 142.0
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.024, 0.038, 0.06))
	if bg_texture != null:
		draw_texture_rect(bg_texture, Rect2(Vector2(0, 0), Vector2(size.x, horizon + 128)), false, Color(1, 1, 1, 0.34))
	draw_rect(Rect2(0, 0, size.x, horizon + 44), Color(0.02, 0.04, 0.07, 0.25))
	for i in range(4):
		var y = horizon - 64 + i * 24
		draw_line(Vector2(-40, y + road_tilt * 80.0), Vector2(size.x + 40, y - road_tilt * 80.0), Color(0.25, 0.5, 0.55, 0.14), 2)
	var road = PackedVector2Array([
		Vector2(size.x * 0.5 - 96 + bend * 0.24, horizon),
		Vector2(size.x * 0.5 + 96 + bend * 0.24, horizon),
		Vector2(size.x + 280 + bend, size.y + 82),
		Vector2(-280 + bend, size.y + 82)
	])
	draw_colored_polygon(road, Color(0.07, 0.085, 0.09, 0.98))
	draw_line(Vector2(size.x * 0.5 - 96 + bend * 0.24, horizon), Vector2(-280 + bend, size.y + 82), Color(0.45, 0.95, 1.0, 0.22), 4)
	draw_line(Vector2(size.x * 0.5 + 96 + bend * 0.24, horizon), Vector2(size.x + 280 + bend, size.y + 82), Color(0.45, 0.95, 1.0, 0.22), 4)
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


func draw_riders_first_person(size):
	if gap_seconds >= -0.7:
		var depth = clamp(1.0 - gap_seconds / 6.0, 0.0, 1.0)
		var y = lerp(278.0, 410.0, depth)
		var scale = lerp(0.24, 0.72, depth)
		var x = size.x * 0.5 + road_curve * 80.0 * (1.0 - depth)
		draw_simple_bike(Vector2(x, y), Color(1.0, 0.22, 0.14, 0.94), scale)
		draw_fit_text("%s +%.1fs" % [t("rival"), max(0.0, gap_seconds)], Vector2(x - 58, y - 74 * scale - 20), 140, 15, 11, Color(1.0, 0.56, 0.38))
		if str(current_segment()["event"]) == "rival_attack" and screen == Phase.DECISION:
			draw_fit_text(t("threat_attack"), Vector2(x - 62, y - 96 * scale - 30), 150, 16, 11, Color(1.0, 0.84, 0.34))
	if is_drafting_visual():
		var color = Color(0.35, 0.95, 1.0, 0.92)
		var label = card_name("draft")
		if has_committed("daigo_pull"):
			color = Color(0.35, 0.7, 1.0, 0.94)
			label = "Daigo"
		elif has_committed("leadout") or leadout_ready:
			color = Color(1.0, 0.58, 0.24, 0.95)
			label = t("leadout_ready")
		draw_arc_ribbon(Vector2(size.x * 0.5 - 20, 430), Color(color, 0.22))
		draw_simple_bike(Vector2(size.x * 0.5, 430), color, 0.78)
		draw_fit_text(label, Vector2(size.x * 0.5 - 62, 352), 140, 16, 11, Color(0.86, 1.0, 0.95))
	if gap_seconds < -0.2:
		draw_fit_text("%s %.1fs" % [t("front"), abs(gap_seconds)], Vector2(size.x * 0.5 - 56, 308), 150, 18, 12, Color(0.62, 1.0, 0.92))


func is_drafting_visual():
	return has_committed("draft") or has_committed("daigo_pull") or has_committed("leadout") or (leadout_ready and screen == Phase.DECISION)


func draw_hud(size):
	var seg = current_segment()
	draw_rect(Rect2(0, 0, size.x, 86), Color(0.01, 0.018, 0.022, 0.78))
	draw_text("CHAINBREAK", Vector2(22, 32), 22, Color(0.94, 1.0, 0.95))
	draw_text("%s %s/6" % [segment_name(seg), segment_index + 1], Vector2(22, 62), 16, Color(0.58, 0.9, 1.0))
	draw_energy_pips(Vector2(250, 27))
	draw_bar(Rect2(356, 24, 190, 16), kuro_stamina / 100.0, Color(0.22, 0.95, 0.7) if kuro_stamina > 30.0 else Color(1.0, 0.32, 0.22), "%s %s%%" % [t("stamina"), int(round(kuro_stamina))])
	var gap_text = "%s +%.1fs" % [t("rival"), gap_seconds] if gap_seconds > 0.05 else "%s %.1fs" % [t("front"), abs(gap_seconds)]
	draw_text("%s: %s" % [t("gap"), gap_text], Vector2(580, 38), 22, Color(1.0, 0.56, 0.38) if gap_seconds > 0.05 else Color(0.62, 1.0, 0.92))
	var next_name = "-"
	if segment_index + 1 < SEGMENTS.size():
		next_name = terrain_name(str(SEGMENTS[segment_index + 1]["terrain"]))
	draw_text("%s: %s  >  %s: %s" % [t("terrain"), terrain_name(str(seg["terrain"])), t("next"), next_name], Vector2(810, 30), 17, Color(0.82, 0.94, 0.9))
	draw_text("%s x%s" % [t("combo"), combo], Vector2(1068, 38), 28, Color(1.0, 0.88, 0.34) if combo >= 4 else Color(0.72, 0.95, 1.0))
	if leadout_ready:
		draw_status_chip(Rect2(846, 52, 140, 24), t("leadout_ready"), Color(1.0, 0.58, 0.24))
	if dropped:
		draw_status_chip(Rect2(996, 52, 108, 24), t("dropped"), Color(1.0, 0.22, 0.16))


func draw_energy_pips(pos):
	draw_text(t("energy"), pos + Vector2(0, 18), 16, Color(0.82, 0.94, 0.94))
	for i in range(DECISION_ENERGY):
		var center = pos + Vector2(48 + i * 28, 12)
		var fill = Color(0.28, 0.92, 1.0) if i < energy and screen == Phase.DECISION else Color(0.08, 0.14, 0.16)
		draw_circle(center, 10, fill)
		draw_arc(center, 10, 0.0, TAU, 18, Color(0.76, 1.0, 0.94, 0.82), 2.0)


func draw_status_chip(rect, label, color):
	draw_round_rect(rect, Color(0.025, 0.04, 0.045, 0.84), color, 2.0)
	draw_fit_text(label, rect.position + Vector2(8, 17), rect.size.x - 16, 13, 10, Color(0.96, 1.0, 0.95))


func draw_message(size):
	var width = min(size.x - 80.0, 800.0)
	var rect = Rect2(size.x * 0.5 - width * 0.5, 104, width, 42)
	draw_round_rect(rect, Color(0.02, 0.035, 0.04, 0.82), Color(0.48, 0.95, 1.0, 0.42), 2.0)
	draw_fit_text(race_message, rect.position + Vector2(18, 27), rect.size.x - 36, 17, 11, Color(0.9, 1.0, 0.96))


func draw_decision_panel(size):
	var seg = current_segment()
	var panel = Rect2(24, 104, 288, 104)
	draw_round_rect(panel, Color(0.02, 0.035, 0.04, 0.82), Color(0.42, 0.86, 0.92, 0.48), 2.0)
	draw_text(t("decision"), panel.position + Vector2(16, 28), 22, Color(0.94, 1.0, 0.95))
	draw_wrapped(segment_brief(seg), panel.position + Vector2(16, 55), panel.size.x - 32, 14, Color(0.72, 0.86, 0.86))
	if segment_warning(seg) != "":
		draw_status_chip(Rect2(panel.position + Vector2(16, 76), Vector2(150, 24)), segment_warning(seg), Color(1.0, 0.55, 0.24))
	resolve_button_rect = Rect2(size.x - 190, size.y - 204, 150, 52)
	draw_round_rect(resolve_button_rect, Color(1.0, 0.28, 0.18), Color(1.0, 0.86, 0.54), 4.0)
	draw_fit_text(t("resolve"), resolve_button_rect.position + Vector2(24, 33), resolve_button_rect.size.x - 48, 24, 14, Color(0.03, 0.045, 0.05))
	draw_text(t("help_decision"), Vector2(size.x - 328, size.y - 218), 14, Color(0.68, 0.86, 0.86))
	draw_committed_strip(Vector2(334, 112))


func draw_committed_strip(pos):
	draw_text(t("committed"), pos + Vector2(0, 18), 15, Color(0.72, 0.92, 0.92))
	for i in range(committed_cards.size()):
		var id = committed_cards[i]
		var rect = Rect2(pos.x + i * 118, pos.y + 28, 108, 32)
		draw_round_rect(rect, Color(0.02, 0.04, 0.045, 0.84), CARD_LIBRARY[id]["color"], 2.0)
		draw_fit_text(card_name(id), rect.position + Vector2(8, 22), rect.size.x - 16, 13, 10, Color(0.94, 1.0, 0.95))


func draw_resolve_overlay(size):
	var rect = Rect2(34, size.y - 132, size.x - 68, 74)
	draw_round_rect(rect, Color(0.015, 0.026, 0.03, 0.82), Color(0.42, 0.95, 1.0, 0.34), 2.0)
	var title = t("finish_phase") if screen == Phase.FINISH else t("resolving")
	draw_text(title, rect.position + Vector2(18, 29), 24, Color(1.0, 0.86, 0.35) if screen == Phase.FINISH else Color(0.88, 1.0, 0.95))
	draw_fit_text(resolve_summary, rect.position + Vector2(210, 28), rect.size.x - 240, 18, 11, Color(0.78, 0.92, 0.9))
	var bar = Rect2(rect.position + Vector2(18, 48), Vector2(rect.size.x - 36, 8))
	draw_rect(bar, Color(0.0, 0.0, 0.0, 0.48))
	draw_rect(Rect2(bar.position, Vector2(bar.size.x * clamp(resolve_timer / max(0.1, resolve_duration), 0.0, 1.0), bar.size.y)), Color(1.0, 0.64, 0.26) if screen == Phase.FINISH else Color(0.38, 1.0, 0.9))


func draw_card_hand(size):
	hand_rects.clear()
	draw_text(t("cards"), Vector2(38, size.y - 180), 16, Color(0.72, 0.92, 0.92))
	var card_w = min(166.0, (size.x - 108.0) / 5.0 - 10.0)
	var card_h = 156.0
	var total_w = hand.size() * card_w + max(0, hand.size() - 1) * 10.0
	var x = size.x * 0.5 - total_w * 0.5
	var y = size.y - card_h - 14.0
	var active = selected_card_index if selected_card_index >= 0 and selected_card_index < hand.size() else -1
	for i in range(hand.size()):
		var rect = Rect2(x + i * (card_w + 10.0), y, card_w, card_h)
		hand_rects.append(rect)
		if i != active:
			draw_game_card(rect, hand[i], i + 1)
	if active >= 0:
		var base = hand_rects[active]
		var preview_size = Vector2(238, 252)
		var preview_x = clamp(base.position.x + base.size.x * 0.5 - preview_size.x * 0.5, 18.0, size.x - preview_size.x - 18.0)
		var preview_y = max(128.0, size.y - 444.0)
		selected_card_rect = Rect2(Vector2(preview_x, preview_y), preview_size)
		var glow_rect = Rect2(selected_card_rect.position - Vector2(9, 9), selected_card_rect.size + Vector2(18, 18))
		draw_rect(glow_rect, Color(0.25, 0.95, 1.0, 0.13))
		draw_rect(glow_rect, Color(0.62, 1.0, 0.92, 0.76), false, 4)
		draw_game_card(selected_card_rect, hand[active], active + 1, true)
	else:
		selected_card_rect = Rect2()


func draw_game_card(rect, id, number, large := false):
	var card = CARD_LIBRARY[id]
	var playable = is_card_playable_now(id)
	var fill = Color(0.035, 0.05, 0.06, 0.96)
	draw_round_rect(rect, fill, card["color"], 4.0)
	var art_height = 88 if large else 44
	var title_y = 123 if large else 74
	var cost_y = 153 if large else 96
	var desc_y = 181 if large else 110
	var number_size = 24 if large else 18
	var title_size = 22 if large else 17
	var cost_size = 17 if large else 15
	var desc_size = 16 if large else 12
	if card_texture != null:
		draw_texture_rect(card_texture, Rect2(rect.position + Vector2(10, 10), Vector2(rect.size.x - 20, art_height)), false, Color(1, 1, 1, 0.44 if large else 0.38))
	draw_rect(Rect2(rect.position + Vector2(10, 10), Vector2(rect.size.x - 20, art_height)), Color(card["color"], 0.16))
	draw_text(str(number), rect.position + Vector2(14, 36 if large else 31), number_size, Color(0.04, 0.05, 0.06))
	draw_fit_text(card_name(id), rect.position + Vector2(16, title_y), rect.size.x - 32, title_size, 12, Color(0.95, 1.0, 0.95))
	var cost_label = "X" if card_cost(id) < 0 else "%s %s" % [t("energy_short"), card_cost(id)]
	draw_text(cost_label, rect.position + Vector2(16, cost_y), cost_size, Color(1.0, 0.84, 0.44))
	draw_fit_text(str(card["tag"]), rect.position + Vector2(rect.size.x - 82, cost_y), 66, cost_size - 2, 10, Color(0.66, 0.92, 0.92))
	draw_wrapped(card_desc(id), rect.position + Vector2(16, desc_y), rect.size.x - 28, desc_size, Color(0.78, 0.87, 0.86))
	if screen == Phase.DECISION and not playable:
		draw_rect(rect, Color(0.0, 0.0, 0.0, 0.42))
		var fail = card_condition_failed(id)
		if large and fail != "":
			draw_fit_text(fail, rect.position + Vector2(18, rect.size.y - 20), rect.size.x - 36, 13, 10, Color(1.0, 0.72, 0.56))


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


func draw_photo_finish(size):
	var alpha = clamp(finish_photo_timer * 4.0, 0.0, 1.0)
	draw_line(Vector2(size.x * 0.5, 108), Vector2(size.x * 0.5, size.y - 118), Color(1.0, 1.0, 1.0, 0.35 * alpha), 5)
	draw_centered(t("photo"), 182, 34, Color(1.0, 0.9, 0.42, 0.78 * alpha))


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
	var finish_boost = 0.25 if screen == Phase.FINISH else 0.0
	var flow_boost = 0.3 if flow_timer > 0.0 else 0.0
	return clamp((speed - 28.0) / 30.0 + min(0.34, combo * 0.018) + finish_boost + flow_boost, 0.0, 1.45)


func draw_speed_lines(size, amount):
	var count = 18 + int(amount * 18.0)
	for i in range(count):
		var y = 116 + i * 21 + fmod(distance * (0.8 + amount * 2.5), 33.0)
		var x = fmod(distance * (18.0 + amount * 34.0) + i * 87.0, size.x + 320.0) - 220.0
		var length = 100 + amount * 420
		draw_line(Vector2(x, y), Vector2(x + length, y + rng.randf_range(-8, 8)), Color(0.65, 0.95, 1.0, 0.07 + amount * 0.2), 2 + amount * 3.5)


func draw_bar(rect, value, color, label):
	draw_round_rect(rect, Color(0.0, 0.0, 0.0, 0.45), Color(0.35, 0.45, 0.46, 0.55), 2)
	var fill = Rect2(rect.position, Vector2(rect.size.x * clamp(value, 0.0, 1.0), rect.size.y))
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
	var font_size = max_size
	while font_size > min_size and font.get_string_size(str(text), HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x > width:
		font_size -= 1
	font.draw_string(get_canvas_item(), pos, str(text), HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, color)


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


func draw_language_button(size):
	var y = 96 if screen == Phase.DECISION or screen == Phase.RESOLVE or screen == Phase.FINISH else 12
	language_button_rect = Rect2(size.x - 132, y, 110, 34)
	draw_rect(language_button_rect, Color(0.02, 0.04, 0.05, 0.78))
	draw_rect(language_button_rect, Color(0.55, 0.95, 1.0, 0.72), false, 3)
	draw_text(t("lang_button"), language_button_rect.position + Vector2(37, 23), 15, Color(0.86, 1.0, 0.95))
