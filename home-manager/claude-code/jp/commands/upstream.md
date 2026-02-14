---
argument-hint: [upstream-url]
description: Upstream PR preparation and review command(アップストリームPR準備・レビューコマンド)
---

<purpose>
Review and prepare changes before submitting PRs to upstream OSS repositories, auto-fetching contribution guidelines, analyzing code changes, evaluating tests, and generating compliant PR metadata.(アップストリームOSSリポジトリへのPR提出前に変更をレビュー・準備し、コントリビューションガイドラインを自動取得し、コード変更を分析し、テストを評価し、準拠したPRメタデータを生成する。)
</purpose>

<refs>
  <skill use="patterns">core-patterns</skill>
  <skill use="workflow">fact-check</skill>
  <skill use="tools">serena-usage</skill>
  <skill use="tools">context7-usage</skill>
  <skill use="ecosystem">devenv-ecosystem</skill>
</refs>

<rules priority="critical">
  <rule>Read-only operation: analyze and report only, no file modifications(読み取り専用操作：分析とレポートのみ、ファイル変更なし)</rule>
  <rule>Auto-fetch CONTRIBUTING.md from upstream with fallback hierarchy (root, .github/, docs/)(アップストリームからCONTRIBUTING.mdをフォールバック階層で自動取得（root、.github/、docs/）)</rule>
  <rule>Launch all gather-phase agents in parallel(gatherフェーズのすべてのエージェントを並列で起動すること)</rule>
  <rule>Verify gh CLI authentication before PR history operations(PR履歴操作前にgh CLI認証を確認すること)</rule>
</rules>

<rules priority="standard">
  <rule>Use gh CLI for all GitHub API operations(すべてのGitHub API操作にgh CLIを使用すること)</rule>
  <rule>Check Serena memories for existing contribution patterns(既存のコントリビューションパターンについてSerenaメモリを確認すること)</rule>
  <rule>Provide structured checklist output with actionable items(実行可能な項目を含む構造化チェックリスト出力を提供すること)</rule>
  <rule>Include comprehensive local reproduction steps with Nix-first ecosystem detection(Nix優先のエコシステム検出を含む包括的なローカル再現手順を含めること)</rule>
  <rule>Always include a (Recommended) option when presenting choices via AskUserQuestion(AskUserQuestionで選択肢を提示する際は常に(Recommended)オプションを含めること)</rule>
</rules>

<parallelization inherits="parallelization-patterns#parallelization_readonly" />

<workflow>
  <phase name="preflight">
    <objective>Verify environment and detect upstream repository(環境を確認し、アップストリームリポジトリを検出する)</objective>
    <step order="1">
      <action>Check Serena memories for contribution patterns of upstream repo(アップストリームリポジトリのコントリビューションパターンについてSerenaメモリを確認する)</action>
      <tool>Serena list_memories, read_memory</tool>
      <output>Relevant patterns and past contribution experiences(関連パターンと過去のコントリビューション経験)</output>
    </step>
    <step order="2">
      <action>Verify gh CLI authentication status(gh CLI認証状態を確認する)</action>
      <tool>Bash: gh auth status</tool>
      <output>Authentication confirmation or error(認証確認またはエラー)</output>
    </step>
    <step order="3">
      <action>Detect upstream repository from git remotes(gitリモートからアップストリームリポジトリを検出する)</action>
      <tool>Bash: git remote -v</tool>
      <output>Upstream URL (prefer upstream remote, fallback to origin)(アップストリームURL（upstreamリモート優先、originにフォールバック）)</output>
    </step>
    <step order="4">
      <action>If multiple remotes or detection confidence below 80, ask user(複数のリモートまたは検出信頼度が80未満の場合、ユーザーに確認する)</action>
      <tool>AskUserQuestion</tool>
      <output>Confirmed upstream URL(確認済みアップストリームURL)</output>
    </step>
    <step order="5">
      <action>Get current branch and pending changes(現在のブランチと保留中の変更を取得する)</action>
      <tool>Bash: git status, git diff</tool>
      <output>Branch name, change summary(ブランチ名、変更サマリー)</output>
    </step>
    <step order="6">
      <action>Compare local branch with upstream default branch(ローカルブランチとアップストリームのデフォルトブランチを比較する)</action>
      <tool>Bash: git diff upstream/main...HEAD --stat</tool>
      <output>Summary of divergent changes(分岐した変更のサマリー)</output>
    </step>
  </phase>
  <reflection_checkpoint id="preflight_complete" after="preflight">
    <questions>
      <question weight="0.4">Is gh CLI authenticated?(gh CLIは認証されているか？)</question>
      <question weight="0.3">Is upstream repository clearly identified?(アップストリームリポジトリは明確に特定されているか？)</question>
      <question weight="0.3">Are there changes to review?(レビューすべき変更があるか？)</question>
    </questions>
    <threshold min="70" action="stop">
      <below_threshold>Stop and report to user(停止してユーザーに報告する)</below_threshold>
    </threshold>
  </reflection_checkpoint>
  <phase name="gather">
    <objective>Collect all necessary information in parallel(必要なすべての情報を並列で収集する)</objective>
    <step order="1">
      <action>Fetch CONTRIBUTING.md from upstream(アップストリームからCONTRIBUTING.mdを取得する)</action>
      <tool>guidelines agent (WebFetch with fallback: root, .github/, docs/)</tool>
      <output>Contribution guidelines content(コントリビューションガイドラインの内容)</output>
    </step>
    <step order="2">
      <action>Fetch .github/PULL_REQUEST_TEMPLATE.md from upstream(アップストリームから.github/PULL_REQUEST_TEMPLATE.mdを取得する)</action>
      <tool>pr_template agent (WebFetch: https://raw.githubusercontent.com/{owner}/{repo}/{default_branch}/.github/PULL_REQUEST_TEMPLATE.md)</tool>
      <output>PR template structure with required sections, or null if not found(必須セクション付きPRテンプレート構造、見つからない場合はnull)</output>
    </step>
    <step order="3">
      <action>Analyze code changes against upstream patterns(アップストリームパターンに対してコード変更を分析する)</action>
      <tool>changes agent (quality-assurance)</tool>
      <output>Code quality assessment(コード品質評価)</output>
    </step>
    <step order="4">
      <action>Evaluate test coverage and appropriateness(テストカバレッジと適切性を評価する)</action>
      <tool>tests agent</tool>
      <output>Test evaluation report(テスト評価レポート)</output>
    </step>
    <step order="5">
      <action>Sample 10 recently merged PRs from upstream for pattern learning(パターン学習のためにアップストリームから最近マージされた10件のPRをサンプリングする)</action>
      <tool>pr_samples agent (gh pr list --repo {owner}/{repo} --state merged --limit 10 --json title,body,number,author)</tool>
      <output>PR title patterns, description structure, common sections(PRタイトルパターン、説明構造、共通セクション)</output>
    </step>
  </phase>
  <reflection_checkpoint id="gather_complete" after="gather">
    <questions>
      <question weight="0.3">Were contribution guidelines successfully fetched?(コントリビューションガイドラインは正常に取得されたか？)</question>
      <question weight="0.2">Was PR template fetched or confirmed absent?(PRテンプレートは取得されたか、不在が確認されたか？)</question>
      <question weight="0.25">Have code changes been analyzed?(コード変更は分析されたか？)</question>
      <question weight="0.25">Were PR samples retrieved for pattern learning?(パターン学習用のPRサンプルは取得されたか？)</question>
    </questions>
    <threshold min="70" action="proceed">
      <below_threshold>Document gaps and proceed with available data(ギャップを文書化し、利用可能なデータで進行する)</below_threshold>
    </threshold>
    <serena_validation>
      <tool>think_about_collected_information</tool>
      <trigger>After gather phase completes</trigger>
    </serena_validation>
  </reflection_checkpoint>
  <phase name="synthesize">
    <objective>Generate PR metadata, verification steps, and comprehensive task breakdown(PRメタデータ、検証手順、包括的なタスク分解を生成する)</objective>
    <step order="1">
      <action>Generate PR title and description: use PR template sections if available; otherwise derive structure from 10 sampled merged PR patterns(PRタイトルと説明を生成：PRテンプレートセクションが利用可能な場合はそれを使用、そうでなければ10件のサンプリングされたマージ済みPRパターンから構造を導出する)</action>
      <tool>metadata agent with pr_template output (if found) and pr_samples patterns as fallback</tool>
      <output>Template-compliant PR metadata; template_source indicates whether upstream_template, sampled_patterns, or none was used(テンプレート準拠PRメタデータ；template_sourceはupstream_template、sampled_patterns、noneのいずれが使用されたかを示す)</output>
    </step>
    <step order="2">
      <action>Detect project ecosystem and generate local reproduction steps(プロジェクトエコシステムを検出し、ローカル再現手順を生成する)</action>
      <tool>Analyze flake.nix, Makefile, Cargo.toml, go.mod, package.json with Nix-first priority</tool>
      <output>Ecosystem detection, environment setup, service dependencies, verification commands(エコシステム検出、環境セットアップ、サービス依存関係、検証コマンド)</output>
    </step>
    <step order="3">
      <action>Detect change types and generate context-injected manual QA checklist(変更タイプを検出し、コンテキスト注入された手動QAチェックリストを生成する)</action>
      <tool>Analyze diff for UI components, API endpoints, database migrations, config changes, security files, integration points using detection_rules</tool>
      <output>Change type detection (ui, api, database, config, security, integration) with actual paths, endpoints, and component names injected into qa_step commands(変更タイプ検出（ui、api、database、config、security、integration）と実際のパス、エンドポイント、コンポーネント名がqa_stepコマンドに注入される)</output>
    </step>
    <step order="4">
      <action>Compile checklist with all findings(すべての発見をチェックリストにまとめる)</action>
      <tool>Consolidate agent outputs</tool>
      <output>Structured checklist report(構造化チェックリストレポート)</output>
    </step>
    <step order="5">
      <action>Generate comprehensive task breakdown for /execute handoff(/executeへの引き渡しのための包括的なタスク分解を生成する)</action>
      <tool>Categorize all identified issues into phased_tasks phases (code_fixes, test_updates, documentation, commit_prep, final_verification)</tool>
      <output>Phased task list with dependencies using ID format: CF-XXX, TU-XXX, DOC-XXX, GIT-XXX, VER-XXX(依存関係付きフェーズ分けタスクリスト、IDフォーマット：CF-XXX、TU-XXX、DOC-XXX、GIT-XXX、VER-XXX)</output>
    </step>
    <step order="6">
      <action>Build dependency graph for parallel execution optimization(並列実行最適化のための依存関係グラフを構築する)</action>
      <tool>Analyze task dependencies to identify parallel-safe phases</tool>
      <output>Dependency graph with parallel groups(並列グループ付き依存関係グラフ)</output>
    </step>
    <step order="7">
      <action>Compile execute_handoff section with decisions, references, and constraints(決定事項、参照、制約を含むexecute_handoffセクションをまとめる)</action>
      <tool>Consolidate contribution guidelines, code patterns, and past feedback into actionable references</tool>
      <output>Complete execute_handoff for /execute command consumption(/executeコマンド使用のための完全なexecute_handoff)</output>
    </step>
  </phase>
  <phase name="self_evaluate">
    <objective>Brief quality assessment of review output(レビュー出力の簡易品質評価)</objective>
    <step order="1">
      <action>Cross-validate guideline compliance with code review findings(ガイドライン準拠性をコードレビューの発見とクロスバリデーションする)</action>
      <tool>validator agent</tool>
      <output>Validation report with consistency check(整合性チェック付きバリデーションレポート)</output>
    </step>
    <step order="2">
      <action>Calculate confidence using decision_criteria: guideline_compliance (40%), code_quality (30%), test_coverage (30%)</action>
      <tool>Decision criteria evaluation</tool>
      <output>Confidence score(信頼度スコア)</output>
    </step>
    <step order="3">
      <action>Identify top 1-2 critical issues if confidence below 80 or review gaps detected(信頼度が80未満またはレビューギャップが検出された場合、上位1-2個の重大な問題を特定する)</action>
      <tool>Gap analysis</tool>
      <output>Issue list(問題リスト)</output>
    </step>
    <step order="4">
      <action>Append self_feedback section to output(出力にself_feedbackセクションを追加する)</action>
      <tool>Output formatting</tool>
      <output>Self-feedback section(セルフフィードバックセクション)</output>
    </step>
  </phase>
  <phase name="failure_handling" inherits="workflow-patterns#failure_handling" />
</workflow>

<decision_criteria inherits="core-patterns#decision_criteria">
  <criterion name="confidence_calculation">
    <factor name="guideline_compliance" weight="0.4">
      <score range="90-100">All contribution guidelines verified and followed(すべてのコントリビューションガイドラインが検証され遵守されている)</score>
      <score range="70-89">Core guidelines followed, minor gaps(コアガイドラインが遵守され、軽微なギャップ)</score>
      <score range="50-69">Some guidelines unclear or not followed(一部のガイドラインが不明確または未遵守)</score>
      <score range="0-49">Major guideline violations(重大なガイドライン違反)</score>
    </factor>
    <factor name="code_quality" weight="0.3">
      <score range="90-100">Code review passed, patterns consistent(コードレビュー合格、パターンが一貫している)</score>
      <score range="70-89">Minor style issues only(軽微なスタイルの問題のみ)</score>
      <score range="50-69">Several quality issues found(複数の品質問題が発見された)</score>
      <score range="0-49">Major quality issues(重大な品質問題)</score>
    </factor>
    <factor name="test_coverage" weight="0.3">
      <score range="90-100">Tests appropriate and comprehensive(テストが適切で包括的)</score>
      <score range="70-89">Tests present and adequate(テストが存在し適切)</score>
      <score range="50-69">Tests incomplete or unclear(テストが不完全または不明確)</score>
      <score range="0-49">Tests missing or failing(テストが欠落または失敗)</score>
    </factor>
  </criterion>
</decision_criteria>

<agents>
  <agent name="guidelines" subagent_type="docs" readonly="true">Parse CONTRIBUTING.md and extract requirements(CONTRIBUTING.mdを解析し要件を抽出する)</agent>
  <agent name="pr_template" subagent_type="docs" readonly="true">Fetch and parse .github/PULL_REQUEST_TEMPLATE.md from upstream; extract required sections and structure; return null if not found (no fallback)(アップストリームから.github/PULL_REQUEST_TEMPLATE.mdを取得・解析、必須セクションと構造を抽出、見つからない場合はnullを返す（フォールバックなし）)</agent>
  <agent name="changes" subagent_type="quality-assurance" readonly="true">Review code changes for quality and patterns(コード変更の品質とパターンをレビューする)</agent>
  <agent name="tests" subagent_type="test" readonly="true">Evaluate test coverage and appropriateness(テストカバレッジと適切性を評価する)</agent>
  <agent name="pr_samples" subagent_type="general-purpose" readonly="true">Sample 10 recently merged PRs from upstream via gh CLI; extract title patterns, description structure, and common sections for pattern learning(gh CLI経由でアップストリームから最近マージされた10件のPRをサンプリング、パターン学習用にタイトルパターン、説明構造、共通セクションを抽出する)</agent>
  <agent name="metadata" subagent_type="docs" readonly="true">Generate compliant PR title and description: use PR template sections if available; otherwise derive structure from 10 sampled merged PR patterns; set template_source accordingly(準拠したPRタイトルと説明を生成：PRテンプレートセクションが利用可能な場合はそれを使用、そうでなければ10件のサンプリングされたマージ済みPRパターンから構造を導出、template_sourceを適切に設定する)</agent>
  <agent name="verify" subagent_type="devops" readonly="true">Detect ecosystem (Nix-first), service dependencies, generate local reproduction steps, detect change types (ui, api, database, config, security, integration) using detection_rules, and inject actual paths/endpoints/component names into manual QA steps(エコシステム検出（Nix優先）、サービス依存関係、ローカル再現手順の生成、detection_rulesを使用した変更タイプ検出（ui、api、database、config、security、integration）、手動QAステップへの実際のパス/エンドポイント/コンポーネント名の注入)</agent>
  <agent name="validator" subagent_type="validator" readonly="true">Cross-validate guideline compliance and code review findings(ガイドライン準拠性とコードレビューの発見をクロスバリデーションする)</agent>
</agents>

<execution_graph>
  <parallel_group id="gather" depends_on="none">
    <agent>guidelines</agent>
    <agent>pr_template</agent>
    <agent>changes</agent>
    <agent>tests</agent>
    <agent>pr_samples</agent>
  </parallel_group>
  <parallel_group id="post_gather" depends_on="gather">
    <agent>metadata</agent>
    <agent>verify</agent>
  </parallel_group>
  <sequential_phase id="validation" depends_on="post_gather">
    <agent>validator</agent>
    <reason>Cross-validate all findings before final output(最終出力前にすべての発見をクロスバリデーションする)</reason>
  </sequential_phase>
</execution_graph>

<delegation>
  <requirement>Upstream repository URL or detection(アップストリームリポジトリURLまたは検出)</requirement>
  <requirement>Current branch and pending changes(現在のブランチと保留中の変更)</requirement>
  <requirement>Contribution guidelines (if available)(コントリビューションガイドライン（利用可能な場合）)</requirement>
  <requirement>PR template from .github/PULL_REQUEST_TEMPLATE.md (if available)(.github/PULL_REQUEST_TEMPLATE.mdからのPRテンプレート（利用可能な場合）)</requirement>
  <requirement>10 sampled merged PRs for pattern learning(パターン学習用の10件のサンプリングされたマージ済みPR)</requirement>
  <requirement>Explicit no-modification prohibition(明示的な変更禁止)</requirement>
  <requirement>Sub-agents must use AskUserQuestion for user interactions(サブエージェントはユーザーインタラクションにAskUserQuestionを使用すること)</requirement>
</delegation>

<output>
  <status_criteria>
    <status name="ready">Confidence score >= 80, no critical issues</status>
    <status name="needs_work">Confidence score 60-79, or has warning-level issues</status>
    <status name="blocked">Confidence score below 60, or has critical issues</status>
  </status_criteria>
  <format>
    <upstream_review>
      <summary>
        <upstream_repo>owner/repo</upstream_repo>
        <branch>feature-branch</branch>
        <changes_summary>Brief description of changes</changes_summary>
        <overall_score>XX/100</overall_score>
        <status>ready|needs_work|blocked</status>
      </summary>
      <checklist>
        <section name="Contribution Guidelines">
          <item status="pass|fail|warn">Guideline item description</item>
        </section>
        <section name="Code Quality">
          <item status="pass|fail|warn" priority="high|medium|low">Issue description with location</item>
        </section>
        <section name="Test Coverage">
          <item status="pass|fail|warn">Test evaluation item</item>
        </section>
        <section name="Past Review Patterns">
          <item status="info">Recurring feedback pattern to address</item>
        </section>
      </checklist>
      <pr_metadata>
        <template_source>upstream_template|sampled_patterns|none</template_source>
        <title>
          <value>Suggested PR title following learned patterns from sampled PRs</value>
          <pattern_notes>Pattern observed from 10 sampled PRs (e.g., [type]: description, feat(scope): description)</pattern_notes>
        </title>
        <description>
          <sections>
            <section name="Summary" required="true">Content based on template or sampled patterns</section>
            <section name="Test Plan" required="false">Content if template requires or patterns suggest</section>
          </sections>
          <raw_markdown>Full PR description in markdown matching upstream conventions</raw_markdown>
        </description>
        <pattern_confidence>0-100 based on template availability (40%) and sample quality (60%)</pattern_confidence>
      </pr_metadata>
      <local_reproduction>
        <ecosystem_detection>
          <description>Auto-detect project ecosystem from configuration files(設定ファイルからプロジェクトエコシステムを自動検出する)</description>
          <priority_order>
            <ecosystem priority="1" indicator="flake.nix">Nix (flake-based)</ecosystem>
            <ecosystem priority="2" indicator="shell.nix or default.nix">Nix (legacy)</ecosystem>
            <ecosystem priority="3" indicator="Makefile">Make</ecosystem>
            <ecosystem priority="4" indicator="Cargo.toml">Rust/Cargo</ecosystem>
            <ecosystem priority="5" indicator="go.mod">Go</ecosystem>
            <ecosystem priority="6" indicator="package.json">Node.js/npm</ecosystem>
            <ecosystem priority="7" indicator="pyproject.toml or setup.py">Python</ecosystem>
            <ecosystem priority="8" indicator="Gemfile">Ruby</ecosystem>
          </priority_order>
          <detected_ecosystem>Ecosystem name based on files found</detected_ecosystem>
        </ecosystem_detection>
        <environment_setup>
          <description>Prerequisites and environment initialization(前提条件と環境初期化)</description>
          <prerequisite_commands ecosystem="nix-flake">
            <command order="1" purpose="enter-shell">nix develop</command>
            <command order="2" purpose="build-check">nix flake check</command>
          </prerequisite_commands>
          <prerequisite_commands ecosystem="nix-legacy">
            <command order="1" purpose="enter-shell">nix-shell</command>
          </prerequisite_commands>
          <prerequisite_commands ecosystem="make">
            <command order="1" purpose="setup">make setup or make deps (if target exists)</command>
          </prerequisite_commands>
          <prerequisite_commands ecosystem="cargo">
            <command order="1" purpose="fetch">cargo fetch</command>
            <command order="2" purpose="build-check">cargo check</command>
          </prerequisite_commands>
          <prerequisite_commands ecosystem="go">
            <command order="1" purpose="fetch">go mod download</command>
            <command order="2" purpose="build-check">go build ./...</command>
          </prerequisite_commands>
          <prerequisite_commands ecosystem="npm">
            <command order="1" purpose="install">npm install or npm ci</command>
          </prerequisite_commands>
          <prerequisite_commands ecosystem="python">
            <command order="1" purpose="venv">python -m venv .venv and source .venv/bin/activate</command>
            <command order="2" purpose="install">pip install -e . or uv sync</command>
          </prerequisite_commands>
          <environment_requirements>
            <requirement type="env_var">List of required environment variables detected from .env.example or config</requirement>
            <requirement type="tool">List of required tools (detected from CI config or README)</requirement>
          </environment_requirements>
        </environment_setup>
        <service_dependencies>
          <description>External services required for local testing(ローカルテストに必要な外部サービス)</description>
          <detection_sources>
            <source>docker-compose.yml or compose.yml</source>
            <source>.env.example (DATABASE_URL, REDIS_URL patterns)</source>
            <source>CI workflow files (services section)</source>
            <source>README.md (development setup section)</source>
          </detection_sources>
          <detected_services>
            <service name="service-name" start_command="docker compose up -d service-name">Service description</service>
          </detected_services>
          <startup_command>docker compose up -d (if docker-compose.yml exists)</startup_command>
        </service_dependencies>
        <verification_commands>
          <description>Ecosystem-specific verification commands(エコシステム固有の検証コマンド)</description>
          <commands ecosystem="nix-flake">
            <command purpose="check">nix flake check</command>
            <command purpose="build">nix build</command>
            <command purpose="test">nix flake check (if tests defined in flake outputs)</command>
          </commands>
          <commands ecosystem="cargo">
            <command purpose="lint">cargo clippy</command>
            <command purpose="test">cargo test</command>
            <command purpose="build">cargo build --release</command>
          </commands>
          <commands ecosystem="go">
            <command purpose="lint">go vet ./...</command>
            <command purpose="test">go test ./...</command>
            <command purpose="build">go build ./...</command>
          </commands>
          <commands ecosystem="npm">
            <command purpose="lint">npm run lint</command>
            <command purpose="test">npm test</command>
            <command purpose="build">npm run build</command>
          </commands>
          <commands ecosystem="make">
            <command purpose="lint">make lint (if target exists)</command>
            <command purpose="test">make test</command>
            <command purpose="build">make build or make all</command>
          </commands>
          <commands ecosystem="python">
            <command purpose="lint">ruff check . or flake8</command>
            <command purpose="test">pytest</command>
            <command purpose="build">python -m build or pip install -e .</command>
          </commands>
        </verification_commands>
        <reproduction_steps>
          <description>Step-by-step local reproduction procedure(ステップバイステップのローカル再現手順)</description>
          <step order="1">
            <action>Checkout branch(ブランチをチェックアウトする)</action>
            <command>git checkout [branch-name]</command>
            <expected_output>Switched to branch [branch-name]</expected_output>
          </step>
          <step order="2">
            <action>Setup environment(環境をセットアップする)</action>
            <command>Ecosystem-specific setup command from environment_setup</command>
            <expected_output>Dependencies installed, environment ready(依存関係がインストールされ、環境が準備完了)</expected_output>
          </step>
          <step order="3">
            <action>Start services (if needed)(サービスを起動する（必要な場合）)</action>
            <command>Commands from service_dependencies</command>
            <expected_output>All required services running(すべての必要なサービスが稼働中)</expected_output>
          </step>
          <step order="4">
            <action>Run verification(検証を実行する)</action>
            <command>Commands from verification_commands</command>
            <expected_output>All checks pass (lint, test, build)(すべてのチェックが合格（lint、test、build）)</expected_output>
          </step>
          <step order="5">
            <action>Manual testing(手動テスト)</action>
            <command>Start application locally (e.g., npm run dev, cargo run, go run .)</command>
            <expected_output>Application running at expected URL/port(アプリケーションが期待されるURL/ポートで稼働中)</expected_output>
          </step>
          <step order="6">
            <action>Verify change behavior(変更の動作を確認する)</action>
            <steps>Context-specific steps based on change type (UI, API, integration)</steps>
            <expected_output>Change works as expected(変更が期待通りに動作する)</expected_output>
          </step>
        </reproduction_steps>
        <reproduction_confidence>
          <score>0-100 based on detection completeness</score>
          <factors>
            <factor name="ecosystem_detected" weight="0.3">Was ecosystem clearly identified(エコシステムが明確に特定されたか)</factor>
            <factor name="services_documented" weight="0.3">Are service dependencies clear(サービス依存関係が明確か)</factor>
            <factor name="commands_verified" weight="0.4">Do verification commands exist in project(検証コマンドがプロジェクトに存在するか)</factor>
          </factors>
          <fallback_guidance>If reproduction not feasible locally, suggest: CI-based testing, containerized environment, or ask maintainers</fallback_guidance>
        </reproduction_confidence>
      </local_reproduction>
      <manual_verification>
        <description>Create a reproducible verification environment using devenv(devenvを使用して再現可能な検証環境を作成する)</description>
        <directory_structure>
          <base_path>/tmp/[repo-name]/[branch-name-or-issue-number]/</base_path>
          <files>
            <file name="devenv.nix">Ecosystem-specific development environment</file>
            <file name=".envrc">direnv integration with use devenv</file>
            <file name="README.md">Detailed verification instructions</file>
            <file name="fixtures/">Test fixtures and sample data directory</file>
            <file name=".git/">Initialized git repository</file>
          </files>
        </directory_structure>
        <workflow>
          <step order="1" action="create_directory">
            <command>mkdir -p /tmp/[repo-name]/[branch-name-or-issue-number]</command>
            <expected_output>Directory created at /tmp/[repo-name]/[branch-name-or-issue-number]</expected_output>
          </step>
          <step order="2" action="generate_devenv">
            <description>Generate ecosystem-specific devenv.nix based on detected ecosystem(検出されたエコシステムに基づいてエコシステム固有のdevenv.nixを生成する)</description>
            <tool>Write tool</tool>
            <output_file>devenv.nix</output_file>
          </step>
          <step order="3" action="generate_envrc">
            <description>Generate .envrc for direnv integration(direnv連携用の.envrcを生成する)</description>
            <tool>Write tool</tool>
            <output_file>.envrc</output_file>
            <content>eval "$(devenv direnvrc)"
use devenv</content>
          </step>
          <step order="4" action="generate_fixtures">
            <description>Generate verification files based on change type(変更タイプに基づいて検証ファイルを生成する)</description>
            <tool>Write tool</tool>
            <output_directory>fixtures/</output_directory>
          </step>
          <step order="5" action="generate_readme">
            <description>Generate README.md with detailed verification steps(詳細な検証手順を含むREADME.mdを生成する)</description>
            <tool>Write tool</tool>
            <output_file>README.md</output_file>
          </step>
          <step order="6" action="initialize_git">
            <command>cd /tmp/[repo-name]/[branch-name-or-issue-number] &amp;&amp; git init &amp;&amp; git add .</command>
            <expected_output>Initialized git repository with all files staged</expected_output>
          </step>
        </workflow>
        <devenv_templates>
          <description>Generate devenv.nix configuration for verification environments based on detected ecosystem(検出されたエコシステムに基づいて検証環境用のdevenv.nix設定を生成する)</description>
          <skill_reference>
            <skill>devenv-ecosystem</skill>
            <usage>Consult devenv-ecosystem skill for language configuration patterns, version pinning, package manager selection, services (databases, caches), git-hooks, scripts, processes, profiles, env/dotenv configuration, and all devenv.nix options</usage>
          </skill_reference>
        </devenv_templates>
        <fixtures_generation>
          <fixture_type change_type="api">
            <directory>fixtures/api/</directory>
            <files>
              <file name="request.json">Sample API request body</file>
              <file name="response.json">Expected API response</file>
              <file name="test.sh">curl commands for API testing</file>
            </files>
          </fixture_type>
          <fixture_type change_type="database">
            <directory>fixtures/data/</directory>
            <files>
              <file name="seed.sql">Test data seed script</file>
              <file name="verify.sql">Verification queries</file>
            </files>
          </fixture_type>
          <fixture_type change_type="config">
            <directory>fixtures/config/</directory>
            <files>
              <file name=".env.test">Test environment variables</file>
              <file name="config.test.json">Test configuration</file>
            </files>
          </fixture_type>
          <fixture_type change_type="ui">
            <directory>fixtures/screenshots/</directory>
            <files>
              <file name="expected/">Expected screenshot directory</file>
              <file name="viewports.json">Viewport configurations for testing</file>
            </files>
          </fixture_type>
          <fixture_type change_type="security">
            <directory>fixtures/security/</directory>
            <files>
              <file name="test_tokens.json">Test authentication tokens (non-production)</file>
              <file name="permissions.json">Permission matrix for testing</file>
              <file name="auth_test.sh">Authentication flow test script</file>
            </files>
          </fixture_type>
          <fixture_type change_type="integration">
            <directory>fixtures/integration/</directory>
            <files>
              <file name="mock_services.json">Mock service configurations</file>
              <file name="event_payloads.json">Sample event and webhook payloads</file>
              <file name="sequence.md">Integration test sequence documentation</file>
            </files>
          </fixture_type>
        </fixtures_generation>
        <readme_template>
          <sections>
            <section name="Overview">
              <description>PR summary and change description(PRサマリーと変更の説明)</description>
              <template>
# Verification Environment for [pr-title]

**Branch:** [branch-name-or-issue-number]
**Upstream:** [upstream-url]
**Ecosystem:** [detected-ecosystem]

[pr-description]
              </template>
            </section>
            <section name="Prerequisites">
              <description>Required tools and environment setup(必要なツールと環境セットアップ)</description>
              <template>
## Prerequisites

- nix (with flakes enabled)
- direnv (for automatic environment activation)
- devenv
              </template>
            </section>
            <section name="Setup">
              <description>Step-by-step environment initialization(ステップバイステップの環境初期化)</description>
              <template>
## Setup

1. Navigate to this directory
2. Run `direnv allow` to activate the environment
3. Wait for devenv to initialize
              </template>
            </section>
            <section name="Verification Steps">
              <description>Detailed manual verification procedures(詳細な手動検証手順)</description>
              <template>
## Verification Steps

(Generated based on detected change types)
              </template>
            </section>
            <section name="Expected Results">
              <description>What success looks like(成功した場合の状態)</description>
              <template>
## Expected Results

(Generated based on change analysis)
              </template>
            </section>
            <section name="Troubleshooting">
              <description>Common issues and solutions(よくある問題と解決策)</description>
              <template>
## Troubleshooting

### direnv not activating
Run `direnv allow` in the directory.

### devenv not found
Install devenv: `nix profile install github:cachix/devenv`
              </template>
            </section>
          </sections>
        </readme_template>
        <detection_rules>
          <rule type="ui">Changes to *.css, *.scss, *.sass, *.less, *.html, *.jsx, *.tsx, *.vue, *.svelte, **/components/**, **/pages/**, **/views/**</rule>
          <rule type="api">Changes to **/api/**, **/routes/**, **/handlers/**, **/controllers/**, **/endpoints/**, *.openapi.*, *.swagger.*, **/graphql/**</rule>
          <rule type="database">Changes to **/migrations/**, **/schema/**, **/models/**, *.sql, **/prisma/**, **/drizzle/**, **/typeorm/**, **/sequelize/**</rule>
          <rule type="config">Changes to *.env*, *.config.*, docker-compose.*, compose.*, *.yaml, *.yml, *.toml, *.json (config), **/config/**, Dockerfile*, .docker/**</rule>
          <rule type="security">Changes to **/auth/**, **/authentication/**, **/authorization/**, **/permission/**, **/security/**, **/middleware/auth*, **/guards/**, *.key, *.pem, *.cert, **/crypto/**</rule>
          <rule type="integration">Changes spanning 3+ modules, external service configurations, message queue handlers, event emitters/listeners, webhook handlers</rule>
        </detection_rules>
        <context_injection>
          <description>The synthesize phase MUST replace these placeholders with actual values from diff analysis(synthesizeフェーズはこれらのプレースホルダーをdiff分析からの実際の値で置き換えなければならない)</description>
          <placeholder name="[repo-name]">Repository name extracted from git remote (e.g., owner/repo becomes repo)</placeholder>
          <placeholder name="[branch-name-or-issue-number]">Current branch name or related issue number</placeholder>
          <placeholder name="[detected-ecosystem]">Ecosystem detected from project files</placeholder>
          <placeholder name="[upstream-url]">Upstream repository URL</placeholder>
          <placeholder name="[pr-title]">Generated PR title</placeholder>
          <placeholder name="[pr-description]">Generated PR description</placeholder>
        </context_injection>
        <verification_confidence>
          <score>0-100 based on environment reproducibility</score>
          <factors>
            <factor name="ecosystem_detected" weight="0.3">Was ecosystem clearly identified(エコシステムが明確に特定されたか)</factor>
            <factor name="devenv_completeness" weight="0.4">Does devenv.nix include all required tools(devenv.nixにすべての必要なツールが含まれているか)</factor>
            <factor name="readme_clarity" weight="0.3">Are verification steps clear and executable(検証手順が明確で実行可能か)</factor>
          </factors>
        </verification_confidence>
        <empty_state>If no verification environment needed, skip directory creation</empty_state>
      </manual_verification>
      <task_breakdown>
        <dependency_graph>
          <description>Visual representation of task dependencies for parallel/sequential execution(並列/逐次実行のためのタスク依存関係の視覚的表現)</description>
          <example>
Phase 1: Code Fixes (independent)
Phase 2: Test Updates (independent)
Phase 3: Documentation (depends on Phase 1)
Phase 4: Final Verification (depends on all)
          </example>
        </dependency_graph>
        <phased_tasks>
          <dependency_format>
            <description>Valid dependency formats for task dependencies field(タスク依存関係フィールドの有効な依存関係フォーマット)</description>
            <format type="none">None</format>
            <format type="list">CF-001, CF-002</format>
            <format type="phase">All previous phases</format>
          </dependency_format>
          <phase name="code_fixes" order="1" parallel_safe="true">
            <description>Lint errors, style issues, code quality improvements identified in review(レビューで特定されたlintエラー、スタイルの問題、コード品質の改善)</description>
            <task id="CF-001">
              <files>List of files to modify</files>
              <overview>Brief description of what needs to be done</overview>
              <dependencies>None</dependencies>
            </task>
          </phase>
          <phase name="test_updates" order="2" parallel_safe="true">
            <description>Missing tests, coverage gaps, test improvements(不足しているテスト、カバレッジギャップ、テストの改善)</description>
            <task id="TU-001">
              <files>List of test files</files>
              <overview>Test task description</overview>
              <dependencies>CF-001</dependencies>
            </task>
          </phase>
          <phase name="documentation" order="3" parallel_safe="true">
            <description>README, inline docs, changelog, API documentation(README、インラインドキュメント、変更ログ、APIドキュメント)</description>
            <task id="DOC-001">
              <files>Documentation files</files>
              <overview>Documentation task description</overview>
              <dependencies>CF-001</dependencies>
            </task>
          </phase>
          <phase name="commit_prep" order="4" parallel_safe="false">
            <description>Commit message formatting per contribution guidelines, rebasing onto upstream, squashing commits if required(コントリビューションガイドラインに従ったコミットメッセージのフォーマット、アップストリームへのリベース、必要に応じたコミットのスカッシュ)</description>
            <task id="GIT-001">
              <files>N/A (git operations)</files>
              <overview>Git preparation task description</overview>
              <dependencies>All previous phases</dependencies>
            </task>
          </phase>
          <phase name="final_verification" order="5" parallel_safe="false">
            <description>Running lint, test, build commands before PR(PR前のlint、test、buildコマンドの実行)</description>
            <task id="VER-001">
              <files>N/A (verification commands)</files>
              <overview>Run all verification commands</overview>
              <dependencies>All previous phases</dependencies>
            </task>
          </phase>
        </phased_tasks>
        <execute_handoff>
          <description>This section is parsed by /execute command to initialize task context(このセクションは/executeコマンドによってタスクコンテキストの初期化のために解析される)</description>
          <decisions>
            <decision id="D-001">Design decision description affecting implementation</decision>
          </decisions>
          <references>
            <reference type="upstream_guidelines">Link or content of CONTRIBUTING.md requirements</reference>
            <reference type="pr_template">Structure and required sections from .github/PULL_REQUEST_TEMPLATE.md</reference>
            <reference type="pr_patterns">Title and description patterns learned from 10 sampled merged PRs</reference>
            <reference type="code_patterns">Relevant upstream code patterns to follow (specific file paths)</reference>
            <reference type="past_feedback">Patterns from past PR reviews to address</reference>
          </references>
          <deliverables>
            <deliverable task="CF-001">Expected output: fixed files passing lint</deliverable>
            <deliverable task="TU-001">Expected output: new/updated tests passing</deliverable>
            <deliverable task="DOC-001">Expected output: updated documentation</deliverable>
            <deliverable task="GIT-001">Expected output: clean commit history ready for PR</deliverable>
            <deliverable task="VER-001">Expected output: all verification commands pass</deliverable>
          </deliverables>
          <memory_hints>
            <hint>Check serena memory for: contribution patterns of this upstream repo</hint>
            <hint>Check serena memory for: past PR feedback patterns</hint>
          </memory_hints>
          <verification_criteria>
            <criterion task="CF-001">Lint passes with zero errors</criterion>
            <criterion task="TU-001">Test suite passes, coverage not decreased</criterion>
            <criterion task="VER-001">All verification_commands exit 0</criterion>
          </verification_criteria>
          <constraints>
            <constraint>Must maintain read-only until /execute is invoked</constraint>
            <constraint>All tasks must be completable without PR creation</constraint>
            <constraint>Tasks should be atomic and independently executable</constraint>
          </constraints>
        </execute_handoff>
      </task_breakdown>
      <self_feedback>
        <confidence>XX/100 (based on guideline_compliance, code_quality, test_coverage)</confidence>
        <issues>
          <issue severity="critical">Issue description (if any, max 2 total)</issue>
          <issue severity="warning">Issue description (if any)</issue>
        </issues>
      </self_feedback>
    </upstream_review>
  </format>
</output>

<enforcement>
  <mandatory_behaviors>
    <behavior id="UP-B001" priority="critical">
      <trigger>Before any GitHub operations(GitHub操作の前に)</trigger>
      <action>Verify gh CLI authentication(gh CLI認証を確認する)</action>
      <verification>Auth check in preflight phase</verification>
    </behavior>
    <behavior id="UP-B002" priority="critical">
      <trigger>When fetching CONTRIBUTING.md(CONTRIBUTING.md取得時に)</trigger>
      <action>Check all three locations with fallback(フォールバックで3つの場所すべてを確認する)</action>
      <verification>Fallback hierarchy in gather phase</verification>
    </behavior>
    <behavior id="UP-B003" priority="critical">
      <trigger>When providing PR metadata(PRメタデータ提供時に)</trigger>
      <action>Use PR template structure (if available) and patterns learned from 10 sampled merged PRs(PRテンプレート構造（利用可能な場合）と10件のサンプリングされたマージ済みPRから学習したパターンを使用する)</action>
      <verification>Metadata matches upstream PR template sections and learned patterns; template_source indicates data source used</verification>
    </behavior>
    <behavior id="UP-B008" priority="critical">
      <trigger>When fetching PR template(PRテンプレート取得時に)</trigger>
      <action>Fetch .github/PULL_REQUEST_TEMPLATE.md only (no fallback hierarchy)(.github/PULL_REQUEST_TEMPLATE.mdのみを取得する（フォールバック階層なし）)</action>
      <verification>Template fetched from exact path or confirmed absent</verification>
    </behavior>
    <behavior id="UP-B009" priority="critical">
      <trigger>When sampling PRs for patterns(パターン用PRサンプリング時に)</trigger>
      <action>Sample 10 most recently merged PRs from any author via gh pr list --state merged --limit 10(gh pr list --state merged --limit 10で任意の著者から最近マージされた10件のPRをサンプリングする)</action>
      <verification>PR samples retrieved with title, body, number, author fields</verification>
    </behavior>
    <behavior id="UP-B004" priority="critical">
      <trigger>When generating final output(最終出力生成時に)</trigger>
      <action>Include manual QA checklist with structured qa_steps based on detected change types (ui, api, database, config, security, integration)(検出された変更タイプ（ui、api、database、config、security、integration）に基づく構造化されたqa_stepsを含む手動QAチェックリストを含めること)</action>
      <verification>Manual verification section present with ordered qa_steps containing action, tool, command, expected_output for each detected change type</verification>
    </behavior>
    <behavior id="UP-B007" priority="critical">
      <trigger>When generating manual_verification section(manual_verificationセクション生成時に)</trigger>
      <action>Inject actual values from diff analysis into qa_step commands replacing all placeholders(diff分析からの実際の値をqa_stepコマンドに注入し、すべてのプレースホルダーを置き換える)</action>
      <verification>All placeholders ([endpoint-path], [component-name], [table-name], etc.) replaced with actual detected values; qa_confidence score reflects injection completeness</verification>
    </behavior>
    <behavior id="UP-B005" priority="critical">
      <trigger>When generating final output(最終出力生成時に)</trigger>
      <action>Generate comprehensive task_breakdown with phased_tasks and execute_handoff(phased_tasksとexecute_handoffを含む包括的なtask_breakdownを生成する)</action>
      <verification>task_breakdown section present with all task categories populated</verification>
    </behavior>
    <behavior id="UP-B006" priority="critical">
      <trigger>When generating final output(最終出力生成時に)</trigger>
      <action>Generate local_reproduction section with Nix-first ecosystem detection, environment setup, service dependencies, and step-by-step reproduction instructions(Nix優先エコシステム検出、環境セットアップ、サービス依存関係、ステップバイステップの再現手順を含むlocal_reproductionセクションを生成する)</action>
      <verification>local_reproduction section present with ecosystem_detection, environment_setup, service_dependencies, verification_commands, and reproduction_steps</verification>
    </behavior>
  </mandatory_behaviors>
  <prohibited_behaviors>
    <behavior id="UP-P001" priority="critical">
      <trigger>Always</trigger>
      <action>Modifying any files(ファイルの変更)</action>
      <response>Block operation, this is read-only command(操作をブロック、これは読み取り専用コマンド)</response>
    </behavior>
    <behavior id="UP-P002" priority="critical">
      <trigger>Always</trigger>
      <action>Creating PR via gh pr create or any other method(gh pr createまたはその他の方法でPRを作成すること)</action>
      <response>HARD BLOCK: This command NEVER creates PRs. Output task breakdown for /execute handoff instead. User must create PR manually after completing all pre-PR tasks.(ハードブロック：このコマンドは絶対にPRを作成しない。代わりに/execute引き渡し用のタスク分解を出力する。ユーザーはすべてのPR前タスク完了後に手動でPRを作成する必要がある。)</response>
    </behavior>
    <behavior id="UP-P003" priority="critical">
      <trigger>When user explicitly requests PR creation(ユーザーが明示的にPR作成を要求した場合)</trigger>
      <action>Creating PR even when user requests it(ユーザーが要求しても PRを作成すること)</action>
      <response>HARD BLOCK: Refuse PR creation. Explain that /upstream is review-only and output the task breakdown. Instruct user to run /execute on tasks first, then create PR manually.(ハードブロック：PR作成を拒否する。/upstreamはレビュー専用であることを説明し、タスク分解を出力する。ユーザーに先に/executeでタスクを実行し、その後手動でPRを作成するよう指示する。)</response>
    </behavior>
  </prohibited_behaviors>
</enforcement>

<error_escalation inherits="core-patterns#error_escalation">
  <examples>
    <example severity="low">Minor style inconsistency with upstream(アップストリームとの軽微なスタイルの不整合)</example>
    <example severity="medium">CONTRIBUTING.md not found or gh CLI rate limited(CONTRIBUTING.mdが見つからない、またはgh CLIのレート制限)</example>
    <example severity="high">Major guideline violation or breaking change detected(重大なガイドライン違反または破壊的変更の検出)</example>
    <example severity="critical">gh auth failure or no upstream detected(gh認証失敗またはアップストリームが検出されない)</example>
  </examples>
</error_escalation>

<related_commands>
  <command name="execute">After upstream review, implement recommended fixes(アップストリームレビュー後、推奨される修正を実装する)</command>
  <command name="feedback">Additional review after fixes applied(修正適用後の追加レビュー)</command>
  <command name="define">If requirements for contribution unclear(コントリビューションの要件が不明確な場合)</command>
</related_commands>

<related_skills>
  <skill name="execution-workflow">Understanding PR review methodology(PRレビュー方法論の理解)</skill>
  <skill name="testing-patterns">Evaluating test appropriateness(テストの適切性の評価)</skill>
  <skill name="fact-check">Verifying contribution guideline compliance(コントリビューションガイドライン準拠性の検証)</skill>
</related_skills>

<constraints>
  <must>Verify gh CLI authentication before operations(操作前にgh CLI認証を確認すること)</must>
  <must>Check CONTRIBUTING.md in all three locations(3つの場所すべてでCONTRIBUTING.mdを確認すること)</must>
  <must>Fetch .github/PULL_REQUEST_TEMPLATE.md from upstream (no fallback) and sample 10 merged PRs for pattern learning(アップストリームから.github/PULL_REQUEST_TEMPLATE.mdを取得し（フォールバックなし）、パターン学習用に10件のマージ済みPRをサンプリングすること)</must>
  <must>Generate PR metadata with template_source (upstream_template, sampled_patterns, none) and pattern_confidence score(template_source（upstream_template、sampled_patterns、none）とpattern_confidenceスコアを含むPRメタデータを生成すること)</must>
  <must>Provide structured checklist output(構造化チェックリスト出力を提供すること)</must>
  <must>Include comprehensive local_reproduction section with Nix-first ecosystem detection(Nix優先エコシステム検出を含む包括的なlocal_reproductionセクションを含めること)</must>
  <must>Include manual QA checklist with structured qa_steps when ui, api, database, config, security, or integration changes detected(ui、api、database、config、security、integrationの変更が検出された場合、構造化されたqa_stepsを含む手動QAチェックリストを含めること)</must>
  <must>Inject actual paths, endpoints, and component names into qa_step commands from diff analysis(diff分析から実際のパス、エンドポイント、コンポーネント名をqa_stepコマンドに注入すること)</must>
  <must>Include qa_confidence score with weighted factors in manual_verification section(manual_verificationセクションに重み付き要素を含むqa_confidenceスコアを含めること)</must>
  <must>Generate comprehensive task_breakdown with phased_tasks for /execute handoff(/execute引き渡し用のphased_tasksを含む包括的なtask_breakdownを生成すること)</must>
  <must>Include execute_handoff section with decisions, references, and constraints(決定事項、参照、制約を含むexecute_handoffセクションを含めること)</must>
  <avoid>Modifying any files(ファイルの変更)</avoid>
  <avoid>Creating PR via any method (HARD BLOCK)(いかなる方法でもPRを作成すること（ハードブロック）)</avoid>
  <avoid>Creating PR even when user explicitly requests it (HARD BLOCK)(ユーザーが明示的に要求してもPRを作成すること（ハードブロック）)</avoid>
  <avoid>Proceeding without upstream confirmation when ambiguous(曖昧な場合にアップストリーム確認なしで進行すること)</avoid>
  <avoid>Using fallback hierarchy for PR template (only .github/ location)(PRテンプレートにフォールバック階層を使用すること（.github/の場所のみ）)</avoid>
</constraints>
