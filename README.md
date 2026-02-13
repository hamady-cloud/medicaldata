# 医療需給可視化マップ（都道府県別）

都道府県別に **高齢化率** と **医療供給（医師数・病院数・病床数など）** の関係を、年次で俯瞰するための可視化プロトタイプです。

**Demo:** https://hamady-cloud.github.io/medicaldata/

> 目的：医療資源（供給）と高齢化（需要の代理指標）のギャップ感を、都道府県×年次で素早く眺められるようにする

---

## できること（Features）
- 年度切替（例：2014 / 2016 / 2018 / 2020 / 2022 / 2024）
- 指標切替（医師数、病院数、病床数（全体/精神/療養/一般））
- 都道府県フィルタ
- データ一覧表示（テーブル）

---

## 指標定義（Definitions）
- 高齢化率：`agingRate = elderlyPop / totalPop * 100`
- 医療供給（いずれも **実数** / 都道府県合計）
  - `doctors`：医師数
  - `hospitals`：病院数
  - `beds`：病床数（全体）
  - `bedsPsych`：病床数（精神）
  - `bedsCare`：病床数（療養）
  - `bedsGeneral`：病床数（一般）

> TODO（拡張案）：人口10万人あたり等に正規化した指標も追加する

---

## データ（Data）
### 形式
年次ごとに `YYYY.csv` を配置し、フロントで扱いやすいように `data.js` に変換して利用しています。

CSVの想定カラム：
`Code, Area, TotalPop, ElderlyPop, Doctors, Hospitals, Beds, BedsPsych, BedsCare, BedsGeneral`

### 出典
- [TODO] e-Stat：医師・歯科医師・薬剤師統計、住民基本台帳
---

## 使い方（How to use）
1. Demo を開く： https://hamady-cloud.github.io/medicaldata/
2. 年度・指標・都道府県を切り替えて確認

---

## 開発・更新（Development）
### データ更新（CSV → data.js）
1. `YYYY.csv` を追加/更新（例：`2024.csv`）
2. `convert_data.ps1` を実行して `data.js` を再生成
3. `data.js` をコミットして GitHub Pages を更新

