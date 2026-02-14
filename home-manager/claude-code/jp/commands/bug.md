---
argument-hint: [error-message]
description: Root cause investigation command(根本原因調査コマンド)
---

<purpose>
Identify root causes from error messages and anomalous behavior, providing fact-based analysis without performing fixes.(エラーメッセージや異常な動作から根本原因を特定し、修正を行わずに事実に基づく分析を提供する。)
</purpose>

<refs>
  <skill use="patterns">core-patterns</skill>
  <skill use="workflow">investigation-patterns</skill>
  <skill use="workflow">fact-check</skill>
  <skill use="tools">serena-usage</skill>
  <skill use="tools">context7-usage</skill>
</refs>

<rules priority="critical">
  <rule>Never modify, create, or delete files(ファイルの変更、作成、削除を絶対に行わないこと)</rule>
  <rule>Never implement fixes; provide suggestions only(修正を実装せず、提案のみを提供すること)</rule>
  <rule>Prioritize log analysis as primary information source(ログ分析を主要な情報源として優先すること)</rule>
  <rule>Judge from facts, not user speculation(ユーザーの推測ではなく事実から判断すること)</rule>
  <rule>Logs as primary information source(ログを主要な情報源とすること)</rule>
</rules>

<rules priority="standard">
  <rule>Use investigation-patterns skill for debugging methodology(デバッグ方法論にinvestigation-patternsスキルを使用すること)</rule>
  <rule>Delegate investigations to debug agent(調査をデバッグエージェントに委譲すること)</rule>
  <rule>Report honestly if cause cannot be identified(原因が特定できない場合は正直に報告すること)</rule>
  <rule>Verify similar implementations nearby(近くの類似実装を確認すること)</rule>
  <rule>Track occurrence path chronologically(発生パスを時系列で追跡すること)</rule>
</rules>

<parallelization inherits="parallelization-patterns#parallelization_readonly" />

<workflow>
  <phase name="prepare">
    <objective>Initialize Serena and check existing patterns(Serenaを初期化し、既存パターンを確認する)</objective>
    <step>1. Activate Serena project with activate_project</step>
    <step>2. Check list_memories for relevant patterns</step>
    <step>3. Load applicable memories with read_memory</step>
  </phase>
  <phase name="analyze">
    <objective>Classify error type and establish investigation scope(エラータイプを分類し、調査範囲を確立する)</objective>
    <step>1. What type of error is this? (syntax, runtime, logic)(どのタイプのエラーか？（構文、ランタイム、ロジック）)</step>
    <step>2. Where does it occur? (file, line, function)(どこで発生するか？（ファイル、行、関数）)</step>
    <step>3. What logs are available?(どのログが利用可能か？)</step>
    <step>4. What is the error context? (before, during, after)(エラーのコンテキストは何か？（前、最中、後）)</step>
  </phase>
  <phase name="investigate">
    <objective>Delegate parallel investigations to specialized agents(専門エージェントに並列調査を委譲する)</objective>
    <step>1. Delegate to quality-assurance agent: analyze stack trace, error patterns</step>
    <step>2. Delegate to explore agent: find error location and related code paths</step>
    <step>3. Delegate to general-purpose agent: analyze logs and dependencies</step>
    <step>4. Use fact-check skill patterns: verify external documentation references via Context7</step>
    <step>5. Analyze error location details from agent findings(エージェントの発見からエラー位置の詳細を分析する)</step>
    <step>6. Review dependencies and imports(依存関係とインポートをレビューする)</step>
    <step>7. Check config files and recent changes(設定ファイルと最近の変更を確認する)</step>
  </phase>
  <reflection_checkpoint id="investigation_quality">
    <question>Have I built a complete evidence chain from symptom to cause?(症状から原因までの完全なエビデンスチェーンを構築したか？)</question>
    <question>Can I explain the error mechanism with concrete evidence?(具体的なエビデンスでエラーメカニズムを説明できるか？)</question>
    <threshold>If confidence less than 70, continue investigation or flag uncertainty</threshold>
    <serena_validation>
      <tool>think_about_collected_information</tool>
      <trigger>After investigation phase completes</trigger>
    </serena_validation>
  </reflection_checkpoint>
  <phase name="gather">
    <objective>Collect environmental context and runtime conditions(環境コンテキストとランタイム条件を収集する)</objective>
    <step>1. Collect runtime info (OS, versions, env vars)(ランタイム情報を収集する（OS、バージョン、環境変数）)</step>
    <step>2. Check resources (disk, memory, network)(リソースを確認する（ディスク、メモリ、ネットワーク）)</step>
  </phase>
  <reflection_checkpoint id="analysis_quality" inherits="workflow-patterns#reflection_checkpoint" />
  <phase name="failure_handling" inherits="workflow-patterns#failure_handling" />
  <phase name="report">
    <objective>Synthesize findings into actionable root cause analysis(発見を実行可能な根本原因分析にまとめる)</objective>
    <step>1. Compile agent findings with confidence metrics(信頼度メトリクスとともにエージェントの発見を取りまとめる)</step>
    <step>2. Identify root cause with supporting evidence(裏付けるエビデンスとともに根本原因を特定する)</step>
  </phase>
  <phase name="self_evaluate">
    <objective>Brief quality assessment of investigation output(調査出力の簡易品質評価)</objective>
    <step>1. Calculate confidence using decision_criteria: root_cause_certainty (50%), evidence_chain (30%), fix_viability (20%)</step>
    <step>2. Identify top 1-2 critical issues if confidence below 80 or evidence gaps detected</step>
    <step>3. Append self_feedback section to output</step>
  </phase>
</workflow>

<decision_criteria inherits="core-patterns#decision_criteria">
  <criterion name="confidence_calculation">
    <factor name="root_cause_certainty" weight="0.5">
      <score range="90-100">Root cause confirmed with reproduction(再現による根本原因の確認)</score>
      <score range="70-89">Likely root cause identified(根本原因の可能性を特定)</score>
      <score range="50-69">Possible causes identified(考えられる原因を特定)</score>
      <score range="0-49">Root cause unclear(根本原因が不明)</score>
    </factor>
    <factor name="evidence_chain" weight="0.3">
      <score range="90-100">Complete evidence chain from symptom to cause(症状から原因までの完全なエビデンスチェーン)</score>
      <score range="70-89">Strong evidence trail(強力なエビデンスの痕跡)</score>
      <score range="50-69">Partial evidence(部分的なエビデンス)</score>
      <score range="0-49">Weak evidence(弱いエビデンス)</score>
    </factor>
    <factor name="fix_viability" weight="0.2">
      <score range="90-100">Clear, tested fix available(明確でテスト済みの修正が利用可能)</score>
      <score range="70-89">Fix approach defined(修正アプローチが定義済み)</score>
      <score range="50-69">Possible fix identified(修正の可能性を特定)</score>
      <score range="0-49">No clear fix(明確な修正なし)</score>
    </factor>
  </criterion>
</decision_criteria>

<agents>
  <agent name="quality-assurance" subagent_type="quality-assurance" readonly="true">Error tracking, stack trace analysis, debugging(エラー追跡、スタックトレース分析、デバッグ)</agent>
  <agent name="general-purpose" subagent_type="general-purpose" readonly="true">Log analysis, observability, dependency errors(ログ分析、オブザーバビリティ、依存関係エラー)</agent>
  <agent name="explore" subagent_type="explore" readonly="true">Finding error locations, related code paths(エラー位置の特定、関連コードパス)</agent>
</agents>

<execution_graph>
  <parallel_group id="error_analysis" depends_on="none">
    <agent>quality-assurance</agent>
    <agent>explore</agent>
  </parallel_group>
  <parallel_group id="context_gathering" depends_on="none">
    <agent>general-purpose</agent>
  </parallel_group>
  <sequential_phase id="synthesis" depends_on="error_analysis,context_gathering">
    <agent>quality-assurance</agent>
    <reason>Requires findings from both error analysis and context gathering(エラー分析とコンテキスト収集の両方の発見が必要)</reason>
  </sequential_phase>
</execution_graph>

<delegation>
  <requirement>Full error message/stack trace(完全なエラーメッセージ/スタックトレース)</requirement>
  <requirement>Reproduction steps (if known)(再現手順（既知の場合）)</requirement>
  <requirement>Related file paths(関連ファイルパス)</requirement>
  <requirement>Explicit edit prohibition(明示的な編集禁止)</requirement>
</delegation>

<output>
  <format>
    <overview>Summary of error and investigation</overview>
    <log_analysis>Critical log information, error context</log_analysis>
    <code_analysis>Relevant code, identified issues</code_analysis>
    <root_cause>
- Direct cause
- Underlying cause
- Conditions</root_cause>
    <metrics>
- Confidence: 0-100
- Log Utilization: 0-100
- Objectivity: 0-100</metrics>
    <impact>Scope, similar errors</impact>
    <recommendations>Fix suggestions (no implementation), prevention</recommendations>
    <further_investigation>Unclear points, next steps</further_investigation>
    <self_feedback>
      <confidence>XX/100 (based on root_cause_certainty)</confidence>
      <issues>
- [Critical] Issue description (if any, max 2 total)
- [Warning] Issue description (if any)
      </issues>
    </self_feedback>
  </format>
</output>

<enforcement>
  <mandatory_behaviors>
    <behavior id="BUG-B001" priority="critical">
      <trigger>Before concluding root cause(根本原因を結論付ける前に)</trigger>
      <action>Build evidence chain from symptom to cause(症状から原因までのエビデンスチェーンを構築する)</action>
      <verification>Evidence chain in output</verification>
    </behavior>
    <behavior id="BUG-B002" priority="critical">
      <trigger>When proposing fix(修正を提案する場合)</trigger>
      <action>Identify all affected code paths(影響を受けるすべてのコードパスを特定する)</action>
      <verification>Impact analysis in output</verification>
    </behavior>
  </mandatory_behaviors>
  <prohibited_behaviors>
    <behavior id="BUG-P001" priority="critical">
      <trigger>Always</trigger>
      <action>Concluding without evidence(エビデンスなしでの結論)</action>
      <response>Block conclusion, require investigation(結論をブロックし、調査を要求する)</response>
    </behavior>
  </prohibited_behaviors>
</enforcement>

<error_escalation inherits="core-patterns#error_escalation">
  <examples>
    <example severity="low">Minor log warning without impact(影響のない軽微なログ警告)</example>
    <example severity="medium">Unclear error context or missing stack trace(不明確なエラーコンテキストまたはスタックトレースの欠如)</example>
    <example severity="high">System crash or data corruption detected(システムクラッシュまたはデータ破損を検出)</example>
    <example severity="critical">Security breach or critical data loss risk(セキュリティ侵害または重大なデータ損失リスク)</example>
  </examples>
</error_escalation>

<related_commands>
  <command name="ask">When investigation reveals architectural questions(調査でアーキテクチャに関する質問が判明した場合)</command>
  <command name="define">When bug fix requires requirements specification(バグ修正に要件仕様が必要な場合)</command>
  <command name="execute">When ready to implement fix after investigation(調査後に修正を実装する準備ができた場合)</command>
</related_commands>

<related_skills>
  <skill name="investigation-patterns">Core debugging methodology(コアデバッグ方法論)</skill>
  <skill name="serena-usage">Navigate error locations efficiently(エラー位置を効率的にナビゲートする)</skill>
  <skill name="testing-patterns">Understand test failures and coverage gaps(テスト失敗とカバレッジギャップを理解する)</skill>
  <skill name="fact-check">External source verification using Context7 and WebSearch(Context7とWebSearchを使用した外部ソース検証)</skill>
</related_skills>

<constraints>
  <must>Keep all operations read-only(すべての操作を読み取り専用に保つこと)</must>
  <must>Prioritize logs as primary information source(ログを主要な情報源として優先すること)</must>
  <must>Report honestly if cause cannot be identified(原因が特定できない場合は正直に報告すること)</must>
  <avoid>Implementing fixes(修正の実装)</avoid>
  <avoid>Accepting user speculation without verification(検証なしでユーザーの推測を受け入れること)</avoid>
  <avoid>Forcing contrived causes when evidence is insufficient(エビデンスが不十分な場合に無理に原因をこじつけること)</avoid>
</constraints>
