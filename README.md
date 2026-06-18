# Chainbreak: Roguelite Cycling

Godot 4.6.2で作成した、自転車レースを主題にした2Dデッキ型ローグライトです。

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

- `Enter` / `Space`: スタート、ジャンプ
- `W/S` または `↑/↓`: ライン変更
- `1`-`5`: 手札カードを使用
- マウスクリック: カード、報酬、タイトルボタンを選択
- `L` / 右上ボタン: 日本語/英語を切り替え
- `R`: ゲームオーバー/クリア後にリスタート
- `Esc`: タイトルへ戻る

## 内容

- 6ステージ構成の30分前後を想定した1ラン完結型
- カード報酬とパーツ報酬で毎ステージ後にビルド更新
- ジャンプ、ライン変更、ドラフティング、補給、ギア選択をカード化
- ニアミス、ジャスト突破、カードコンボ時にヒットストップ、画面揺れ、フラッシュ、スピードラインを発生
- 画像・音素材は無料かつローカル生成。外部の有料素材や従量課金素材は未使用

設計段階の複数案は [docs/design_options.md](/Users/ryoga/Documents/ShakarikiSports2/docs/design_options.md) に残しています。
