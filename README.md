# Chainbreak: Roguelite Cycling

Godot 4.6.2で作成した、自転車レースを主題にした一人称チーム管理デッキ型ローグライトです。

## 起動

```bash
godot --path /Users/ryoga/Documents/ShakarikiSports2
```

## スマホブラウザで遊ぶ

GitHub Pages公開後は以下のURLで確認できます。

https://ryogaaaaaaaaaaa.github.io/ShakarikiSports/play/

Web版をローカルで再生成する場合:

```bash
mkdir -p docs/play
godot --headless --path /Users/ryoga/Documents/ShakarikiSports2 --export-release Web docs/play/index.html
```

## 操作

- `Enter`: スタート
- `Space`: 先頭交代
- `W/S` または `↑/↓`: ケイデンス調整
- `1`-`5`: 指示カードを使用
- カード: ホバー/1回タップで拡大、クリック/2回タップで使用
- マウスクリック: チームメンバー、報酬、タイトルボタンを選択
- `L` / 右上ボタン: 日本語/英語を切り替え
- `R`: ゲームオーバー/クリア後にリスタート
- `Esc`: タイトルへ戻る

## 内容

- 6ステージ構成の30分前後を想定した1ラン完結型
- 牽引役、クライマー、スプリンターの3人チームで走る一人称グループライド
- 先頭交代、ケイデンス、風よけ、エシュロン、リードアウトなどを数秒間の指示カード化
- ステージごとに勾配、カーブ、風向きが変化し、陣形と脚の残し方が重要
- SHIMANAGIコンポーネントと架空フレームメーカーのパーツ報酬でビルド更新
- 指示カード、コーナー処理、全開指示時にヒットストップ、画面揺れ、フラッシュ、スピードラインを発生
- 画像・音素材は無料かつローカル生成。外部の有料素材や従量課金素材は未使用
- 日本語表示用フォントは Google Fonts の M PLUS 1p Regular（SIL Open Font License）を同梱

設計段階の複数案は [docs/design_options.md](/Users/ryoga/Documents/ShakarikiSports2/docs/design_options.md) に残しています。
