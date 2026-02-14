---
argument-hint: [task-description]
description: Full task execution with feedback loop(フィードバックループ付きフルタスク実行)
---

<purpose>
Execute tasks with automatic feedback collection and conditional fix phase. Runs execute -> feedback -> fix issues (only if issues found) in a single automated flow.(自動フィードバック収集と条件付き修正フェーズによるタスク実行。execute → feedback → fix（問題が見つかった場合のみ）を単一の自動フローで実行する。)
</purpose>

<refs>
  <skill use="patterns">core-patterns</skill>
  <skill use="workflow">execution-workflow</skill>
  <skill use="tools">serena-usage</skill>
</refs>

<rules priority="critical">
  <rule>Delegate detailed work to specialized sub-agents(詳細な作業を専門サブエージェントに委譲すること)</rule>
  <rule>Complete full cycle: execute -> feedback -> fix (conditional)(フルサイクルを完了すること：execute → feedback → fix（条件付き）)</rule>
  <rule>Maximum one fix iteration (no infinite loops)(修正イテレーションは最大1回（無限ループ禁止）)</rule>
  <rule>Automatic flow between phases (no user confirmation)(フェーズ間は自動遷移（ユーザー確認不要）)</rule>
  <rule>Skip fix phase if no issues found in feedback(フィードバックで問題が見つからない場合、修正フェーズをスキップすること)</rule>
</rules>

<rules priority="standard">
  <rule>Use execution-workflow skill for delegation patterns(委譲パターンにはexecution-workflowスキルを使用すること)</rule>
  <rule>Check Serena memories before implementation(実装前にSerenaメモリを確認すること)</rule>
  <rule>Fix only issues identified in feedback, not full re-implementation(フィードバックで特定された問題のみ修正し、全面的な再実装はしないこと)</rule>
</rules>

<workflow>
  <phase name="execute_initial">
    <objective>Execute core workflow phases to complete initial implementation(コアワークフローフェーズを実行し、初期実装を完了する)</objective>
    <subphase name="prepare">
      <objective>Initialize Serena and check existing patterns(Serenaを初期化し、既存パターンを確認する)</objective>
      <step number="1">
        <action>Activate Serena project with activate_project(activate_projectでSerenaプロジェクトをアクティブ化する)</action>
        <tool>Serena activate_project</tool>
        <output>Project activated(プロジェクトがアクティブ化された)</output>
      </step>
      <step number="2">
        <action>Check list_memories for relevant patterns(list_memoriesで関連パターンを確認する)</action>
        <tool>Serena list_memories</tool>
        <output>Available memory list(利用可能なメモリ一覧)</output>
      </step>
      <step number="3">
        <action>Load applicable memories with read_memory(read_memoryで該当するメモリを読み込む)</action>
        <tool>Serena read_memory</tool>
        <output>Relevant patterns loaded(関連パターンが読み込まれた)</output>
      </step>
    </subphase>
    <subphase name="analyze">
      <objective>Understand the task scope and identify required resources(タスクの範囲を理解し、必要なリソースを特定する)</objective>
      <step number="1">
        <action>What tasks need to be done?(どのタスクを実行する必要があるか？)</action>
        <tool>Task analysis</tool>
        <output>Task list(タスク一覧)</output>
      </step>
      <step number="2">
        <action>Which sub-agents are best suited?(どのサブエージェントが最適か？)</action>
        <tool>Agent selection</tool>
        <output>Agent assignments(エージェント割り当て)</output>
      </step>
      <step number="3">
        <action>Which tasks can run in parallel?(どのタスクを並列実行できるか？)</action>
        <tool>Dependency analysis</tool>
        <output>Parallel task groups(並列タスクグループ)</output>
      </step>
      <step number="4">
        <action>What dependencies exist between tasks?(タスク間にどのような依存関係があるか？)</action>
        <tool>Dependency mapping</tool>
        <output>Dependency graph(依存関係グラフ)</output>
      </step>
      <step number="5">
        <action>What verification is needed?(どのような検証が必要か？)</action>
        <tool>Verification planning</tool>
        <output>Verification checklist(検証チェックリスト)</output>
      </step>
    </subphase>
    <subphase name="decompose">
      <objective>Break down complex tasks into manageable units(複雑なタスクを管理可能な単位に分解する)</objective>
      <step number="1">
        <action>Split into manageable units(管理可能な単位に分割する)</action>
        <tool>Task decomposition</tool>
        <output>Atomic task list(原子タスク一覧)</output>
      </step>
      <step number="2">
        <action>Identify task boundaries(タスク境界を特定する)</action>
        <tool>Boundary analysis</tool>
        <output>Clear task scopes(明確なタスクスコープ)</output>
      </step>
    </subphase>
    <subphase name="structure">
      <objective>Organize tasks for optimal execution(最適な実行のためにタスクを整理する)</objective>
      <step number="1">
        <action>Identify parallel vs sequential tasks(並列タスクと逐次タスクを特定する)</action>
        <tool>Execution planning</tool>
        <output>Execution order(実行順序)</output>
      </step>
      <step number="2">
        <action>Define task dependencies(タスクの依存関係を定義する)</action>
        <tool>Dependency definition</tool>
        <output>Task dependency map(タスク依存関係マップ)</output>
      </step>
    </subphase>
    <reflection_checkpoint id="analysis_quality" inherits="workflow-patterns#reflection_checkpoint" />
    <subphase name="assign">
      <objective>Delegate tasks to appropriate sub-agents with clear instructions(適切なサブエージェントに明確な指示でタスクを委譲する)</objective>
      <step number="1">
        <action>Delegate tasks with detailed instructions(詳細な指示でタスクを委譲する)</action>
        <tool>Sub-agent delegation</tool>
        <output>Delegated tasks(委譲されたタスク)</output>
      </step>
      <step number="2">
        <action>Provide context and constraints(コンテキストと制約を提供する)</action>
        <tool>Context provision</tool>
        <output>Contextual guidance(コンテキストガイダンス)</output>
      </step>
    </subphase>
    <reflection_checkpoint id="assignment_complete" after="assign">
      <questions>
        <question weight="0.4">Have all tasks been properly delegated?(すべてのタスクが適切に委譲されたか？)</question>
        <question weight="0.3">Are the sub-agent instructions clear?(サブエージェントへの指示は明確か？)</question>
        <question weight="0.3">Are dependencies between tasks handled?(タスク間の依存関係は処理されたか？)</question>
      </questions>
      <threshold min="70" action="proceed">
        <below_threshold>Refine task assignments or ask user(タスク割り当てを見直すか、ユーザーに確認する)</below_threshold>
      </threshold>
      <serena_validation>
        <tool>think_about_task_adherence</tool>
        <trigger>Before any code modification delegation</trigger>
      </serena_validation>
    </reflection_checkpoint>
    <subphase name="consolidate">
      <objective>Integrate sub-agent outputs into cohesive result(サブエージェントの出力を統合的な結果にまとめる)</objective>
      <step number="1">
        <action>Verify sub-agent outputs(サブエージェントの出力を検証する)</action>
        <tool>Output verification</tool>
        <output>Verification results(検証結果)</output>
      </step>
      <step number="2">
        <action>Combine results(結果を統合する)</action>
        <tool>Result integration</tool>
        <output>Consolidated implementation(統合された実装)</output>
      </step>
    </subphase>
  </phase>

  <phase name="collect_feedback">
    <objective>Launch feedback agents in execute mode and collect evaluation results(フィードバックエージェントをexecuteモードで起動し、評価結果を収集する)</objective>
    <step number="1">
      <action>Launch quality agent: syntax, type, format verification(品質エージェントを起動：構文、型、フォーマットの検証)</action>
      <tool>Sub-agent delegation (quality-assurance)</tool>
      <aspects>Syntax correctness, type safety, code formatting, style compliance</aspects>
      <output>Quality evaluation report(品質評価レポート)</output>
    </step>
    <step number="2">
      <action>Launch security agent: vulnerability detection(セキュリティエージェントを起動：脆弱性検出)</action>
      <tool>Sub-agent delegation (security)</tool>
      <aspects>Security vulnerabilities, input validation, authentication, authorization</aspects>
      <output>Security evaluation report(セキュリティ評価レポート)</output>
    </step>
    <step number="3">
      <action>Launch design agent: architecture consistency(設計エージェントを起動：アーキテクチャ整合性)</action>
      <tool>Sub-agent delegation (design)</tool>
      <aspects>Architecture patterns, dependency management, API design, coupling</aspects>
      <output>Design evaluation report(設計評価レポート)</output>
    </step>
    <step number="4">
      <action>Launch docs agent: documentation completeness(ドキュメントエージェントを起動：ドキュメント完全性)</action>
      <tool>Sub-agent delegation (docs)</tool>
      <aspects>Code comments, API documentation, README updates</aspects>
      <output>Documentation evaluation report(ドキュメント評価レポート)</output>
    </step>
    <step number="5">
      <action>Launch performance agent: performance implications(パフォーマンスエージェントを起動：パフォーマンスへの影響)</action>
      <tool>Sub-agent delegation (performance)</tool>
      <aspects>Algorithm complexity, resource usage, potential bottlenecks</aspects>
      <output>Performance evaluation report(パフォーマンス評価レポート)</output>
    </step>
    <step number="6">
      <action>Launch test agent: test coverage analysis(テストエージェントを起動：テストカバレッジ分析)</action>
      <tool>Sub-agent delegation (test)</tool>
      <aspects>Test coverage, edge cases, test quality</aspects>
      <output>Test evaluation report(テスト評価レポート)</output>
    </step>
    <execution_mode>All agents in parallel</execution_mode>
    <reflection_checkpoint id="feedback_quality" after="collect_feedback">
      <questions>
        <question weight="0.4">Did all feedback agents complete successfully?(すべてのフィードバックエージェントは正常に完了したか？)</question>
        <question weight="0.3">Is the feedback specific and actionable?(フィードバックは具体的で実行可能か？)</question>
        <question weight="0.3">Are there critical issues requiring fixes?(修正が必要な重大な問題はあるか？)</question>
      </questions>
      <threshold min="70" action="proceed">
        <below_threshold>Re-run failed agents or gather additional context(失敗したエージェントを再実行するか、追加のコンテキストを収集する)</below_threshold>
      </threshold>
      <serena_validation>
        <tool>think_about_collected_information</tool>
        <trigger>After feedback collection completes</trigger>
      </serena_validation>
    </reflection_checkpoint>
  </phase>

  <phase name="fix_issues">
    <condition>Execute only if feedback found critical or warning issues(フィードバックで重大または警告レベルの問題が見つかった場合のみ実行)</condition>
    <skip_condition>Skip if no issues found in feedback(フィードバックで問題が見つからない場合はスキップ)</skip_condition>
    <objective>Fix identified issues from feedback phase(フィードバックフェーズで特定された問題を修正する)</objective>
    <step number="1">
      <action>Synthesize feedback from all agents(全エージェントのフィードバックを統合する)</action>
      <tool>Feedback synthesis</tool>
      <output>Consolidated issue list(統合された問題一覧)</output>
    </step>
    <step number="2">
      <action>Prioritize issues by severity (critical > warning > info)(重大度で問題を優先順位付けする（critical > warning > info）)</action>
      <tool>Issue prioritization</tool>
      <output>Prioritized issue list(優先順位付けされた問題一覧)</output>
    </step>
    <step number="3">
      <action>Delegate fixes to appropriate sub-agents(適切なサブエージェントに修正を委譲する)</action>
      <tool>Sub-agent delegation</tool>
      <scope>Only issues identified in feedback, not full re-implementation</scope>
      <output>Fix assignments(修正割り当て)</output>
    </step>
    <step number="4">
      <action>Verify fixes address the identified issues(修正が特定された問題に対処していることを検証する)</action>
      <tool>Fix verification</tool>
      <output>Verification results(検証結果)</output>
    </step>
    <step number="5">
      <action>Consolidate fix results(修正結果を統合する)</action>
      <tool>Result consolidation</tool>
      <output>Fixed implementation(修正された実装)</output>
    </step>
    <iteration_limit>1</iteration_limit>
    <reflection_checkpoint id="fix_complete" after="fix_issues">
      <questions>
        <question weight="0.5">Have all critical issues been addressed?(すべての重大な問題は対処されたか？)</question>
        <question weight="0.3">Have warning issues been addressed where feasible?(警告レベルの問題は可能な範囲で対処されたか？)</question>
        <question weight="0.2">Are any issues deferred with clear justification?(延期された問題には明確な理由があるか？)</question>
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
  <agent name="quality" subagent_type="quality-assurance" readonly="false">Syntax, type, format verification(構文、型、フォーマットの検証)</agent>
  <agent name="security" subagent_type="security" readonly="false">Vulnerability detection(脆弱性検出)</agent>
  <agent name="test" subagent_type="test" readonly="false">Test creation, coverage(テスト作成、カバレッジ)</agent>
  <agent name="refactor" subagent_type="general-purpose" readonly="false">Refactoring, tech debt(リファクタリング、技術的負債)</agent>
  <agent name="docs" subagent_type="docs" readonly="false">Documentation updates(ドキュメント更新)</agent>
  <agent name="review" subagent_type="quality-assurance" readonly="false">Post-implementation review(実装後レビュー)</agent>
  <agent name="debug" subagent_type="general-purpose" readonly="false">Debug support(デバッグサポート)</agent>
  <agent name="performance" subagent_type="performance" readonly="false">Performance optimization(パフォーマンス最適化)</agent>
  <agent name="clean" subagent_type="code-quality" readonly="false">Dead code elimination(デッドコード除去)</agent>
  <agent name="error-handling" subagent_type="general-purpose" readonly="false">Error handling patterns(エラーハンドリングパターン)</agent>
  <agent name="migration" subagent_type="general-purpose" readonly="false">Migration planning and execution(マイグレーション計画と実行)</agent>
  <agent name="database" subagent_type="database" readonly="false">Database design and optimization(データベース設計と最適化)</agent>
  <agent name="infrastructure" subagent_type="devops" readonly="false">Infrastructure design(インフラストラクチャ設計)</agent>
  <agent name="ci-cd" subagent_type="devops" readonly="false">CI/CD pipeline design(CI/CDパイプライン設計)</agent>
  <agent name="observability" subagent_type="devops" readonly="false">Logging, monitoring, tracing(ログ、モニタリング、トレーシング)</agent>
  <agent name="git" subagent_type="git" readonly="false">Git workflow design(Gitワークフロー設計)</agent>
  <agent name="memory" subagent_type="general-purpose" readonly="false">Knowledge base management(ナレッジベース管理)</agent>
  <agent name="validator" subagent_type="validator" readonly="true">Cross-validation and consensus verification(クロスバリデーションと合意検証)</agent>
  <agent name="design" subagent_type="design" readonly="true">Architecture evaluation for feedback(フィードバック用アーキテクチャ評価)</agent>
</agents>

<execution_graph>
  <sequential_phase id="execute" depends_on="none">
    <parallel_group id="quality_assurance">
      <agent>quality</agent>
      <agent>security</agent>
    </parallel_group>
    <parallel_group id="implementation">
      <agent>test</agent>
      <agent>docs</agent>
    </parallel_group>
    <sequential_step id="consolidation">
      <action>Consolidate initial execution results(初期実行結果を統合する)</action>
    </sequential_step>
  </sequential_phase>
  <sequential_phase id="feedback" depends_on="execute">
    <parallel_group id="feedback_agents">
      <agent>quality</agent>
      <agent>security</agent>
      <agent>design</agent>
      <agent>docs</agent>
      <agent>performance</agent>
      <agent>test</agent>
    </parallel_group>
  </sequential_phase>
  <conditional_phase id="fix" depends_on="feedback">
    <condition>issues_found == true</condition>
    <skip_action>Output skip confirmation with no issues message</skip_action>
    <parallel_group id="fix_agents">
      <agent>Agents matching issue categories</agent>
    </parallel_group>
  </conditional_phase>
</execution_graph>

<delegation>
  <requirement>Specific scope and expected deliverables(具体的なスコープと期待される成果物)</requirement>
  <requirement>Target file paths(対象ファイルパス)</requirement>
  <requirement>Reference implementations (specific paths)(参照実装（具体的なパス）)</requirement>
  <requirement>Memory check: list_memories for patterns(メモリ確認：パターン用のlist_memories)</requirement>
  <requirement>For fix phase: specific issue references from feedback(修正フェーズ用：フィードバックからの具体的な問題参照)</requirement>
</delegation>

<parallelization inherits="parallelization-patterns#parallelization_orchestration" />

<decision_criteria inherits="core-patterns#decision_criteria">
  <criterion name="confidence_calculation">
    <factor name="task_clarity" weight="0.2">
      <score range="90-100">Clear requirements with acceptance criteria(受け入れ基準付きの明確な要件)</score>
      <score range="70-89">Clear requirements(明確な要件)</score>
      <score range="50-69">Some ambiguity(若干の曖昧さ)</score>
      <score range="0-49">Unclear requirements(不明確な要件)</score>
    </factor>
    <factor name="implementation_quality" weight="0.3">
      <score range="90-100">All tests pass, code reviewed(全テスト合格、コードレビュー済み)</score>
      <score range="70-89">Tests pass(テスト合格)</score>
      <score range="50-69">Some issues remain(一部問題が残存)</score>
      <score range="0-49">Major issues(重大な問題)</score>
    </factor>
    <factor name="feedback_severity" weight="0.25">
      <score range="90-100">No issues found(問題なし)</score>
      <score range="70-89">Info-level issues only(情報レベルの問題のみ)</score>
      <score range="50-69">Warning-level issues(警告レベルの問題)</score>
      <score range="0-49">Critical issues(重大な問題)</score>
    </factor>
    <factor name="fix_completeness" weight="0.25">
      <score range="90-100">All issues fixed and verified(全問題が修正・検証済み)</score>
      <score range="70-89">Critical issues fixed(重大な問題が修正済み)</score>
      <score range="50-69">Some issues remain(一部問題が残存)</score>
      <score range="0-49">Major issues unfixed(重大な問題が未修正)</score>
    </factor>
  </criterion>
  <validation_tests>
    <test name="no_issues_found">
      <input>task_clarity=90, implementation_quality=95, feedback_severity=95, fix_completeness=100</input>
      <calculation>(90*0.2)+(95*0.3)+(95*0.25)+(100*0.25) = 95.25</calculation>
      <expected_status>success</expected_status>
      <expected_fix_phase>skipped</expected_fix_phase>
      <reasoning>No issues found, fix phase skipped, high confidence(問題なし、修正フェーズはスキップ、高い信頼度)</reasoning>
    </test>
    <test name="issues_fixed_success">
      <input>task_clarity=85, implementation_quality=80, feedback_severity=60, fix_completeness=90</input>
      <calculation>(85*0.2)+(80*0.3)+(60*0.25)+(90*0.25) = 78.5</calculation>
      <expected_status>success</expected_status>
      <expected_fix_phase>executed</expected_fix_phase>
      <reasoning>Issues found and fixed, acceptable confidence(問題が見つかり修正済み、許容可能な信頼度)</reasoning>
    </test>
    <test name="boundary_success_70">
      <input>task_clarity=70, implementation_quality=70, feedback_severity=70, fix_completeness=70</input>
      <calculation>(70*0.2)+(70*0.3)+(70*0.25)+(70*0.25) = 70</calculation>
      <expected_status>success</expected_status>
      <reasoning>Exactly at success threshold(成功閾値ちょうど)</reasoning>
    </test>
    <test name="boundary_warning_69">
      <input>task_clarity=69, implementation_quality=69, feedback_severity=69, fix_completeness=69</input>
      <calculation>(69*0.2)+(69*0.3)+(69*0.25)+(69*0.25) = 69</calculation>
      <expected_status>warning</expected_status>
      <reasoning>Below success threshold, flag for review(成功閾値を下回り、レビュー用にフラグ付け)</reasoning>
    </test>
    <test name="critical_issues_unfixed">
      <input>task_clarity=80, implementation_quality=70, feedback_severity=30, fix_completeness=40</input>
      <calculation>(80*0.2)+(70*0.3)+(30*0.25)+(40*0.25) = 54.5</calculation>
      <expected_status>error</expected_status>
      <reasoning>Critical issues remain unfixed(重大な問題が未修正のまま)</reasoning>
    </test>
  </validation_tests>
</decision_criteria>

<enforcement>
  <mandatory_behaviors>
    <behavior id="EXECF-B001" priority="critical">
      <trigger>Before implementation</trigger>
      <action>Check Serena memories for existing patterns(既存パターンのためにSerenaメモリを確認する)</action>
      <verification>Pattern check in output</verification>
    </behavior>
    <behavior id="EXECF-B002" priority="critical">
      <trigger>After initial execution</trigger>
      <action>Execute feedback collection phase automatically(フィードバック収集フェーズを自動的に実行する)</action>
      <verification>Feedback results in output</verification>
    </behavior>
    <behavior id="EXECF-B003" priority="critical">
      <trigger>After feedback collection</trigger>
      <action>Evaluate if issues require fix phase(問題が修正フェーズを必要とするか評価する)</action>
      <verification>Issue evaluation in output</verification>
    </behavior>
    <behavior id="EXECF-B004" priority="critical">
      <trigger>When issues found</trigger>
      <action>Execute fix phase for identified issues only(特定された問題のみ修正フェーズを実行する)</action>
      <verification>Fix results in output</verification>
    </behavior>
    <behavior id="EXECF-B005" priority="critical">
      <trigger>When no issues found</trigger>
      <action>Skip fix phase with confirmation message(確認メッセージとともに修正フェーズをスキップする)</action>
      <verification>Skip confirmation in output</verification>
    </behavior>
    <behavior id="EXECF-B006" priority="critical">
      <trigger>During feedback phase</trigger>
      <action>Launch all feedback agents in parallel(すべてのフィードバックエージェントを並列で起動する)</action>
      <verification>Parallel execution confirmed</verification>
    </behavior>
  </mandatory_behaviors>
  <prohibited_behaviors>
    <behavior id="EXECF-P001" priority="critical">
      <trigger>Always</trigger>
      <action>Implementing without sub-agent delegation(サブエージェント委譲なしでの実装)</action>
      <response>Block operation, delegate to specialized agents(操作をブロックし、専門エージェントに委譲する)</response>
    </behavior>
    <behavior id="EXECF-P002" priority="critical">
      <trigger>Always</trigger>
      <action>Multiple fix iterations(複数回の修正イテレーション)</action>
      <response>Block operation, maximum one fix iteration allowed(操作をブロック、修正イテレーションは最大1回)</response>
    </behavior>
    <behavior id="EXECF-P003" priority="critical">
      <trigger>Between phases</trigger>
      <action>Requesting user confirmation to proceed(進行のためのユーザー確認要求)</action>
      <response>Proceed automatically between phases(フェーズ間は自動的に進行する)</response>
    </behavior>
    <behavior id="EXECF-P004" priority="critical">
      <trigger>In fix phase</trigger>
      <action>Full re-implementation instead of targeted fixes(対象を絞った修正ではなく全面的な再実装)</action>
      <response>Fix only identified issues from feedback(フィードバックで特定された問題のみ修正する)</response>
    </behavior>
    <behavior id="EXECF-P005" priority="critical">
      <trigger>When no issues found</trigger>
      <action>Executing fix phase unnecessarily(不要な修正フェーズの実行)</action>
      <response>Skip fix phase when feedback shows no issues(フィードバックで問題がない場合、修正フェーズをスキップする)</response>
    </behavior>
  </prohibited_behaviors>
</enforcement>

<output>
  <format>
    <execution_results>
      <summary>Brief description of implemented changes</summary>
      <files_modified>
        <file>
          <path>Absolute file path</path>
          <changes>Summary of changes</changes>
        </file>
      </files_modified>
      <tests_status>Pass/Fail status</tests_status>
    </execution_results>
    <feedback_summary>
      <evaluation_scores>
        <metric name="quality">XX/100</metric>
        <metric name="security">XX/100</metric>
        <metric name="design">XX/100</metric>
        <metric name="documentation">XX/100</metric>
        <metric name="performance">XX/100</metric>
        <metric name="test_coverage">XX/100</metric>
        <metric name="overall">XX/100</metric>
      </evaluation_scores>
      <issues_found>
        <critical>
          <issue>
            <category>Category</category>
            <description>Issue description</description>
            <location>File and line reference</location>
          </issue>
        </critical>
        <warnings>
          <issue>
            <category>Category</category>
            <description>Issue description</description>
            <recommendation>Suggested fix</recommendation>
          </issue>
        </warnings>
        <info>
          <issue>
            <category>Category</category>
            <description>Minor observation</description>
          </issue>
        </info>
      </issues_found>
      <good_practices>
        <practice>
          <category>Category</category>
          <description>Commendable aspects</description>
        </practice>
      </good_practices>
    </feedback_summary>
    <fix_results condition="if issues found">
      <issues_addressed>
        <issue>
          <original>Original issue from feedback</original>
          <fix>How it was fixed</fix>
          <status>Fixed/Deferred</status>
        </issue>
      </issues_addressed>
      <deferred_issues>
        <issue>
          <description>Issue not fixed</description>
          <reason>Justification for deferral</reason>
        </issue>
      </deferred_issues>
    </fix_results>
    <skip_confirmation condition="if no issues found">
      <message>No issues requiring fixes were identified in feedback phase</message>
      <status>Fix phase skipped</status>
    </skip_confirmation>
    <final_status>
      <confidence>XX/100</confidence>
      <summary>Final status summary</summary>
      <next_steps>Recommended follow-up actions if any</next_steps>
    </final_status>
  </format>
</output>

<error_escalation inherits="core-patterns#error_escalation">
  <examples>
    <example severity="low">Minor code style inconsistency(軽微なコードスタイルの不整合)</example>
    <example severity="medium">Test failure or unclear implementation approach(テスト失敗または不明確な実装アプローチ)</example>
    <example severity="high">Breaking change or major implementation blocker(破壊的変更または重大な実装ブロッカー)</example>
    <example severity="critical">Security vulnerability or data loss risk(セキュリティ脆弱性またはデータ損失リスク)</example>
  </examples>
</error_escalation>

<related_commands>
  <command name="execute">Basic execution without feedback loop(フィードバックループなしの基本実行)</command>
  <command name="feedback">Standalone feedback command for reviewing work(作業レビュー用のスタンドアロンフィードバックコマンド)</command>
  <command name="define">When implementation reveals unclear requirements(実装で不明確な要件が判明した場合)</command>
  <command name="define-full">When detailed requirements definition is needed(詳細な要件定義が必要な場合)</command>
  <command name="ask">When implementation requires investigation(実装に調査が必要な場合)</command>
  <command name="bug">When implementation encounters unexpected errors(実装で予期しないエラーが発生した場合)</command>
  <command name="upstream">When preparing changes for upstream OSS contribution(アップストリームOSSコントリビューションの変更を準備する場合)</command>
</related_commands>

<related_skills>
  <skill name="execution-workflow">Core delegation and orchestration patterns(コア委譲・統括パターン)</skill>
  <skill name="serena-usage">Check memories for existing patterns before implementation(実装前に既存パターンのメモリを確認する)</skill>
  <skill name="testing-patterns">Ensure proper test coverage(適切なテストカバレッジを確保する)</skill>
</related_skills>

<constraints>
  <must>Delegate detailed work to sub-agents(詳細な作業をサブエージェントに委譲すること)</must>
  <must>Execute independent tasks in parallel(独立したタスクを並列実行すること)</must>
  <must>Verify outputs before integration(統合前に出力を検証すること)</must>
  <must>Complete all phases: execute, feedback, fix (conditional)(全フェーズを完了すること：execute、feedback、fix（条件付き）)</must>
  <must>Automatically proceed between phases without user confirmation(ユーザー確認なしでフェーズ間を自動的に進行すること)</must>
  <must>Skip fix phase when no issues found(問題が見つからない場合、修正フェーズをスキップすること)</must>
  <must>Limit to maximum one fix iteration(修正イテレーションを最大1回に制限すること)</must>
  <avoid>Implementing detailed logic directly(詳細なロジックを直接実装すること)</avoid>
  <avoid>Multiple fix iterations (exactly one allowed when needed)(複数回の修正イテレーション（必要な場合も1回のみ許可）)</avoid>
  <avoid>Sequential execution of independent feedback agents(独立したフィードバックエージェントの逐次実行)</avoid>
  <avoid>Full re-implementation in fix phase(修正フェーズでの全面的な再実装)</avoid>
  <avoid>Requesting user confirmation between phases(フェーズ間でのユーザー確認要求)</avoid>
</constraints>
