# Chainbreak: Roguelite Cycling

Godot 4.6.2で作成した、自転車ロードレースを主題にした一人称デッキ型ローグライトMVPです。

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

- `Enter` / `Space`: スタート、区間解決、リトライ
- `1`-`5`: 手札カードを使用
- カード: ホバー/1回タップで拡大、クリック/2回タップで使用
- `L` / 右上ボタン: 日本語/英語を切り替え
- `R`: 結果画面で再走
- `Esc`: タイトルへ戻る

## 内容

- 1ステージ6区間の縦スライス
- 「判断で停止 -> カードを複数プレイ -> 区間をリアルタイム解決」のハイブリッド進行
- 主役はスプリンター黒川固定。黒川の脚、手札、疲労がレースの主資源
- 大吾と鳴瀬は個別管理せず、切り札カードとして登場
- 横風、登りアタック、下り、最終1kmでカード判断が変化
- `リードアウト列車` -> `黒川スプリント` が最大火力
- 判断成功でコンボ、速度線、揺れ、フラッシュ、フォトフィニッシュ演出が強化
- 画像・音素材は無料かつローカル生成。外部の有料素材や従量課金素材は未使用
- 日本語表示用フォントは Google Fonts の M PLUS 1p Regular（SIL Open Font License）を同梱

設計段階の複数案は [docs/design_options.md](/Users/ryoga/Documents/ShakarikiSports2/docs/design_options.md) に残しています。
