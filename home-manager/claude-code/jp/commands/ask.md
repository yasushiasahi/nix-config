---
argument-hint: [question]
description: Question and inquiry command(質問・調査コマンド)
---

<purpose>
Provide accurate, evidence-based answers to project questions through fact-based investigation. Operates in read-only mode; never modifies files.(事実に基づく調査を通じて、プロジェクトに関する質問に正確でエビデンスベースの回答を提供する。読み取り専用モードで動作し、ファイルを変更しない。)
</purpose>

<refs>
  <skill use="patterns">core-patterns</skill>
  <skill use="workflow">investigation-patterns</skill>
  <skill use="workflow">fact-check</skill>
  <skill use="tools">serena-usage</skill>
  <skill use="tools">context7-usage</skill>
</refs>

<rules priority="critical">
  <rule>NEVER modify, create, or delete files(ファイルの変更、作成、削除を絶対に行わないこと)</rule>
  <rule>NEVER implement fixes; provide analysis and suggestions only(修正を実装せず、分析と提案のみを提供すること)</rule>
  <rule>ALWAYS base answers on factual investigation from code and documentation(常にコードとドキュメントからの事実調査に基づいて回答すること)</rule>
  <rule>ALWAYS report confidence levels and unclear points honestly(信頼度と不明点を常に正直に報告すること)</rule>
  <rule>NEVER justify user assumptions; prioritize technical accuracy(ユーザーの仮定を正当化せず、技術的正確性を優先すること)</rule>
</rules>

<rules priority="standard">
  <rule>Use investigation-patterns skill for systematic analysis(体系的な分析にinvestigation-patternsスキルを使用すること)</rule>
  <rule>Delegate to appropriate agents in parallel(適切なエージェントに並列で委譲すること)</rule>
  <rule>Provide file:line references for all findings(すべての発見にfile:line参照を提供すること)</rule>
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
    <objective>Understand the question and determine investigation scope(質問を理解し、調査範囲を決定する)</objective>
    <step>1. What is the user's core question?(ユーザーの核心的な質問は何か？)</step>
    <step>2. Which code/documentation sources are relevant?(どのコード・ドキュメントソースが関連するか？)</step>
    <step>3. What scope of investigation is appropriate?(適切な調査範囲はどの程度か？)</step>
    <step>4. Classify question type (architecture, implementation, debugging, design)(質問タイプを分類する（アーキテクチャ、実装、デバッグ、設計）)</step>
  </phase>
  <phase name="investigate">
    <objective>Gather evidence from codebase using parallel agent delegation(並列エージェント委譲を使用してコードベースからエビデンスを収集する)</objective>
    <step>1. Delegate to explore agent: find relevant files and codebase structure</step>
    <step>2. Delegate to design agent: evaluate architecture and component relationships</step>
    <step>3. Delegate to performance agent: identify performance-related aspects (if applicable)</step>
    <step>4. Use fact-check skill patterns: verify external references via Context7 and WebSearch</step>
  </phase>
  <reflection_checkpoint id="investigation_quality">
    <question>Have I gathered sufficient evidence from investigation?(調査から十分なエビデンスを収集したか？)</question>
    <question>Do findings from different agents align?(異なるエージェントの発見は一致しているか？)</question>
    <question>Are there conflicting signals that require deeper analysis?(より深い分析が必要な矛盾するシグナルはあるか？)</question>
    <threshold>If confidence less than 70, expand investigation scope or seek clarification</threshold>
    <serena_validation>
      <tool>think_about_collected_information</tool>
      <trigger>After investigation phase completes</trigger>
    </serena_validation>
  </reflection_checkpoint>
  <phase name="synthesize">
    <objective>Compile and verify findings with confidence metrics(信頼度メトリクスとともに発見を取りまとめ検証する)</objective>
    <step>1. Delegate to quality-assurance agent: evaluate code quality findings</step>
    <step>2. Delegate to code-quality agent: analyze complexity metrics</step>
    <step>3. Compile agent findings with confidence metrics</step>
  </phase>
  <reflection_checkpoint id="analysis_quality" inherits="workflow-patterns#reflection_checkpoint" />
  <phase name="failure_handling" inherits="workflow-patterns#failure_handling" />
  <phase name="self_evaluate">
    <objective>Brief quality assessment of answer output(回答出力の簡易品質評価)</objective>
    <step>1. Calculate confidence using decision_criteria: evidence_quality (50%), answer_completeness (30%), source_verification (20%)</step>
    <step>2. Identify top 1-2 critical issues if confidence below 80 or gaps detected</step>
    <step>3. Append self_feedback section to output</step>
  </phase>
</workflow>

<decision_criteria inherits="core-patterns#decision_criteria">
  <criterion name="confidence_calculation">
    <factor name="evidence_quality" weight="0.5">
      <score range="90-100">Direct code evidence found(直接的なコードエビデンスが見つかった)</score>
      <score range="70-89">Strong inference from code(コードからの強い推論)</score>
      <score range="50-69">Indirect evidence(間接的なエビデンス)</score>
      <score range="0-49">Speculation only(推測のみ)</score>
    </factor>
    <factor name="answer_completeness" weight="0.3">
      <score range="90-100">All aspects of question addressed(質問のすべての側面に対処)</score>
      <score range="70-89">Main question answered(主要な質問に回答)</score>
      <score range="50-69">Partial answer(部分的な回答)</score>
      <score range="0-49">Incomplete answer(不完全な回答)</score>
    </factor>
    <factor name="source_verification" weight="0.2">
      <score range="90-100">Multiple sources confirm answer(複数のソースが回答を確認)</score>
      <score range="70-89">Single reliable source(信頼できるソースが1つ)</score>
      <score range="50-69">Unverified source(未検証のソース)</score>
      <score range="0-49">No source cited(ソース引用なし)</score>
    </factor>
  </criterion>
</decision_criteria>

<agents>
  <agent name="explore" subagent_type="explore" readonly="true">Finding files, exploring codebase structure(ファイル検索、コードベース構造の探索)</agent>
  <agent name="design" subagent_type="design" readonly="true">System design, architecture, API structure(システム設計、アーキテクチャ、API構造)</agent>
  <agent name="performance" subagent_type="performance" readonly="true">Performance bottlenecks, optimization questions(パフォーマンスボトルネック、最適化に関する質問)</agent>
  <agent name="quality-assurance" subagent_type="quality-assurance" readonly="true">Code quality evaluation, best practices(コード品質評価、ベストプラクティス)</agent>
  <agent name="code-quality" subagent_type="code-quality" readonly="true">Code complexity analysis(コード複雑度分析)</agent>
</agents>

<execution_graph>
  <parallel_group id="investigation" depends_on="none">
    <agent>explore</agent>
    <agent>design</agent>
    <agent>performance</agent>
  </parallel_group>
  <parallel_group id="synthesis" depends_on="investigation">
    <agent>quality-assurance</agent>
    <agent>code-quality</agent>
  </parallel_group>
</execution_graph>

<output>
  <format>
    <question>Restate the user's question for confirmation</question>
    <investigation>Evidence-based findings with file:line references
- Source 1: `path/to/file.ts:42` - finding
- Source 2: `path/to/other.ts:15` - finding</investigation>
    <conclusion>Direct answer based on evidence</conclusion>
    <metrics>
- Confidence: 0-100 (based on evidence quality)
- Evidence Coverage: 0-100 (how much relevant code was examined)</metrics>
    <recommendations>Optional: Suggested actions without implementation</recommendations>
    <unclear_points>Information gaps that would improve the answer</unclear_points>
    <self_feedback>
      <confidence>XX/100 (based on evidence_quality)</confidence>
      <issues>
- [Critical] Issue description (if any, max 2 total)
- [Warning] Issue description (if any)
      </issues>
    </self_feedback>
  </format>
</output>

<enforcement>
  <mandatory_behaviors>
    <behavior id="ASK-B001" priority="critical">
      <trigger>When answering questions</trigger>
      <action>Cite specific file:line references(具体的なfile:line参照を引用する)</action>
      <verification>References included in answer</verification>
    </behavior>
    <behavior id="ASK-B002" priority="critical">
      <trigger>When uncertain</trigger>
      <action>Explicitly state uncertainty level(不確実性レベルを明示的に述べる)</action>
      <verification>Confidence level in output</verification>
    </behavior>
  </mandatory_behaviors>
  <prohibited_behaviors>
    <behavior id="ASK-P001" priority="critical">
      <trigger>Always</trigger>
      <action>Answering without code investigation(コード調査なしでの回答)</action>
      <response>Block answer, require investigation first(回答をブロックし、先に調査を要求する)</response>
    </behavior>
  </prohibited_behaviors>
</enforcement>

<error_escalation inherits="core-patterns#error_escalation">
  <examples>
    <example severity="low">Minor inconsistency in documentation or comments(ドキュメントやコメントの軽微な不整合)</example>
    <example severity="medium">Unclear code pattern or ambiguous architecture(不明確なコードパターンまたは曖昧なアーキテクチャ)</example>
    <example severity="high">Conflicting evidence about system behavior(システム動作に関する矛盾するエビデンス)</example>
    <example severity="critical">Potential security vulnerability or data integrity issue(潜在的なセキュリティ脆弱性またはデータ整合性の問題)</example>
  </examples>
</error_escalation>

<related_commands>
  <command name="bug">When investigating error-related questions(エラー関連の質問を調査する場合)</command>
  <command name="define">When question requires requirements clarification(質問が要件の明確化を必要とする場合)</command>
  <command name="execute">When answer leads to implementation needs(回答が実装の必要性につながる場合)</command>
</related_commands>

<related_skills>
  <skill name="investigation-patterns">Core skill for systematic evidence-based analysis(体系的なエビデンスベース分析のコアスキル)</skill>
  <skill name="serena-usage">Symbol-level search for efficient code navigation(効率的なコードナビゲーションのためのシンボルレベル検索)</skill>
  <skill name="context7-usage">Verify library documentation for accuracy(ライブラリドキュメントの正確性を検証する)</skill>
  <skill name="fact-check">External source verification using Context7 and WebSearch(Context7とWebSearchを使用した外部ソース検証)</skill>
</related_skills>

<constraints>
  <must>Keep all operations read-only(すべての操作を読み取り専用に保つこと)</must>
  <must>Provide file:line references for findings(発見にfile:line参照を提供すること)</must>
  <must>Report confidence levels honestly(信頼度を正直に報告すること)</must>
  <must>Distinguish between facts and inferences(事実と推論を区別すること)</must>
  <avoid>Implementing or modifying any code(コードの実装や変更)</avoid>
  <avoid>Guessing when evidence is insufficient(エビデンスが不十分な場合の推測)</avoid>
  <avoid>Confirming user assumptions without verification(検証なしでユーザーの仮定を確認すること)</avoid>
</constraints>
