---
argument-hint: [message]
description: Requirements definition command(要件定義コマンド)
---

<purpose>
Conduct detailed requirements definition before implementation, clarifying technical constraints, design policies, and specifications.(実装前に詳細な要件定義を行い、技術的制約、設計方針、仕様を明確にする。)
</purpose>

<refs>
  <skill use="patterns">core-patterns</skill>
  <skill use="workflow">requirements-definition</skill>
  <skill use="workflow">fact-check</skill>
  <skill use="tools">serena-usage</skill>
  <skill use="tools">context7-usage</skill>
  <skill use="workflow">define-core</skill>
</refs>

<rules priority="critical">
  <rule>Never modify, create, or delete files(ファイルの変更、作成、削除を絶対に行わないこと)</rule>
  <rule>Never implement code; requirements definition only(コードを実装せず、要件定義のみを行うこと)</rule>
  <rule>Clearly identify technically impossible requests(技術的に不可能な要求を明確に特定すること)</rule>
  <rule>Prioritize technical validity over user preferences(ユーザーの好みよりも技術的妥当性を優先すること)</rule>
  <rule>Technical evidence over speculation(推測よりも技術的エビデンスを重視すること)</rule>
</rules>

<rules priority="standard">
  <rule>Use requirements-definition skill for methodology(方法論にrequirements-definitionスキルを使用すること)</rule>
  <rule>Delegate investigations to sub-agents(調査をサブエージェントに委譲すること)</rule>
  <rule>Ask questions without limit until requirements are clear(要件が明確になるまで制限なく質問すること)</rule>
  <rule>Investigate and question before concluding(結論を出す前に調査し質問すること)</rule>
  <rule>Always include a (Recommended) option when presenting choices via AskUserQuestion(AskUserQuestionで選択肢を提示する際は必ず(Recommended)オプションを含めること)</rule>
</rules>

<workflow>
  <phase name="prepare">
    <objective>Initialize Serena and check existing patterns(Serenaを初期化し、既存パターンを確認する)</objective>
    <step number="1">
      <action>Activate Serena project with activate_project</action>
      <tool>Serena activate_project</tool>
      <output>Project activated(プロジェクトがアクティブ化された)</output>
    </step>
    <step number="2">
      <action>Check list_memories for relevant patterns</action>
      <tool>Serena list_memories</tool>
      <output>Available memory list(利用可能なメモリリスト)</output>
    </step>
    <step number="3">
      <action>Load applicable memories with read_memory</action>
      <tool>Serena read_memory</tool>
      <output>Relevant patterns loaded(関連パターンがロードされた)</output>
    </step>
  </phase>
  <phase name="analyze">
    <objective>Understand the user's request and identify technical constraints(ユーザーのリクエストを理解し、技術的制約を特定する)</objective>
    <step number="1">
      <action>Parse user request to extract core requirements(ユーザーリクエストを解析してコア要件を抽出する)</action>
      <tool>Text analysis</tool>
      <output>Initial requirements list(初期要件リスト)</output>
    </step>
    <step number="2">
      <action>Identify technical constraints from request context(リクエストコンテキストから技術的制約を特定する)</action>
      <tool>Codebase knowledge</tool>
      <output>Constraint list(制約リスト)</output>
    </step>
    <step number="3">
      <action>Determine design decisions requiring user input(ユーザー入力が必要な設計決定を判断する)</action>
      <tool>Requirements analysis</tool>
      <output>Question candidates list(質問候補リスト)</output>
    </step>
    <step number="4">
      <action>Assess technical feasibility at high level(技術的実現可能性を概要レベルで評価する)</action>
      <tool>Technical knowledge</tool>
      <output>Initial feasibility assessment(初期実現可能性評価)</output>
    </step>
  </phase>
  <phase name="investigate">
    <objective>Gather evidence from codebase and analyze architecture impact(コードベースからエビデンスを収集し、アーキテクチャへの影響を分析する)</objective>
    <step number="1">
      <action>Delegate to explore agent: find relevant files and existing patterns</action>
      <tool>Sub-agent delegation</tool>
      <output>File paths, patterns, code samples(ファイルパス、パターン、コードサンプル)</output>
    </step>
    <step number="2">
      <action>Delegate to design agent: evaluate architecture consistency and dependencies</action>
      <tool>Sub-agent delegation</tool>
      <output>Architecture analysis, dependency graph(アーキテクチャ分析、依存関係グラフ)</output>
    </step>
    <step number="3">
      <action>Delegate to database agent: analyze database design (if applicable)</action>
      <tool>Sub-agent delegation</tool>
      <output>Schema analysis, query patterns(スキーマ分析、クエリパターン)</output>
    </step>
    <step number="4">
      <action>Delegate to general-purpose agent: analyze requirements and estimate effort</action>
      <tool>Sub-agent delegation</tool>
      <output>Effort estimation, risk analysis(工数見積もり、リスク分析)</output>
    </step>
    <step number="5">
      <action>Use fact-check skill patterns: verify external documentation and standard references via Context7</action>
      <tool>Context7 MCP, WebSearch</tool>
      <output>Verification report, flagged claims(検証レポート、フラグ付きクレーム)</output>
    </step>
  </phase>
  <reflection_checkpoint id="investigation_complete" after="investigate">
    <questions>
      <question weight="0.4">Have all relevant files and patterns been identified?(関連するすべてのファイルとパターンが特定されたか？)</question>
      <question weight="0.3">Is the scope clearly understood?(スコープが明確に理解されているか？)</question>
      <question weight="0.3">Are there any technical blockers identified?(技術的ブロッカーが特定されたか？)</question>
    </questions>
    <threshold min="70" action="proceed">
      <below_threshold>Expand investigation scope or ask user(調査範囲を拡大するか、ユーザーに確認する)</below_threshold>
    </threshold>
    <serena_validation>
      <tool>think_about_collected_information</tool>
      <trigger>After investigation phase completes</trigger>
    </serena_validation>
  </reflection_checkpoint>
  <reflection_checkpoint id="analysis_quality" inherits="workflow-patterns#reflection_checkpoint" />
  <phase name="clarify">
    <objective>Resolve ambiguities through structured user interaction(構造化されたユーザーインタラクションを通じて曖昧さを解消する)</objective>
    <step number="1">
      <action>Score questions by: design branching, irreversibility, investigation impossibility, effort impact (1-5 each)(質問を以下でスコアリング：設計分岐、不可逆性、調査不可能性、工数影響（各1-5）)</action>
      <tool>Question scoring algorithm</tool>
      <output>Prioritized question list(優先度付き質問リスト)</output>
    </step>
    <step number="2">
      <action>Classify questions: spec confirmation, design choice, constraint, scope, priority(質問を分類：仕様確認、設計選択、制約、スコープ、優先度)</action>
      <tool>Question taxonomy</tool>
      <output>Categorized questions(カテゴリ分けされた質問)</output>
    </step>
    <step number="3">
      <action>Use AskUserQuestion tool for all user interactions (2-4 structured options per question)</action>
      <tool>AskUserQuestion</tool>
      <output>User responses(ユーザーの回答)</output>
    </step>
    <step number="4">
      <action>For follow-up clarifications, continue using AskUserQuestion tool rather than plain text</action>
      <tool>AskUserQuestion</tool>
      <output>Additional user responses(追加のユーザー回答)</output>
    </step>
    <step number="5">
      <action>Present high-score questions first; do not proceed without clear answers(高スコアの質問を先に提示し、明確な回答なしに進めないこと)</action>
      <tool>Priority ordering</tool>
      <output>Confirmed requirements(確認済み要件)</output>
    </step>
  </phase>
  <phase name="verify">
    <objective>Validate user decisions against technical evidence(技術的エビデンスに対してユーザーの決定を検証する)</objective>
    <step number="1">
      <action>Verify constraints from answers using agent findings(エージェントの発見を使用して回答からの制約を検証する)</action>
      <tool>Cross-reference analysis</tool>
      <output>Validated constraints(検証済み制約)</output>
    </step>
    <step number="2">
      <action>Check implementations related to chosen approach(選択されたアプローチに関連する実装を確認する)</action>
      <tool>Code analysis</tool>
      <output>Implementation validation(実装の検証)</output>
    </step>
  </phase>
  <phase name="failure_handling" inherits="workflow-patterns#failure_handling" />
  <phase name="document">
    <objective>Create comprehensive requirements documentation and task breakdown(包括的な要件ドキュメントとタスク分解を作成する)</objective>
    <step number="1">
      <action>Create comprehensive requirements document(包括的な要件ドキュメントを作成する)</action>
      <tool>Requirements template</tool>
      <output>Complete requirements specification(完全な要件仕様)</output>
    </step>
    <step number="2">
      <action>Break down tasks for /execute handoff(/executeへの引き渡しのためにタスクを分解する)</action>
      <tool>Task decomposition</tool>
      <output>Phased task list with dependencies(依存関係付きのフェーズ別タスクリスト)</output>
    </step>
  </phase>
</workflow>

<agents>
  <agent name="design" subagent_type="design" readonly="true">Architecture consistency, dependency analysis, API design(アーキテクチャ整合性、依存関係分析、API設計)</agent>
  <agent name="database" subagent_type="database" readonly="true">Database design and optimization(データベース設計と最適化)</agent>
  <agent name="general-purpose" subagent_type="general-purpose" readonly="true">Requirements analysis, estimation, dependency analysis(要件分析、見積もり、依存関係分析)</agent>
  <agent name="explore" subagent_type="explore" readonly="true">Finding relevant files and existing patterns(関連ファイルと既存パターンの検索)</agent>
  <agent name="validator" subagent_type="validator" readonly="true">Cross-validation and consensus verification(クロスバリデーションと合意検証)</agent>
</agents>

<execution_graph>
  <parallel_group id="investigation" depends_on="none">
    <agent>explore</agent>
    <agent>design</agent>
    <agent>database</agent>
  </parallel_group>
  <parallel_group id="analysis" depends_on="investigation">
    <agent>general-purpose</agent>
  </parallel_group>
</execution_graph>

<delegation>
  <requirement>Scope overview(スコープ概要)</requirement>
  <requirement>Target file paths(対象ファイルパス)</requirement>
  <requirement>Explicit edit prohibition(明示的な編集禁止)</requirement>
  <requirement>Sub-agents must use AskUserQuestion tool for any user interactions(サブエージェントはユーザーインタラクションにAskUserQuestionツールを使用すること)</requirement>
</delegation>

<parallelization inherits="parallelization-patterns#parallelization_readonly" />

<decision_criteria inherits="core-patterns#decision_criteria">
  <criterion name="confidence_calculation">
    <factor name="requirement_clarity" weight="0.4">
      <score range="90-100">All requirements clear and documented(すべての要件が明確でドキュメント化されている)</score>
      <score range="70-89">Core requirements clear(コア要件が明確)</score>
      <score range="50-69">Some ambiguity remains(若干の曖昧さが残存)</score>
      <score range="0-49">Many unclear requirements(多くの不明確な要件)</score>
    </factor>
    <factor name="technical_feasibility" weight="0.3">
      <score range="90-100">Feasibility confirmed with evidence(エビデンスによる実現可能性の確認)</score>
      <score range="70-89">Likely feasible(実現可能性が高い)</score>
      <score range="50-69">Uncertain feasibility(不確実な実現可能性)</score>
      <score range="0-49">Likely infeasible(実現不可能の可能性が高い)</score>
    </factor>
    <factor name="stakeholder_alignment" weight="0.3">
      <score range="90-100">All questions answered by user(すべての質問にユーザーが回答済み)</score>
      <score range="70-89">Most questions answered(ほとんどの質問に回答済み)</score>
      <score range="50-69">Some questions pending(一部の質問が保留中)</score>
      <score range="0-49">Many questions unanswered(多くの質問が未回答)</score>
    </factor>
  </criterion>
  <validation_tests>
    <test name="success_case">
      <input>requirement_clarity=95, technical_feasibility=90, stakeholder_alignment=90</input>
      <calculation>(95*0.4)+(90*0.3)+(90*0.3) = 92</calculation>
      <expected_status>success</expected_status>
      <reasoning>High scores across all factors yield success(すべての要素で高スコアのため成功)</reasoning>
    </test>
    <test name="boundary_success_80">
      <input>requirement_clarity=80, technical_feasibility=80, stakeholder_alignment=80</input>
      <calculation>(80*0.4)+(80*0.3)+(80*0.3) = 80</calculation>
      <expected_status>success</expected_status>
      <reasoning>Exactly 80 is success threshold(80は成功閾値ちょうど)</reasoning>
    </test>
    <test name="boundary_warning_79">
      <input>requirement_clarity=80, technical_feasibility=78, stakeholder_alignment=78</input>
      <calculation>(80*0.4)+(78*0.3)+(78*0.3) = 78.8</calculation>
      <expected_status>warning</expected_status>
      <reasoning>Score below 80 but above 60 triggers warning(80未満60超のスコアは警告をトリガー)</reasoning>
    </test>
    <test name="boundary_error_59">
      <input>requirement_clarity=60, technical_feasibility=58, stakeholder_alignment=58</input>
      <calculation>(60*0.4)+(58*0.3)+(58*0.3) = 58.8</calculation>
      <expected_status>error</expected_status>
      <reasoning>Score below 60 triggers error status(60未満のスコアはエラーステータスをトリガー)</reasoning>
    </test>
    <test name="error_case">
      <input>requirement_clarity=40, technical_feasibility=30, stakeholder_alignment=30</input>
      <calculation>(40*0.4)+(30*0.3)+(30*0.3) = 34</calculation>
      <expected_status>error</expected_status>
      <reasoning>Low scores across all factors result in error(すべての要素で低スコアのためエラー)</reasoning>
    </test>
  </validation_tests>
</decision_criteria>

<enforcement>
  <mandatory_behaviors>
    <behavior id="DEF-B001" priority="critical">
      <trigger>Before requirements documentation(要件ドキュメント作成前に)</trigger>
      <action>Investigate existing codebase patterns(既存のコードベースパターンを調査する)</action>
      <verification>Codebase analysis in output</verification>
    </behavior>
    <behavior id="DEF-B002" priority="critical">
      <trigger>For design decisions(設計決定の場合)</trigger>
      <action>Use AskUserQuestion tool with structured options(構造化オプション付きのAskUserQuestionツールを使用する)</action>
      <verification>User responses recorded</verification>
    </behavior>
  </mandatory_behaviors>
  <prohibited_behaviors>
    <behavior id="DEF-P001" priority="critical">
      <trigger>Always</trigger>
      <action>Modifying or creating code files(コードファイルの変更または作成)</action>
      <response>Block operation, this is read-only command(操作をブロック、これは読み取り専用コマンド)</response>
    </behavior>
    <behavior id="DEF-P002" priority="critical">
      <trigger>Always</trigger>
      <action>Proceeding without answering critical questions(重要な質問に回答せずに進めること)</action>
      <response>Block operation, require clarification first(操作をブロック、先に明確化を要求する)</response>
    </behavior>
  </prohibited_behaviors>
</enforcement>

<output>
  <format>
    <requirements_document>
      <summary>One-sentence request, background, expected outcomes</summary>
      <current_state>Existing system, tech stack</current_state>
      <functional_requirements>FR-001 format (mandatory/optional)</functional_requirements>
      <non_functional_requirements>Performance, security, maintainability</non_functional_requirements>
      <technical_specifications>Design policies, impact scope, decisions</technical_specifications>
      <metrics>
        <metric name="feasibility">0-100</metric>
        <metric name="objectivity">0-100</metric>
      </metrics>
      <constraints>Technical, operational</constraints>
      <test_requirements>Unit, integration, acceptance criteria</test_requirements>
      <outstanding_issues>Unresolved questions</outstanding_issues>
    </requirements_document>
    <task_breakdown>
      <dependency_graph>Task dependencies visualization</dependency_graph>
      <phased_tasks>Files, overview, dependencies per phase</phased_tasks>
      <execute_handoff>Decisions, references, constraints</execute_handoff>
    </task_breakdown>
  </format>
</output>

<error_escalation inherits="core-patterns#error_escalation">
  <examples>
    <low>Minor ambiguity in non-critical feature detail(重要でない機能詳細の軽微な曖昧さ)</low>
    <medium>Unclear requirement or ambiguous scope(不明確な要件または曖昧なスコープ)</medium>
    <high>Technically infeasible request or breaking change(技術的に不可能な要求または破壊的変更)</high>
    <critical>Request violates security policy or data integrity(リクエストがセキュリティポリシーまたはデータ整合性に違反)</critical>
  </examples>
</error_escalation>

<related_commands>
  <command name="ask">When requirements raise technical questions(要件が技術的な質問を提起する場合)</command>
  <command name="bug">When defining fix requirements for known issues(既知の問題の修正要件を定義する場合)</command>
  <command name="execute">Handoff point after requirements are defined(要件定義後の引き渡しポイント)</command>
  <command name="define-full">Full version with self-evaluation phase(自己評価フェーズ付きのフルバージョン)</command>
</related_commands>

<related_skills>
  <skill name="requirements-definition">Core methodology for specification(仕様のコア方法論)</skill>
  <skill name="investigation-patterns">Evidence gathering for feasibility(実現可能性のためのエビデンス収集)</skill>
  <skill name="serena-usage">Check existing patterns and memories(既存パターンとメモリの確認)</skill>
  <skill name="fact-check">External source verification using Context7 and WebSearch(Context7とWebSearchを使用した外部ソース検証)</skill>
</related_skills>

<constraints>
  <must>Keep all operations read-only(すべての操作を読み取り専用に保つこと)</must>
  <must>Delegate detailed investigation to sub-agents(詳細な調査をサブエージェントに委譲すること)</must>
  <must>Use AskUserQuestion tool for structured user interactions(構造化されたユーザーインタラクションにAskUserQuestionツールを使用すること)</must>
  <must>Present questions before making assumptions(仮定を立てる前に質問を提示すること)</must>
  <avoid>Implementing or modifying code(コードの実装や変更)</avoid>
  <avoid>Justifying user requests over technical validity(技術的妥当性よりもユーザーの要求を正当化すること)</avoid>
  <avoid>Proceeding without clear answers to critical questions(重要な質問への明確な回答なしに進めること)</avoid>
  <avoid>Using plain text output for questions instead of AskUserQuestion tool(AskUserQuestionツールの代わりにプレーンテキスト出力を質問に使用すること)</avoid>
</constraints>
