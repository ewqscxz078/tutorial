ref ChatGPT

文字化的圖形描述語言（DSL）
	ex: Mermaid / PlantUML
	把圖用純文字描述，成為版本可控、可重複生成的中介格式／原始來源，再由工具在 CI 內自動轉成 SVG/PNG/PDF，
	嵌到最後的交付文件（HTML/PDF）


它們是什麼
	PlantUML：以 @startuml … @enduml 的 DSL 描述各式 UML（序列圖、類別圖、活動圖、C4 等）。離線渲染常用 PlantUML 引擎 + Graphviz。
	Mermaid：以如 sequenceDiagram、flowchart 的 DSL 描述圖形。很多文件系統（GitHub、MkDocs Material、Docusaurus）瀏覽器端就能渲染，或用 CLI 離線轉圖。

為什麼拿它們當「中間格式」
	* 可版控與差異比對：純文字很好做 code review、diff。
	* 可自動化：CI 用 CLI/插件，把 .puml／.mmd 批次轉出 SVG/PNG。
	* 易串工具輸出：像 AppMap、Structurizr、（或你自寫轉換器把 OTel/Zipkin/Jaeger 的 trace）都能輸出成 Mermaid/PlantUML。

常見文件鏈結整法
	* Asciidoctor（Maven/Gradle）：
		* PlantUML：asciidoctor-maven-plugin + plantuml 外掛 → 直接把 docs/diagrams/*.puml 轉成圖並引用。
		* Mermaid：可用 Mermaid CLI 先轉圖，或用支援 Mermaid 的擴充。
	* MkDocs（Material 主題）：Mermaid 內建支援，直接在 Markdown 用 ```mermaid 區塊；PlantUML 可先離線轉圖再引用。

簡短範例
	Mermaid 序列圖： ref https://ikalas.com/app/mermaid-live-editor
						https://www.min87.com/tools/mermaid/index_zh-TW.html
		sequenceDiagram
		  participant C as Controller
		  participant S as OrderService
		  participant P as PaymentClient
		  C->>S: create()
		  S->>P: POST /charge
		  P-->>S: 200 OK
		  S-->>C: done

	PlantUML 序列圖：
		@startuml
		actor User
		User -> Web: GET /orders
		Web -> API: create()
		API -> DB: insert order
		DB --> API: ok
		API --> Web: 201 Created
		@enduml

	CI 轉圖（示意）：
		# PlantUML -> SVG
		plantuml -tsvg docs/diagrams/**/*.puml

		# Mermaid -> SVG
		mmdc -i docs/diagrams/flow.mmd -o target/diagrams/flow.svg

	常見「誰→輸出→怎麼嵌」

		* AppMap：錄到 *.appmap.json → UI/工具匯出 Mermaid/PlantUML → 放到 docs/diagrams/ → CI 轉 SVG。

		* OpenTelemetry/Zipkin/Jaeger：抓到 trace JSON → 小工具轉 Mermaid/PlantUML → 同上。

		* Structurizr DSL：structurizr-cli export → PlantUML/Mermaid → 同上。

		* jdeps / 自動分析：把依賴關係輸出，轉成 PlantUML 關係線 → 同上。

Mermaid vs PlantUML 小比較
	| 面向   | Mermaid                  | PlantUML                       |
	| ---- | ------------------------ | ------------------------------ |
	| 渲染   | 網頁端普及、MkDocs/GitHub 直接支援 | 離線穩定，型態更豐富（UML/C4）             |
	| 依賴   | 瀏覽器或 CLI                 | 需要 Java、PlantUML、常見還需 Graphviz |
	| 社群素材 | 流程圖/序列圖範例多               | UML 家族完整、C4 模板成熟               |
	| 建議   | 文件站（MkDocs/GitHub）優先     | UML/C4 或離線產 PDF 優先             |

結論：
	把 Mermaid/PlantUML 當作**「圖的原始碼」**來維護，
	所有自動化工具（AppMap、OTel trace 轉換器、Structurizr）輸出這種文字格式，
	CI 再統一渲染成圖片嵌入文件。這樣圖能隨程式與測試自動更新，也能在 PR 裡審閱差異。