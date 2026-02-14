---
argument-hint: [previous-command]
description: Review command for Claude Code's recent work(Claude Codeの直近の作業に対するレビューコマンド)
---

<purpose>
Multi-faceted review of Claude Code's work within the same session, automatically selecting appropriate review mode and executing efficiently in parallel.(同一セッション内でのClaude Codeの作業に対する多面的レビュー。適切なレビューモードを自動選択し、並列で効率的に実行する。)
</purpose>

<refs>
  <skill use="patterns">core-patterns</skill>
  <skill use="workflow">execution-workflow</skill>
  <skill use="workflow">fact-check</skill>
  <skill use="tools">serena-usage</skill>
  <skill use="tools">context7-usage</skill>
</refs>

<rules priority="critical">
  <rule>Launch all Task tools simultaneously in one message (timeout avoidance)(タイムアウト回避のため、すべてのTaskツールを1メッセージで同時に起動すること)</rule>
  <rule>Auto-select mode based on previous command(前のコマンドに基づいてモードを自動選択すること)</rule>
  <rule>Review only changed code in execute mode, not existing issues(executeモードでは変更されたコードのみレビューし、既存の問題はレビューしないこと)</rule>
  <rule>Provide concrete fix proposals, not abstract theories(抽象的な理論ではなく、具体的な修正提案を提供すること)</rule>
</rules>

<rules priority="standard">
  <rule>Use execution-workflow skill for code review methodology(コードレビュー方法論にexecution-workflowスキルを使用すること)</rule>
  <rule>Check Serena memories for existing patterns(Serenaメモリで既存パターンを確認すること)</rule>
  <rule>Target session operations, not git diff(git diffではなくセッション操作を対象とすること)</rule>
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
    <objective>Determine review scope and appropriate mode selection(レビュー範囲と適切なモード選択を決定する)</objective>
    <step>1. What was the previous command? (/define, /execute, /bug, /ask, other)(前のコマンドは何か？（/define、/execute、/bug、/ask、その他）)</step>
    <step>2. What files/work need to be reviewed?(どのファイル・作業をレビューする必要があるか？)</step>
    <step>3. Which agents should run in parallel?(どのエージェントを並列実行すべきか？)</step>
    <step>4. What metrics are relevant for this mode?(このモードに関連するメトリクスは何か？)</step>
  </phase>
  <phase name="select">
    <objective>Select review mode and configure appropriate agents(レビューモードを選択し、適切なエージェントを設定する)</objective>
    <step>1. Determine mode based on previous command(前のコマンドに基づいてモードを決定する)</step>
    <step>2. After /define: Execution plan feedback(/define後：実行計画のフィードバック)</step>
    <step>3. After /execute: Work content feedback(/execute後：作業内容のフィードバック)</step>
    <step>4. After /bug: Investigation quality feedback(/bug後：調査品質のフィードバック)</step>
    <step>5. After /ask: Answer accuracy feedback(/ask後：回答精度のフィードバック)</step>
    <step>6. Other: Recent work feedback(その他：直近の作業のフィードバック)</step>
  </phase>
  <reflection_checkpoint id="analysis_quality" inherits="workflow-patterns#reflection_checkpoint" />
  <phase name="execute">
    <objective>Execute parallel review analysis across selected agents(選択されたエージェント間で並列レビュー分析を実行する)</objective>
    <step>1. Launch all agents in parallel(すべてのエージェントを並列で起動する)</step>
    <step>2. Collect agent results(エージェントの結果を収集する)</step>
  </phase>
  <reflection_checkpoint id="review_quality">
    <question>Did all agents complete successfully?(すべてのエージェントは正常に完了したか？)</question>
    <question>Is the feedback specific and actionable?(フィードバックは具体的で実行可能か？)</question>
    <question>Have I assigned priority levels to all issues?(すべての問題に優先度レベルを割り当てたか？)</question>
    <threshold>If confidence less than 70, gather additional context or re-run agents</threshold>
    <serena_validation>
      <tool>think_about_collected_information</tool>
      <trigger>After review agents complete</trigger>
    </serena_validation>
  </reflection_checkpoint>
  <phase name="failure_handling" inherits="workflow-patterns#failure_handling" />
  <phase name="synthesize">
    <objective>Compile comprehensive feedback report with actionable recommendations(実行可能な推奨事項を含む包括的なフィードバックレポートを作成する)</objective>
    <step>1. Compile feedback with metrics(メトリクスとともにフィードバックを取りまとめる)</step>
    <step>2. Generate actionable recommendations(実行可能な推奨事項を生成する)</step>
  </phase>
</workflow>

<decision_criteria inherits="core-patterns#decision_criteria">
  <criterion name="confidence_calculation">
    <factor name="review_depth" weight="0.4">
      <score range="90-100">All code paths and edge cases reviewed(すべてのコードパスとエッジケースをレビュー済み)</score>
      <score range="70-89">Main code paths reviewed(主要なコードパスをレビュー済み)</score>
      <score range="50-69">Surface level review(表面的なレビュー)</score>
      <score range="0-49">Minimal review(最小限のレビュー)</score>
    </factor>
    <factor name="feedback_actionability" weight="0.3">
      <score range="90-100">All feedback is specific and actionable(すべてのフィードバックが具体的で実行可能)</score>
      <score range="70-89">Most feedback actionable(ほとんどのフィードバックが実行可能)</score>
      <score range="50-69">Some vague feedback(一部曖昧なフィードバック)</score>
      <score range="0-49">Mostly vague feedback(ほとんど曖昧なフィードバック)</score>
    </factor>
    <factor name="issue_prioritization" weight="0.3">
      <score range="90-100">Clear priority levels with rationale(根拠付きの明確な優先度レベル)</score>
      <score range="70-89">Priority levels assigned(優先度レベルが割り当て済み)</score>
      <score range="50-69">Partial prioritization(部分的な優先度付け)</score>
      <score range="0-49">No prioritization(優先度付けなし)</score>
    </factor>
  </criterion>
</decision_criteria>

<modes>
  <mode name="define">
    <target>Execution plan from conversation history</target>
    <aspects>Step granularity, dependencies, risk identification, completeness, feasibility</aspects>
    <agents>
      <agent name="plan" subagent_type="Plan" readonly="true">Execution plan review(実行計画レビュー)</agent>
      <agent name="estimation" subagent_type="general-purpose" readonly="true">Estimation validity review(見積もり妥当性レビュー)</agent>
    </agents>
    <fact_check>Use fact-check skill patterns for external source verification via Context7</fact_check>
    <execution>All agents in parallel</execution>
  </mode>
  <mode name="execute">
    <target>Files modified via Edit/Write tools</target>
    <agents>
      <agent name="quality" subagent_type="quality-assurance" readonly="true">Naming, DRY, readability(命名、DRY、可読性)</agent>
      <agent name="security" subagent_type="security" readonly="true">OWASP Top 10, input validation, auth(OWASP Top 10、入力検証、認証)</agent>
      <agent name="design" subagent_type="design" readonly="true">Architecture consistency, patterns(アーキテクチャ整合性、パターン)</agent>
      <agent name="docs" subagent_type="docs" readonly="true">Accuracy, structure, completeness(正確性、構造、完全性)</agent>
      <agent name="performance" subagent_type="performance" readonly="true">Performance review(パフォーマンスレビュー)</agent>
      <agent name="test" subagent_type="test" readonly="true">Test coverage review(テストカバレッジレビュー)</agent>
    </agents>
    <fact_check>Use fact-check skill patterns for external source verification via Context7</fact_check>
    <execution>All agents in parallel</execution>
  </mode>
  <mode name="general">
    <target>Recent Claude Code work</target>
    <agents>
      <agent name="review" subagent_type="quality-assurance" readonly="true">Comprehensive work review(包括的な作業レビュー)</agent>
      <agent name="complexity" subagent_type="code-quality" readonly="true">Code complexity review(コード複雑度レビュー)</agent>
      <agent name="memory" subagent_type="general-purpose" readonly="true">Consistency check with existing patterns(既存パターンとの整合性チェック)</agent>
    </agents>
    <fact_check>Use fact-check skill patterns for external source verification via Context7</fact_check>
    <execution>All agents in parallel</execution>
  </mode>
  <mode name="bug">
    <target>Investigation results from conversation history</target>
    <aspects>Evidence collection, hypothesis validity, root cause accuracy, log utilization</aspects>
    <metrics>Confidence (0-100), Log Utilization (0-100), Objectivity (0-100)</metrics>
    <agents>
      <agent name="quality-assurance" subagent_type="quality-assurance" readonly="true">Investigation methodology evaluation(調査方法論の評価)</agent>
      <agent name="general-purpose" subagent_type="general-purpose" readonly="true">Log analysis and dependency investigation evaluation(ログ分析と依存関係調査の評価)</agent>
      <agent name="explore" subagent_type="explore" readonly="true">Code path coverage evaluation(コードパスカバレッジの評価)</agent>
    </agents>
    <fact_check>Use fact-check skill patterns for external source verification via Context7</fact_check>
    <execution>All agents in parallel</execution>
  </mode>
  <mode name="ask">
    <target>Answer and evidence from conversation history</target>
    <aspects>Evidence citation quality, conclusion validity, reference accuracy, confidence calibration</aspects>
    <metrics>Confidence (0-100), Evidence Coverage (0-100)</metrics>
    <note>Subset of ask.md agents focused on answer evaluation; design/performance agents omitted as they evaluate questions, not answers</note>
    <agents>
      <agent name="explore" subagent_type="explore" readonly="true">Evidence gathering evaluation(エビデンス収集の評価)</agent>
      <agent name="quality-assurance" subagent_type="quality-assurance" readonly="true">Answer accuracy assessment(回答精度の評価)</agent>
      <agent name="code-quality" subagent_type="code-quality" readonly="true">Reference precision and conclusion validity(参照精度と結論の妥当性)</agent>
    </agents>
    <fact_check>Use fact-check skill patterns for external source verification via Context7</fact_check>
    <execution>All agents in parallel</execution>
  </mode>
</modes>

<output>
  <format>
    <feedback_results mode="{Mode}">
      <evaluation_scores>
- {Metric1}: XX/100
- {Metric2}: XX/100
- Overall: XX/100</evaluation_scores>
      <critical>Immediate Fix Required
- [Category] Issue: Location
- Problem: Description
- Fix: Proposal</critical>
      <warning>Fix Recommended
- [Category] Issue: Location
- Problem: Description
- Recommendation: Proposal</warning>
      <good_practice>[Category] Commendable aspects</good_practice>
      <fact_check_results>
        <verified_claims>Claims confirmed against external sources (Context7, WebSearch)</verified_claims>
        <flagged_claims>Claims with verification confidence below 80
- Claim: {claim}
- Source referenced: {source}
- Verification result: {result}
- Confidence: {XX}/100
- Evidence: {evidence}
- Recommendation: {correction}</flagged_claims>
        <unverifiable_claims>Claims that could not be checked due to unavailable sources</unverifiable_claims>
      </fact_check_results>
      <recommended_actions>
- [High] Action
- [Medium] Action
- [Low] Action</recommended_actions>
    </feedback_results>
  </format>
</output>

<enforcement>
  <mandatory_behaviors>
    <behavior id="FB-B001" priority="critical">
      <trigger>When providing feedback</trigger>
      <action>Include specific file:line references(具体的なfile:line参照を含めること)</action>
      <verification>References in all feedback items</verification>
    </behavior>
    <behavior id="FB-B002" priority="critical">
      <trigger>When identifying issues</trigger>
      <action>Provide suggested improvements(改善提案を提供すること)</action>
      <verification>Suggestions for each issue</verification>
    </behavior>
  </mandatory_behaviors>
  <prohibited_behaviors>
    <behavior id="FB-P001" priority="critical">
      <trigger>Always</trigger>
      <action>Providing feedback without code analysis(コード分析なしでのフィードバック提供)</action>
      <response>Block feedback, require analysis first(フィードバックをブロックし、先に分析を要求する)</response>
    </behavior>
  </prohibited_behaviors>
</enforcement>

<error_escalation inherits="core-patterns#error_escalation">
  <examples>
    <low>Minor code quality issue in reviewed work(レビュー対象の作業における軽微なコード品質の問題)</low>
    <medium>Unclear quality metric or missing test coverage(不明確な品質メトリクスまたはテストカバレッジの欠如)</medium>
    <high>Critical security flaw or major design issue in reviewed work(レビュー対象の作業における重大なセキュリティ欠陥または主要な設計問題)</high>
    <critical>Data loss risk or security breach in reviewed work(レビュー対象の作業におけるデータ損失リスクまたはセキュリティ侵害)</critical>
  </examples>
</error_escalation>

<related_commands>
  <command name="execute">Primary target for feedback after implementation(実装後のフィードバックの主要対象)</command>
  <command name="define">Feedback on execution plans(実行計画に対するフィードバック)</command>
  <command name="bug">Feedback on investigation quality(調査品質に対するフィードバック)</command>
  <command name="ask">Feedback on answer accuracy(回答精度に対するフィードバック)</command>
  <command name="upstream">Review before submitting upstream PR(アップストリームPR提出前のレビュー)</command>
</related_commands>

<related_skills>
  <skill name="execution-workflow">Understanding work review methodology(作業レビュー方法論の理解)</skill>
  <skill name="investigation-patterns">Evaluating evidence quality in investigations(調査におけるエビデンス品質の評価)</skill>
  <skill name="testing-patterns">Assessing test coverage and quality(テストカバレッジと品質の評価)</skill>
  <skill name="fact-check">Verifying external source claims(外部ソースの主張を検証する)</skill>
</related_skills>

<constraints>
  <must>Launch all agents simultaneously (no sequential execution)(すべてのエージェントを同時に起動すること（逐次実行禁止）)</must>
  <must>Review only changed code in execute mode(executeモードでは変更されたコードのみレビューすること)</must>
  <must>Provide concrete, actionable feedback(具体的で実行可能なフィードバックを提供すること)</must>
  <avoid>Abstract theories without specific proposals(具体的な提案のない抽象的な理論)</avoid>
  <avoid>Reviewing existing code quality issues(既存のコード品質の問題のレビュー)</avoid>
  <avoid>Sequential agent execution (causes timeout)(エージェントの逐次実行（タイムアウトの原因）)</avoid>
</constraints>
