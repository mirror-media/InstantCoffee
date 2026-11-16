# InstantCoffee 首頁嵌入內容與 QA 設定

這次將鏡新聞首頁嵌入內容功能移植到 InstantCoffee，沿用一般首頁與 Premium 首頁既有的 iframe 位置，在原有選舉元件（若啟用）之後、編輯精選之前。保留 InstantCoffee 的主色、標題與「查看完整內容」按鈕樣式。

## 獨立上線分支（2026-11-04）

本次功能已拆到 `codex/homepage-iframe`，以 `origin/master` 的 `9350480` 為基底，包含既有的行動版依賴修正與 iOS WebView 版本固定。此分支保留首頁、會員與 onboarding 原有的 Bloc 架構，不包含 `codex/getx-refactor` 的 30 個重構 commit，也不包含 GetX UI 報告、截圖及擷取程式。

只移植首頁嵌入內容、對應的兩個首頁串接、debug 預覽與六個測試檔。Debug 預覽略過 onboarding 的相同行為移至既有 `OnBoardingBloc`，不引入重構版的 onboarding controller。

## 新版與舊版隔離

新版只讀取六個 `homepageEmbed` 參數，不從舊四個參數補值。保留 Firebase 的舊欄位及其現值，讓舊版 App 繼續使用。未設定新欄位時，新版 iframe 隱藏。

這次程式修改須先安裝新 App 包。安裝後，調整開關、網址、標題、連結及時間不需要再次出包。這份修改沒有新增或發布線上 Firebase 設定。

| App 環境 | Firebase 專案 | Android package／iOS Bundle ID |
| --- | --- | --- |
| dev | `mirrormediaapptest` | `com.mirrormedia.news.dev` |
| prod | `mirror-weekly` | `com.mirrormedia.news` |

這是 InstantCoffee 自己的 Firebase 專案，與鏡新聞分開。QA 優先使用 dev；若在 prod 測試，要讓六個新欄位都套用適當的測試條件。新參數名稱可隔離舊版 App，但不會自動隔離同一 Firebase 專案的一般新版使用者。

## Firebase 欄位

建議放入既有 iframe 群組，名稱區分大小寫。

| 新版參數 | 型別 | 首次 QA 填值 | 原有欄位（保留） |
| --- | --- | --- | --- |
| `homepageEmbedEnabled` | Boolean | `true` | `isTopIframeShow` |
| `homepageEmbedUrl` | String | `https://dev.mnews.tw/projects/election2026-homepage/index.html` | `topIframeUrl` |
| `homepageEmbedTitle` | String | 清空 | `iframeTitle` |
| `homepageEmbedShowMoreUrl` | String | 清空 | `iframeShowMoreUrl` |
| `homepageEmbedStartAt` | String | 清空 | 新增排程欄位 |
| `homepageEmbedEndAt` | String | 清空 | 新增排程欄位 |

未配置時，開關預設 `false`，其餘為空字串。空字串表示真的清空，不是填入 `null` 或 `""`。App 不會自行填入選舉網址。標題留空不顯示標題；外連留空不顯示「查看完整內容」。

一般 QA 請使用普通 dev 啟動設定，不要使用 `Run dev (election iframe preview)` 或 `TOP_IFRAME_PREVIEW_*` 編譯參數。原有 debug 預覽入口保留：只有 debug 且明確提供 `TOP_IFRAME_PREVIEW_URL` 時才強制顯示指定網址，忽略 Firebase 開關及排程；預覽標題／連結未指定時為空。Release/profile 不啟用這個預覽覆寫。

## 手動與排程上下架

顯示必須同時滿足：總開關為 `true`、網址非空、目前在有效排程區間內。

- `homepageEmbedEnabled=false`：一律隱藏，時間到也不會自動打開總開關。
- `homepageEmbedEnabled=true`，兩個時間皆空：立即顯示，可純手動上下架。
- 只填開始：該時間起顯示，沒有結束限制。
- 只填結束：結束前顯示，到點隱藏。
- 同時填入：開始時間包含在區間，結束時間不包含。
- 無效的非空時間，或結束早於／等於開始：隱藏並取消排程。修改並發布有效設定後重新判斷。

時間須包含完整日期、時分秒與時區，例如 `2026-11-01T09:00:00+08:00`；等同 `2026-11-01T01:00:00Z`。不接受沒有時區的字串、純日期、Unix timestamp 或不存在的日期。

排程依使用者裝置時鐘判斷，建議測試裝置開啟自動日期與時間。若需臨時強制上架，將總開關設 `true` 並清空兩個時間；強制下架只需設 `false`。沒有額外的強制開關或排程開關。

## 何時生效

1. controller 建立時先依已啟用設定判斷，再抓取 Firebase。
2. 監聽六個新欄位的即時更新，取得後啟用並重新判斷；每分鐘也重新檢查及抓取。
3. 取得排程後安排本地計時器，到開始／結束邊界重新判斷；更動時間後取消舊計時器並重排。
4. App 回前景時先重算已啟用排程，再嘗試抓取新值。首頁下拉更新也會套用啟用後的設定。
5. 離線時仍按已啟用的排程判斷，但不會收到新設定；網頁本身仍需能載入或有快取。

Firebase 必須發布變更，儲存草稿不會生效。傳遞仍受網路、Firebase 節流與系統排程影響，不保證發布後立即或 60 秒內生效；背景暫停也不保證整秒執行。

每分鐘更新設定不再強制重新載入網頁，以免清除使用者已選縣市。更換網址會重建 WebView；只改標題、外連或時間不會重載相同網址。若網站在相同網址更新內容，可重新開啟 App 驗證。載入失敗可按「重試」。

## 版型與操作驗收

網頁內容依實際寬高量測並水平置中，不強制 330 × 320，也不沿用原本 500px 的高度上限。選舉測試頁參考寬 320、高約 330 CSS px，實際高度依資料及網頁變動。iframe／外連下方與下一元件保持 16 Flutter 邏輯 px；隱藏時整段間距一併收起。不需要在 Firebase 加寬高欄位。

請分別在一般首頁、Premium 首頁及 iOS／Android 驗證：

| 案例 | 操作與預期 |
| --- | --- |
| 初次顯示 | 使用上述 QA 值發布，普通 dev 包載入指定頁面，置中且下方間距 16px |
| 手動下架／再上架 | 開關改 `false` 整段收起；改回 `true` 且未限時間時顯示 |
| 可選內容 | 填入標題／外連後顯示原有控制，清空後消失，外連可開啟外部瀏覽器 |
| 舊版隔離 | 只變更新參數；舊 App 繼續讀原來四個欄位，不受新參數影響 |
| 時間邊界 | 依裝置時間設定數分鐘後開始、再數分鐘後結束；確認包含開始、不包含結束 |
| 臨時改期 | 未開始時改為目前有效區間，或延後結束，取得後套用新時間，舊計時器取消 |
| 保險下架 | 有效排程內將開關設 `false`，取得設定後一律隱藏 |
| 無效時間 | 無時區、錯誤日期、結束小於／等於開始時隱藏；修正後恢復 |
| 背景／離線 | 先取得排程再離線跨過邊界；在背景跨過結束後回前景，正確收起 |
| 選單關閉 | 從卡片往上拖，首頁正常捲動 |
| 選單開啟 | 從縣市選單內上下拖，選項能捲動，首頁不跟著移動 |
| 選單邊界 | 捲到頂／底繼續拖，首頁不被帶動；從 WebView 外開始拖仍可捲首頁 |
| 選取後恢復 | 點選後方縣市，選單關閉且資料更新，再拖卡片能捲首頁 |
| 重建與錯誤 | 重新載入、換網址、載入失敗及下架再上架，不沿用舊文件的選單狀態 |
| 多個版位實例 | 一般／Premium 切換、重建或移除其中一個版位，不影響另一個 controller |

單元／Widget 測試可驗證尺寸、間距、獨立參數、排程、文件隔離及 Flutter 手勢分配。InstantCoffee 的實際原生 HTML 觸控仍須上述裝置驗收；鏡新聞的裝置驗證結果不等於此 App 已驗收。

## 獨立分支驗證紀錄（2026-11-04）

- 對六個 iframe 測試檔執行 `flutter test --no-pub --concurrency=2 --reporter expanded`：**61／61 通過**，涵蓋尺寸、間距、controller、排程、參數隔離與手勢案例。這是本次獨立分支的結果，不包含 GetX 重構分支的測試。
- 對本次修改的 Bloc、controller、helper、Widget、兩個首頁及對應測試執行 `dart analyze`：**沒有 error 或 warning**；兩個既有首頁共五項 info（公開 API 使用私有 State 型別、建構子缺少 key、空 catch），皆是 master 原有寫法。
- 核心 iframe 檔案及六個測試共 11 檔執行 `dart format --output=none --set-exit-if-changed`：通過，無格式更動；`git diff --check` 通過。
- `flutter build bundle --debug --target lib/main_dev.dart --no-pub`：**通過**，驗證獨立分支與原 Bloc App 的 Dart 編譯整合。使用既有本機忽略設定檔，未提交設定檔或建置產物。
- 未進行 InstantCoffee iOS／Android 原生觸控驗收，未產出新的 APK／AAB 或發布 App。
- 未修改 Firebase 線上設定；安裝新包及配置新參數後，仍須依上列裝置案例驗收。
