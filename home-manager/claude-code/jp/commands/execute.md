---
argument-hint: [task-description]
description: Task execution command(タスク実行コマンド)
---

<purpose>
Execute tasks by delegating detailed work to sub-agents while focusing on policy decisions and orchestration.(詳細な作業をサブエージェントに委譲しながら、方針決定と統括に集中してタスクを実行する。)
</purpose>

<refs>
  <skill use="patterns">core-patterns</skill>
  <skill use="workflow">execution-workflow</skill>
  <skill use="tools">serena-usage</skill>
  <skill use="tools">context7-usage</skill>
</refs>

<rules priority="critical">
  <rule>Delegate detailed work to specialized sub-agents(詳細な作業を専門サブエージェントに委譲すること)</rule>
  <rule>Focus on orchestration and policy decisions(統括と方針決定に集中すること)</rule>
  <rule>Execute independent tasks in parallel(独立したタスクを並列実行すること)</rule>
  <rule>Verify sub-agent outputs before integration(統合前にサブエージェントの出力を検証すること)</rule>
</rules>

<rules priority="standard">
  <rule>Use execution-workflow skill for delegation patterns(委譲パターンにはexecution-workflowスキルを使用すること)</rule>
  <rule>Check Serena memories before implementation(実装前にSerenaメモリを確認すること)</rule>
</rules>

<workflow>
  <phase name="prepare">
    <objective>Initialize Serena and check existing patterns(Serenaを初期化し、既存パターンを確認する)</objective>
    <step order="1">Activate Serena project with activate_project</step>
    <step order="2">Check list_memories for relevant patterns</step>
    <step order="3">Load applicable memories with read_memory</step>
  </phase>
  <phase name="analyze">
    <objective>Understand the task scope and identify required resources(タスクの範囲を理解し、必要なリソースを特定する)</objective>
    <step order="1">What tasks need to be done?(どのタスクを実行する必要があるか？)</step>
    <step order="2">Which sub-agents are best suited?(どのサブエージェントが最適か？)</step>
    <step order="3">Which tasks can run in parallel?(どのタスクを並列実行できるか？)</step>
    <step order="4">What dependencies exist between tasks?(タスク間にどのような依存関係があるか？)</step>
    <step order="5">What verification is needed?(どのような検証が必要か？)</step>
  </phase>
  <phase name="decompose">
    <objective>Break down complex tasks into manageable units(複雑なタスクを管理可能な単位に分解する)</objective>
    <step order="1">Split into manageable units(管理可能な単位に分割する)</step>
    <step order="2">Identify task boundaries(タスク境界を特定する)</step>
  </phase>
  <phase name="structure">
    <objective>Organize tasks for optimal execution(最適な実行のためにタスクを整理する)</objective>
    <step order="1">Identify parallel vs sequential tasks(並列タスクと逐次タスクを特定する)</step>
    <step order="2">Define task dependencies(タスクの依存関係を定義する)</step>
  </phase>
  <reflection_checkpoint id="analysis_quality" inherits="workflow-patterns#reflection_checkpoint" />
  <phase name="assign">
    <objective>Delegate tasks to appropriate sub-agents with clear instructions(適切なサブエージェントに明確な指示でタスクを委譲する)</objective>
    <step order="1">Delegate tasks with detailed instructions(詳細な指示でタスクを委譲する)</step>
    <step order="2">Provide context and constraints(コンテキストと制約を提供する)</step>
  </phase>
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
  <phase name="failure_handling" inherits="workflow-patterns#failure_handling" />
  <phase name="consolidate">
    <objective>Integrate sub-agent outputs into cohesive result(サブエージェントの出力を統合的な結果にまとめる)</objective>
    <step order="1">Verify sub-agent outputs(サブエージェントの出力を検証する)</step>
    <step order="2">Combine results(結果を統合する)</step>
  </phase>
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
</agents>

<execution_graph>
  <parallel_group id="quality_assurance" depends_on="none">
    <agent>quality</agent>
    <agent>security</agent>
  </parallel_group>
  <parallel_group id="implementation" depends_on="none">
    <agent>test</agent>
    <agent>docs</agent>
  </parallel_group>
  <sequential_phase id="review_phase" depends_on="quality_assurance,implementation">
    <agent>review</agent>
    <reason>Requires completion of quality checks and implementation</reason>
  </sequential_phase>
</execution_graph>

<delegation>
  <requirement>Specific scope and expected deliverables(具体的なスコープと期待される成果物)</requirement>
  <requirement>Target file paths(対象ファイルパス)</requirement>
  <requirement>Reference implementations (specific paths)(参照実装（具体的なパス）)</requirement>
  <requirement>Memory check: `list_memories` for patterns(メモリ確認：パターン用の`list_memories`)</requirement>
</delegation>

<parallelization inherits="parallelization-patterns#parallelization_orchestration" />

<decision_criteria inherits="core-patterns#decision_criteria">
  <criterion name="confidence_calculation">
    <factor name="task_clarity" weight="0.3">
      <score range="90-100">Clear requirements with acceptance criteria(受け入れ基準付きの明確な要件)</score>
      <score range="70-89">Clear requirements(明確な要件)</score>
      <score range="50-69">Some ambiguity(若干の曖昧さ)</score>
      <score range="0-49">Unclear requirements(不明確な要件)</score>
    </factor>
    <factor name="implementation_quality" weight="0.4">
      <score range="90-100">All tests pass, code reviewed(全テスト合格、コードレビュー済み)</score>
      <score range="70-89">Tests pass(テスト合格)</score>
      <score range="50-69">Some issues remain(一部問題が残存)</score>
      <score range="0-49">Major issues(重大な問題)</score>
    </factor>
    <factor name="verification_completeness" weight="0.3">
      <score range="90-100">Full verification by sub-agents(サブエージェントによる完全な検証)</score>
      <score range="70-89">Core verification done(コア検証完了)</score>
      <score range="50-69">Partial verification(部分的な検証)</score>
      <score range="0-49">Minimal verification(最小限の検証)</score>
    </factor>
  </criterion>
  <validation_tests>
    <test name="success_case">
      <input>task_clarity=95, implementation_quality=90, verification_completeness=90</input>
      <calculation>(95*0.3)+(90*0.4)+(90*0.3) = 91.5</calculation>
      <expected_status>success</expected_status>
      <reasoning>High scores across all factors yield success(すべての要素で高スコアのため成功)</reasoning>
    </test>
    <test name="boundary_success_80">
      <input>task_clarity=80, implementation_quality=80, verification_completeness=80</input>
      <calculation>(80*0.3)+(80*0.4)+(80*0.3) = 80</calculation>
      <expected_status>success</expected_status>
      <reasoning>Exactly 80 is success threshold(80は成功閾値ちょうど)</reasoning>
    </test>
    <test name="boundary_warning_79">
      <input>task_clarity=79, implementation_quality=79, verification_completeness=79</input>
      <calculation>(79*0.3)+(79*0.4)+(79*0.3) = 79</calculation>
      <expected_status>warning</expected_status>
      <reasoning>79 is below success threshold(79は成功閾値を下回る)</reasoning>
    </test>
    <test name="boundary_error_59">
      <input>task_clarity=59, implementation_quality=59, verification_completeness=59</input>
      <calculation>(59*0.3)+(59*0.4)+(59*0.3) = 59</calculation>
      <expected_status>error</expected_status>
      <reasoning>59 is at error threshold(59はエラー閾値)</reasoning>
    </test>
    <test name="error_case">
      <input>task_clarity=40, implementation_quality=50, verification_completeness=45</input>
      <calculation>(40*0.3)+(50*0.4)+(45*0.3) = 45.5</calculation>
      <expected_status>error</expected_status>
      <reasoning>Low scores yield error status(低スコアのためエラーステータス)</reasoning>
    </test>
  </validation_tests>
</decision_criteria>

<enforcement>
  <mandatory_behaviors>
    <behavior id="EXEC-B001" priority="critical">
      <trigger>Before implementation</trigger>
      <action>Check Serena memories for existing patterns(既存パターンのためにSerenaメモリを確認する)</action>
      <verification>Pattern check in output</verification>
    </behavior>
    <behavior id="EXEC-B002" priority="critical">
      <trigger>After implementation</trigger>
      <action>Delegate verification to quality and security agents(品質およびセキュリティエージェントに検証を委譲する)</action>
      <verification>Agent reports in output</verification>
    </behavior>
  </mandatory_behaviors>
  <prohibited_behaviors>
    <behavior id="EXEC-P001" priority="critical">
      <trigger>Always</trigger>
      <action>Implementing without sub-agent delegation(サブエージェント委譲なしでの実装)</action>
      <response>Block operation, delegate to specialized agents(操作をブロックし、専門エージェントに委譲する)</response>
    </behavior>
  </prohibited_behaviors>
</enforcement>

<error_escalation inherits="core-patterns#error_escalation">
  <examples>
    <example severity="low">Minor code style inconsistency(軽微なコードスタイルの不整合)</example>
    <example severity="medium">Test failure or unclear implementation approach(テスト失敗または不明確な実装アプローチ)</example>
    <example severity="high">Breaking change or major implementation blocker(破壊的変更または重大な実装ブロッカー)</example>
    <example severity="critical">Security vulnerability or data loss risk(セキュリティ脆弱性またはデータ損失リスク)</example>
  </examples>
</error_escalation>

<related_commands>
  <command name="define">When implementation reveals unclear requirements(実装で不明確な要件が判明した場合)</command>
  <command name="ask">When implementation requires investigation(実装に調査が必要な場合)</command>
  <command name="bug">When implementation encounters unexpected errors(実装で予期しないエラーが発生した場合)</command>
  <command name="feedback">Review work after execution completion(実行完了後の作業レビュー)</command>
  <command name="upstream">When preparing changes for upstream OSS contribution(アップストリームOSSコントリビューションの変更を準備する場合)</command>
  <command name="execute-full">Full version with feedback loop and fix phase(フィードバックループと修正フェーズ付きのフルバージョン)</command>
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
  <avoid>Implementing detailed logic directly(詳細なロジックを直接実装すること)</avoid>
  <avoid>Unnecessary comments about past implementations(過去の実装に関する不要なコメント)</avoid>
</constraints>
