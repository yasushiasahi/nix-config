---
argument-hint: [message]
description: Full requirements definition with feedback loop(フィードバックループ付き完全要件定義)
---

<purpose>
Conduct detailed requirements definition with automatic feedback and regeneration cycle. Executes the complete define workflow, collects feedback from multiple agents, and regenerates an improved specification in a single automated flow.(自動フィードバックと再生成サイクルを伴う詳細な要件定義を実施する。完全なdefineワークフローを実行し、複数のエージェントからフィードバックを収集し、単一の自動化フローで改善された仕様を再生成する。)
</purpose>

<refs>
  <skill use="patterns">core-patterns</skill>
  <skill use="workflow">requirements-definition</skill>
  <skill use="workflow">execution-workflow</skill>
  <skill use="workflow">fact-check</skill>
  <skill use="tools">serena-usage</skill>
  <skill use="tools">context7-usage</skill>
  <skill use="workflow">define-core</skill>
</refs>

<rules priority="critical">
  <rule>Never modify, create, or delete files(ファイルの変更、作成、削除を絶対に行わないこと)</rule>
  <rule>Never implement code; requirements definition only(コードを実装せず、要件定義のみを行うこと)</rule>
  <rule>Complete full cycle: define -> feedback -> regenerate(完全なサイクルを完了すること：定義 → フィードバック → 再生成)</rule>
  <rule>Maximum one iteration (no infinite loops)(最大1回の反復（無限ループ禁止）)</rule>
  <rule>Automatic flow between phases (no user confirmation between phases)(フェーズ間は自動フロー（フェーズ間でのユーザー確認なし）)</rule>
</rules>

<rules priority="standard">
  <rule>Use requirements-definition skill for methodology(方法論にはrequirements-definitionスキルを使用すること)</rule>
  <rule>Delegate investigations to sub-agents(調査をサブエージェントに委譲すること)</rule>
  <rule>Ask questions without limit until requirements are clear(要件が明確になるまで制限なく質問すること)</rule>
  <rule>Investigate and question before concluding(結論を出す前に調査と質問を行うこと)</rule>
  <rule>Always include a (Recommended) option when presenting choices via AskUserQuestion(AskUserQuestionで選択肢を提示する際は常に(Recommended)オプションを含めること)</rule>
</rules>

<workflow>
  <phase name="define_initial">
    <objective>Execute core define phases to produce initial requirements document(初期要件ドキュメントを生成するためにコアdefineフェーズを実行する)</objective>
    <subphase name="prepare">
      <objective>Initialize Serena and check existing patterns(Serenaを初期化し、既存パターンを確認する)</objective>
      <step number="1">
        <action>Activate Serena project with activate_project</action>
        <tool>Serena activate_project</tool>
        <output>Project activated(プロジェクトがアクティベートされた)</output>
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
    </subphase>
    <subphase name="analyze">
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
        <action>Determine design decisions requiring user input(ユーザー入力が必要な設計上の決定を判断する)</action>
        <tool>Requirements analysis</tool>
        <output>Question candidates list(質問候補リスト)</output>
      </step>
      <step number="4">
        <action>Assess technical feasibility at high level(技術的実現可能性を高レベルで評価する)</action>
        <tool>Technical knowledge</tool>
        <output>Initial feasibility assessment(初期実現可能性評価)</output>
      </step>
    </subphase>
    <subphase name="investigate">
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
        <output>Verification report, flagged claims(検証レポート、フラグ付きの主張)</output>
      </step>
    </subphase>
    <reflection_checkpoint id="investigation_complete" after="investigate">
      <questions>
        <question weight="0.4">Have all relevant files and patterns been identified?(関連するすべてのファイルとパターンが特定されたか？)</question>
        <question weight="0.3">Is the scope clearly understood?(スコープは明確に理解されているか？)</question>
        <question weight="0.3">Are there any technical blockers identified?(技術的ブロッカーが特定されたか？)</question>
      </questions>
      <threshold min="70" action="proceed">
        <below_threshold>Expand investigation scope or ask user(調査範囲を拡大するかユーザーに確認する)</below_threshold>
      </threshold>
      <serena_validation>
        <tool>think_about_collected_information</tool>
        <trigger>After investigation subphase completes</trigger>
      </serena_validation>
    </reflection_checkpoint>
    <subphase name="clarify">
      <objective>Resolve ambiguities through structured user interaction(構造化されたユーザーインタラクションを通じて曖昧さを解決する)</objective>
      <step number="1">
        <action>Score questions by: design branching, irreversibility, investigation impossibility, effort impact (1-5 each)(質問をスコアリング：設計分岐、不可逆性、調査不可能性、工数影響（各1-5）)</action>
        <tool>Question scoring algorithm</tool>
        <output>Prioritized question list(優先順位付き質問リスト)</output>
      </step>
      <step number="2">
        <action>Classify questions: spec confirmation, design choice, constraint, scope, priority(質問を分類：仕様確認、設計選択、制約、スコープ、優先度)</action>
        <tool>Question taxonomy</tool>
        <output>Categorized questions(カテゴリ分類された質問)</output>
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
    </subphase>
    <subphase name="verify">
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
    </subphase>
    <subphase name="document">
      <objective>Create comprehensive requirements documentation and task breakdown(包括的な要件ドキュメントとタスク分解を作成する)</objective>
      <step number="1">
        <action>Create comprehensive requirements document(包括的な要件ドキュメントを作成する)</action>
        <tool>Requirements template</tool>
        <output>Complete requirements specification(完全な要件仕様)</output>
      </step>
      <step number="2">
        <action>Break down tasks for /execute handoff(/executeへの引き渡しのためにタスクを分解する)</action>
        <tool>Task decomposition</tool>
        <output>Phased task list with dependencies(依存関係付きフェーズ分けタスクリスト)</output>
      </step>
    </subphase>
  </phase>

  <phase name="collect_feedback">
    <objective>Launch feedback agents in define mode and collect evaluation results(defineモードでフィードバックエージェントを起動し、評価結果を収集する)</objective>
    <step number="1">
      <action>Launch plan agent: evaluate execution plan quality(計画エージェントを起動：実行計画の品質を評価する)</action>
      <tool>Sub-agent delegation (plan)</tool>
      <aspects>Step granularity, dependencies, risk identification, completeness, feasibility</aspects>
      <output>Plan evaluation report(計画評価レポート)</output>
    </step>
    <step number="2">
      <action>Launch estimation agent: evaluate estimation validity(見積もりエージェントを起動：見積もりの妥当性を評価する)</action>
      <tool>Sub-agent delegation (general-purpose)</tool>
      <aspects>Effort accuracy, risk assessment, dependency completeness</aspects>
      <output>Estimation evaluation report(見積もり評価レポート)</output>
    </step>
    <step number="3">
      <action>Launch validator agent: cross-validate requirements consistency(バリデーターエージェントを起動：要件の整合性をクロスバリデーションする)</action>
      <tool>Sub-agent delegation (validator)</tool>
      <aspects>Internal consistency, completeness, contradiction detection</aspects>
      <output>Validation report(バリデーションレポート)</output>
    </step>
    <step number="4">
      <action>Use fact-check skill patterns: verify external source claims via Context7</action>
      <tool>Context7 MCP, WebSearch</tool>
      <output>Fact-check report(ファクトチェックレポート)</output>
    </step>
    <execution_mode>All agents in parallel</execution_mode>
    <reflection_checkpoint id="feedback_quality" after="collect_feedback">
      <questions>
        <question weight="0.4">Did all feedback agents complete successfully?(すべてのフィードバックエージェントは正常に完了したか？)</question>
        <question weight="0.3">Is the feedback specific and actionable?(フィードバックは具体的で実行可能か？)</question>
        <question weight="0.3">Are there critical issues requiring regeneration?(再生成が必要な重大な問題があるか？)</question>
      </questions>
      <threshold min="70" action="proceed">
        <below_threshold>Re-run failed agents or gather additional context(失敗したエージェントを再実行するか、追加コンテキストを収集する)</below_threshold>
      </threshold>
      <serena_validation>
        <tool>think_about_collected_information</tool>
        <trigger>After feedback collection completes</trigger>
      </serena_validation>
    </reflection_checkpoint>
  </phase>

  <phase name="regenerate">
    <objective>Incorporate feedback and generate complete updated specification(フィードバックを組み込み、完全な更新済み仕様を生成する)</objective>
    <step number="1">
      <action>Synthesize feedback from all agents(すべてのエージェントからのフィードバックを統合する)</action>
      <tool>Feedback synthesis</tool>
      <output>Consolidated feedback summary(統合フィードバックサマリー)</output>
    </step>
    <step number="2">
      <action>Identify critical issues requiring specification changes(仕様変更が必要な重大な問題を特定する)</action>
      <tool>Issue prioritization</tool>
      <output>Prioritized issue list(優先順位付き問題リスト)</output>
    </step>
    <step number="3">
      <action>Update requirements document addressing critical and warning issues(重大および警告レベルの問題に対処して要件ドキュメントを更新する)</action>
      <tool>Requirements revision</tool>
      <output>Updated requirements specification(更新済み要件仕様)</output>
    </step>
    <step number="4">
      <action>Update task breakdown reflecting specification changes(仕様変更を反映してタスク分解を更新する)</action>
      <tool>Task revision</tool>
      <output>Updated phased task list(更新済みフェーズ分けタスクリスト)</output>
    </step>
    <step number="5">
      <action>Calculate final confidence score(最終信頼度スコアを算出する)</action>
      <tool>Decision criteria evaluation</tool>
      <output>Final confidence score(最終信頼度スコア)</output>
    </step>
    <reflection_checkpoint id="regeneration_complete" after="regenerate">
      <questions>
        <question weight="0.4">Have all critical feedback items been addressed?(すべての重大なフィードバック項目に対処したか？)</question>
        <question weight="0.3">Is the regenerated specification internally consistent?(再生成された仕様は内部的に整合しているか？)</question>
        <question weight="0.3">Is the final confidence score acceptable (>=70)?(最終信頼度スコアは許容範囲内か（>=70）？)</question>
      </questions>
      <threshold min="70" action="complete">
        <below_threshold>Flag remaining issues for user review(残りの問題をユーザーレビュー用にフラグ付けする)</below_threshold>
      </threshold>
      <serena_validation>
        <tool>think_about_whether_you_are_done</tool>
        <trigger>Before final output</trigger>
      </serena_validation>
    </reflection_checkpoint>
  </phase>

  <phase name="failure_handling" inherits="workflow-patterns#failure_handling" />
</workflow>

<agents>
  <agent name="design" subagent_type="design" readonly="true">Architecture consistency, dependency analysis, API design(アーキテクチャ整合性、依存関係分析、API設計)</agent>
  <agent name="database" subagent_type="database" readonly="true">Database design and optimization(データベース設計と最適化)</agent>
  <agent name="general-purpose" subagent_type="general-purpose" readonly="true">Requirements analysis, estimation, dependency analysis(要件分析、見積もり、依存関係分析)</agent>
  <agent name="explore" subagent_type="explore" readonly="true">Finding relevant files and existing patterns(関連ファイルと既存パターンの検索)</agent>
  <agent name="validator" subagent_type="validator" readonly="true">Cross-validation and consensus verification(クロスバリデーションと合意検証)</agent>
  <agent name="plan" subagent_type="Plan" readonly="true">Execution plan review and evaluation(実行計画のレビューと評価)</agent>
</agents>

<execution_graph>
  <parallel_group id="investigation" depends_on="none">
    <agent>explore</agent>
    <agent>design</agent>
    <agent>database</agent>
  </parallel_group>
  <sequential_step id="analysis" depends_on="investigation">
    <agent>general-purpose</agent>
  </sequential_step>
  <sequential_step id="document" depends_on="analysis">
    <action>Create initial requirements document(初期要件ドキュメントを作成する)</action>
  </sequential_step>
  <parallel_group id="feedback" depends_on="document">
    <agent>plan</agent>
    <agent>general-purpose</agent>
    <agent>validator</agent>
  </parallel_group>
  <sequential_step id="regenerate" depends_on="feedback">
    <action>Synthesize feedback and regenerate specification(フィードバックを統合し仕様を再生成する)</action>
  </sequential_step>
</execution_graph>

<delegation>
  <requirement>Scope overview(スコープの概要)</requirement>
  <requirement>Target file paths(対象ファイルパス)</requirement>
  <requirement>Explicit edit prohibition(明示的な編集禁止)</requirement>
  <requirement>Sub-agents must use AskUserQuestion tool for any user interactions(サブエージェントはユーザーインタラクションにAskUserQuestionツールを使用すること)</requirement>
</delegation>

<parallelization inherits="parallelization-patterns#parallelization_readonly" />

<decision_criteria inherits="core-patterns#decision_criteria">
  <criterion name="confidence_calculation">
    <factor name="requirement_clarity" weight="0.3">
      <score range="90-100">All requirements clear and documented(すべての要件が明確でドキュメント化されている)</score>
      <score range="70-89">Core requirements clear(コア要件が明確)</score>
      <score range="50-69">Some ambiguity remains(若干の曖昧さが残る)</score>
      <score range="0-49">Many unclear requirements(多くの不明確な要件)</score>
    </factor>
    <factor name="technical_feasibility" weight="0.25">
      <score range="90-100">Feasibility confirmed with evidence(エビデンスにより実現可能性が確認済み)</score>
      <score range="70-89">Likely feasible(実現可能性が高い)</score>
      <score range="50-69">Uncertain feasibility(実現可能性が不確実)</score>
      <score range="0-49">Likely infeasible(実現不可能の可能性が高い)</score>
    </factor>
    <factor name="stakeholder_alignment" weight="0.2">
      <score range="90-100">All questions answered by user(すべての質問にユーザーが回答済み)</score>
      <score range="70-89">Most questions answered(ほとんどの質問に回答済み)</score>
      <score range="50-69">Some questions pending(一部の質問が未回答)</score>
      <score range="0-49">Many questions unanswered(多くの質問が未回答)</score>
    </factor>
    <factor name="feedback_incorporation" weight="0.25">
      <score range="90-100">All critical feedback addressed(すべての重大なフィードバックに対処済み)</score>
      <score range="70-89">Most feedback addressed(ほとんどのフィードバックに対処済み)</score>
      <score range="50-69">Some feedback addressed(一部のフィードバックに対処済み)</score>
      <score range="0-49">Feedback not incorporated(フィードバックが組み込まれていない)</score>
    </factor>
  </criterion>
  <criterion name="regeneration_validation">
    <factor name="critical_issues_resolved" weight="0.5">All critical issues from feedback addressed(フィードバックからのすべての重大な問題に対処済み)</factor>
    <factor name="internal_consistency" weight="0.3">No contradictions in regenerated specification(再生成された仕様に矛盾がない)</factor>
    <factor name="completeness" weight="0.2">All required sections present and populated(すべての必須セクションが存在し入力されている)</factor>
  </criterion>
  <validation_tests>
    <test name="success_case">
      <input>requirement_clarity=95, technical_feasibility=90, stakeholder_alignment=90, feedback_incorporation=95</input>
      <calculation>(95*0.3)+(90*0.25)+(90*0.2)+(95*0.25) = 92.25</calculation>
      <expected_status>success</expected_status>
      <reasoning>High scores across all factors yield success(すべての要素で高スコアのため成功)</reasoning>
    </test>
    <test name="boundary_success_80">
      <input>requirement_clarity=80, technical_feasibility=80, stakeholder_alignment=80, feedback_incorporation=80</input>
      <calculation>(80*0.3)+(80*0.25)+(80*0.2)+(80*0.25) = 80</calculation>
      <expected_status>success</expected_status>
      <reasoning>Exactly 80 is success threshold(80は成功閾値ちょうど)</reasoning>
    </test>
    <test name="boundary_warning_79">
      <input>requirement_clarity=79, technical_feasibility=79, stakeholder_alignment=79, feedback_incorporation=79</input>
      <calculation>(79*0.3)+(79*0.25)+(79*0.2)+(79*0.25) = 79</calculation>
      <expected_status>warning</expected_status>
      <reasoning>79 is below success threshold(79は成功閾値を下回る)</reasoning>
    </test>
    <test name="boundary_error_59">
      <input>requirement_clarity=59, technical_feasibility=59, stakeholder_alignment=59, feedback_incorporation=59</input>
      <calculation>(59*0.3)+(59*0.25)+(59*0.2)+(59*0.25) = 59</calculation>
      <expected_status>error</expected_status>
      <reasoning>59 is at error threshold(59はエラー閾値)</reasoning>
    </test>
    <test name="error_case">
      <input>requirement_clarity=40, technical_feasibility=50, stakeholder_alignment=45, feedback_incorporation=40</input>
      <calculation>(40*0.3)+(50*0.25)+(45*0.2)+(40*0.25) = 43.5</calculation>
      <expected_status>error</expected_status>
      <reasoning>Low scores yield error status(低スコアのためエラーステータス)</reasoning>
    </test>
  </validation_tests>
</decision_criteria>

<enforcement>
  <mandatory_behaviors>
    <behavior id="DEFF-B001" priority="critical">
      <trigger>Before requirements documentation(要件ドキュメント作成前に)</trigger>
      <action>Investigate existing codebase patterns(既存のコードベースパターンを調査する)</action>
      <verification>Codebase analysis in output</verification>
    </behavior>
    <behavior id="DEFF-B002" priority="critical">
      <trigger>For design decisions(設計上の決定に対して)</trigger>
      <action>Use AskUserQuestion tool with structured options(構造化されたオプション付きでAskUserQuestionツールを使用する)</action>
      <verification>User responses recorded</verification>
    </behavior>
    <behavior id="DEFF-B003" priority="critical">
      <trigger>After initial requirements document(初期要件ドキュメント作成後に)</trigger>
      <action>Execute feedback collection phase(フィードバック収集フェーズを実行する)</action>
      <verification>Feedback results in output</verification>
    </behavior>
    <behavior id="DEFF-B004" priority="critical">
      <trigger>After feedback collection(フィードバック収集後に)</trigger>
      <action>Execute regeneration phase(再生成フェーズを実行する)</action>
      <verification>Regenerated specification in output</verification>
    </behavior>
    <behavior id="DEFF-B005" priority="critical">
      <trigger>During feedback phase(フィードバックフェーズ中に)</trigger>
      <action>Launch all feedback agents in parallel(すべてのフィードバックエージェントを並列で起動する)</action>
      <verification>Parallel execution confirmed</verification>
    </behavior>
  </mandatory_behaviors>
  <prohibited_behaviors>
    <behavior id="DEFF-P001" priority="critical">
      <trigger>Always</trigger>
      <action>Modifying or creating code files(コードファイルの変更または作成)</action>
      <response>Block operation, this is read-only command(操作をブロック、これは読み取り専用コマンド)</response>
    </behavior>
    <behavior id="DEFF-P002" priority="critical">
      <trigger>Always</trigger>
      <action>Proceeding without answering critical questions(重要な質問に回答せずに進行すること)</action>
      <response>Block operation, require clarification first(操作をブロック、先に明確化を要求する)</response>
    </behavior>
    <behavior id="DEFF-P003" priority="critical">
      <trigger>Always</trigger>
      <action>Skipping feedback or regeneration phases(フィードバックまたは再生成フェーズのスキップ)</action>
      <response>Block operation, full cycle required(操作をブロック、完全なサイクルが必要)</response>
    </behavior>
    <behavior id="DEFF-P004" priority="critical">
      <trigger>Always</trigger>
      <action>Multiple regeneration iterations(複数回の再生成反復)</action>
      <response>Block operation, maximum one iteration(操作をブロック、最大1回の反復)</response>
    </behavior>
    <behavior id="DEFF-P005" priority="critical">
      <trigger>Between phases(フェーズ間で)</trigger>
      <action>Requesting user confirmation to proceed(進行のためにユーザー確認を要求すること)</action>
      <response>Proceed automatically between phases(フェーズ間は自動的に進行する)</response>
    </behavior>
  </prohibited_behaviors>
</enforcement>

<output>
  <format>
    <initial_requirements_document>
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
      <task_breakdown>
        <dependency_graph>Task dependencies visualization</dependency_graph>
        <phased_tasks>Files, overview, dependencies per phase</phased_tasks>
      </task_breakdown>
    </initial_requirements_document>
    <feedback_summary>
      <evaluation_scores>
        <metric name="plan_quality">XX/100</metric>
        <metric name="estimation_validity">XX/100</metric>
        <metric name="internal_consistency">XX/100</metric>
        <metric name="overall">XX/100</metric>
      </evaluation_scores>
      <critical_issues>
        <issue>
          <category>Category</category>
          <description>Issue description</description>
          <problem>Description</problem>
          <impact>What this affects</impact>
        </issue>
      </critical_issues>
      <warnings>
        <warning>
          <category>Category</category>
          <description>Issue description</description>
          <problem>Description</problem>
          <recommendation>Suggested change</recommendation>
        </warning>
      </warnings>
      <good_practices>
        <practice>
          <category>Category</category>
          <description>Commendable aspects</description>
        </practice>
      </good_practices>
      <fact_check_results>
        <verified_claims>Claims confirmed against external sources</verified_claims>
        <flagged_claims>Claims with verification confidence below 80</flagged_claims>
      </fact_check_results>
    </feedback_summary>
    <final_requirements_document>
      <changes_from_initial>Summary of changes made based on feedback</changes_from_initial>
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
      <outstanding_issues>Unresolved questions (if any remain)</outstanding_issues>
      <task_breakdown>
        <dependency_graph>Task dependencies visualization</dependency_graph>
        <phased_tasks>Files, overview, dependencies per phase</phased_tasks>
        <execute_handoff>Decisions, references, constraints</execute_handoff>
      </task_breakdown>
      <self_feedback>
        <confidence>XX/100 (based on decision_criteria)</confidence>
        <feedback_addressed>
          <item>
            <status>Addressed</status>
            <issue>Critical issue 1</issue>
            <resolution>How resolved</resolution>
          </item>
          <item>
            <status>Addressed</status>
            <issue>Warning 1</issue>
            <resolution>How resolved</resolution>
          </item>
        </feedback_addressed>
        <remaining_issues>
          <item>
            <status>Note</status>
            <description>Any unresolved items requiring user attention</description>
          </item>
        </remaining_issues>
      </self_feedback>
    </final_requirements_document>
  </format>
</output>

<error_escalation inherits="core-patterns#error_escalation">
  <examples>
    <low>Minor ambiguity in non-critical feature detail(非重要な機能詳細における軽微な曖昧さ)</low>
    <medium>Unclear requirement or ambiguous scope(不明確な要件または曖昧なスコープ)</medium>
    <high>Technically infeasible request or breaking change(技術的に実現不可能なリクエストまたは破壊的変更)</high>
    <critical>Request violates security policy or data integrity(リクエストがセキュリティポリシーまたはデータ整合性に違反する)</critical>
  </examples>
</error_escalation>

<related_commands>
  <command name="define">Basic requirements definition without feedback loop(フィードバックループなしの基本要件定義)</command>
  <command name="execute">Handoff point after requirements are defined(要件定義後の引き渡しポイント)</command>
  <command name="feedback">Standalone feedback command for reviewing work(作業レビュー用のスタンドアロンフィードバックコマンド)</command>
  <command name="ask">When requirements raise technical questions(要件が技術的な質問を生じさせた場合)</command>
  <command name="bug">When defining fix requirements for known issues(既知の問題の修正要件を定義する場合)</command>
</related_commands>

<related_skills>
  <skill name="requirements-definition">Core methodology for specification(仕様のコア方法論)</skill>
  <skill name="execution-workflow">Understanding work review methodology(作業レビュー方法論の理解)</skill>
  <skill name="investigation-patterns">Evidence gathering for feasibility(実現可能性のためのエビデンス収集)</skill>
  <skill name="serena-usage">Check existing patterns and memories(既存パターンとメモリの確認)</skill>
  <skill name="fact-check">External source verification using Context7 and WebSearch(Context7とWebSearchを使用した外部ソース検証)</skill>
</related_skills>

<constraints>
  <must>Keep all operations read-only(すべての操作を読み取り専用に保つこと)</must>
  <must>Delegate detailed investigation to sub-agents(詳細な調査をサブエージェントに委譲すること)</must>
  <must>Use AskUserQuestion tool for structured user interactions(構造化されたユーザーインタラクションにAskUserQuestionツールを使用すること)</must>
  <must>Present questions before making assumptions(仮定を立てる前に質問を提示すること)</must>
  <must>Complete all three phases: define, feedback, regenerate(3つのフェーズすべてを完了すること：定義、フィードバック、再生成)</must>
  <must>Execute feedback agents in parallel(フィードバックエージェントを並列で実行すること)</must>
  <must>Automatically proceed between phases without user confirmation(ユーザー確認なしにフェーズ間を自動的に進行すること)</must>
  <avoid>Implementing or modifying code(コードの実装または変更)</avoid>
  <avoid>Justifying user requests over technical validity(技術的妥当性よりもユーザーリクエストを正当化すること)</avoid>
  <avoid>Proceeding without clear answers to critical questions(重要な質問に明確な回答がないまま進行すること)</avoid>
  <avoid>Using plain text output for questions instead of AskUserQuestion tool(AskUserQuestionツールの代わりにプレーンテキスト出力を質問に使用すること)</avoid>
  <avoid>Multiple regeneration iterations (exactly one allowed)(複数回の再生成反復（正確に1回のみ許可）)</avoid>
  <avoid>Sequential execution of independent feedback agents(独立したフィードバックエージェントの逐次実行)</avoid>
</constraints>
