---
argument-hint: [file-path]
description: Markdown text update command(Markdownテキスト更新コマンド)
---

<purpose>
Output results from other commands (/define, /ask, /bug, etc.) as markdown files.(他のコマンド（/define、/ask、/bugなど）の結果をMarkdownファイルとして出力する。)
</purpose>

<refs>
  <skill use="patterns">core-patterns</skill>
  <skill use="domain">technical-documentation</skill>
  <skill use="tools">serena-usage</skill>
</refs>

<rules priority="critical">
  <rule>Retrieve previous command execution results(前のコマンド実行結果を取得すること)</rule>
  <rule>Determine output filename based on context(コンテキストに基づいて出力ファイル名を決定すること)</rule>
  <rule>Use specified file path if provided(指定されたファイルパスがあればそれを使用すること)</rule>
  <rule>Never include revision history or discussion process(改訂履歴や議論の過程を含めないこと)</rule>
</rules>

<parallelization inherits="parallelization-patterns#parallelization_execution" />

<decision_criteria inherits="core-patterns#decision_criteria">
  <criterion name="confidence_calculation">
    <factor name="content_accuracy" weight="0.4">
      <score range="90-100">All content verified against source(すべてのコンテンツがソースに対して検証済み)</score>
      <score range="70-89">Core content verified(コアコンテンツが検証済み)</score>
      <score range="50-69">Partial verification(部分的な検証)</score>
      <score range="0-49">Unverified content(未検証のコンテンツ)</score>
    </factor>
    <factor name="structure_quality" weight="0.3">
      <score range="90-100">Clear hierarchy, proper formatting(明確な階層、適切なフォーマット)</score>
      <score range="70-89">Good structure(良好な構造)</score>
      <score range="50-69">Basic structure(基本的な構造)</score>
      <score range="0-49">Poor structure(不十分な構造)</score>
    </factor>
    <factor name="completeness" weight="0.3">
      <score range="90-100">All requested content included(要求されたすべてのコンテンツが含まれている)</score>
      <score range="70-89">Main content included(主要なコンテンツが含まれている)</score>
      <score range="50-69">Partial content(部分的なコンテンツ)</score>
      <score range="0-49">Incomplete(不完全)</score>
    </factor>
  </criterion>
</decision_criteria>

<workflow>
  <phase name="prepare">
    <objective>Initialize Serena and check existing patterns(Serenaを初期化し、既存パターンを確認する)</objective>
    <step>1. Activate Serena project with activate_project</step>
    <step>2. Check list_memories for documentation patterns</step>
    <step>3. Load applicable memories with read_memory</step>
  </phase>
  <phase name="analyze">
    <objective>Understand previous command output and context(前のコマンド出力とコンテキストを理解する)</objective>
    <step>1. What was the previous command?(前のコマンドは何か？)</step>
    <step>2. What is the appropriate output file?(適切な出力ファイルは何か？)</step>
    <step>3. Was a specific file path provided?(特定のファイルパスが指定されたか？)</step>
    <step>4. What content should be included/excluded?(どのコンテンツを含める/除外すべきか？)</step>
  </phase>
  <reflection_checkpoint id="analyze_quality">
    <question>Have I correctly identified the previous command and its output?(前のコマンドとその出力を正しく特定したか？)</question>
    <question>Do I understand what content needs to be documented?(ドキュメント化すべきコンテンツを理解しているか？)</question>
    <threshold>If confidence less than 70, seek more evidence or ask user</threshold>
    <serena_validation>
      <tool>think_about_collected_information</tool>
      <trigger>After analyze phase completes</trigger>
    </serena_validation>
  </reflection_checkpoint>
  <phase name="gather">
    <objective>Retrieve all relevant information for documentation(ドキュメント化に必要なすべての関連情報を取得する)</objective>
    <step>1. Retrieve previous command results(前のコマンド結果を取得する)</step>
    <step>2. Collect relevant context(関連コンテキストを収集する)</step>
  </phase>
  <reflection_checkpoint id="analysis_quality" inherits="workflow-patterns#reflection_checkpoint" />
  <phase name="determine">
    <objective>Decide on output file location and structure(出力ファイルの場所と構造を決定する)</objective>
    <step>1. Determine output filename based on command type(コマンドタイプに基づいて出力ファイル名を決定する)</step>
    <step>2. Check if user specified file path(ユーザーがファイルパスを指定したか確認する)</step>
  </phase>
  <phase name="failure_handling" inherits="workflow-patterns#failure_handling" />
  <phase name="execute">
    <objective>Write the documentation to file(ドキュメントをファイルに書き込む)</objective>
    <step>1. Write file using Write/Edit tool</step>
    <step>2. Verify output format(出力フォーマットを検証する)</step>
  </phase>
</workflow>

<agents>
  <agent name="docs" subagent_type="docs" readonly="false">Documentation management(ドキュメント管理)</agent>
  <agent name="memory" subagent_type="general-purpose" readonly="false">Knowledge base recording to Serena memory(Serenaメモリへのナレッジベース記録)</agent>
</agents>

<execution_graph>
  <sequential_phase id="output" depends_on="none">
    <agent>docs</agent>
    <reason>Creates markdown file first(まずMarkdownファイルを作成する)</reason>
  </sequential_phase>
  <sequential_phase id="memory_recording" depends_on="output">
    <agent>memory</agent>
    <reason>Records to knowledge base after file creation(ファイル作成後にナレッジベースに記録する)</reason>
  </sequential_phase>
</execution_graph>

<output>
  <format>
    <markdown_file>
      <header>Title based on command output</header>
      <content>Cleaned, formatted output from previous command</content>
      <footer>Optional: Related references</footer>
    </markdown_file>
  </format>
</output>

<enforcement>
  <mandatory_behaviors>
    <behavior id="MD-B001" priority="critical">
      <trigger>Before writing documentation(ドキュメント作成前に)</trigger>
      <action>Understand the source material(ソース素材を理解する)</action>
      <verification>Source analysis in output</verification>
    </behavior>
    <behavior id="MD-B002" priority="critical">
      <trigger>When including code examples(コード例を含める場合)</trigger>
      <action>Verify examples are correct and runnable(例が正しく実行可能であることを検証する)</action>
      <verification>Example validation noted</verification>
    </behavior>
  </mandatory_behaviors>
  <prohibited_behaviors>
    <behavior id="MD-P001" priority="critical">
      <trigger>Always</trigger>
      <action>Adding timestamps to documents(ドキュメントへのタイムスタンプの追加)</action>
      <response>Block operation, timestamps are prohibited(操作をブロック、タイムスタンプは禁止)</response>
    </behavior>
  </prohibited_behaviors>
</enforcement>

<error_escalation inherits="core-patterns#error_escalation">
  <examples>
    <example severity="low">Minor formatting inconsistency in output(出力の軽微なフォーマットの不整合)</example>
    <example severity="medium">Unclear output destination or ambiguous file mapping(不明確な出力先または曖昧なファイルマッピング)</example>
    <example severity="high">File path conflict or overwrite risk(ファイルパスの競合または上書きリスク)</example>
    <example severity="critical">Risk of overwriting critical documentation(重要なドキュメントの上書きリスク)</example>
  </examples>
</error_escalation>

<related_commands>
  <command name="define">Primary source for EXECUTION.md output(EXECUTION.md出力の主要ソース)</command>
  <command name="ask">Primary source for RESEARCH.md output(RESEARCH.md出力の主要ソース)</command>
  <command name="bug">Primary source for RESEARCH.md output(RESEARCH.md出力の主要ソース)</command>
</related_commands>

<related_skills>
  <skill name="technical-documentation">Formatting and structuring markdown output(Markdown出力のフォーマットと構造化)</skill>
  <skill name="serena-usage">Recording knowledge to memory when appropriate(適切な場合にメモリにナレッジを記録する)</skill>
</related_skills>

<file_mapping>
  <default_output_dir>project root</default_output_dir>
  <mapping command="/define" output="EXECUTION.md" />
  <mapping command="/ask" output="RESEARCH.md" />
  <mapping command="/bug" output="RESEARCH.md" />
  <mapping command="other" output="MEMO.md" />
  <note>User-specified file path takes precedence(ユーザー指定のファイルパスが優先される)</note>
</file_mapping>

<constraints>
  <must>Use context-appropriate filename(コンテキストに適したファイル名を使用すること)</must>
  <must>Respect user-specified file path(ユーザー指定のファイルパスを尊重すること)</must>
  <avoid>Including revision history/change logs(改訂履歴/変更ログの含有)</avoid>
  <avoid>Including consideration process/discussion history(検討過程/議論の履歴の含有)</avoid>
</constraints>
