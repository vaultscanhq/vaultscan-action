# VaultScan GitHub Action

[![Self-test](https://github.com/vaultscanhq/vaultscan-action/actions/workflows/self-test.yml/badge.svg)](https://github.com/vaultscanhq/vaultscan-action/actions/workflows/self-test.yml)
[![License](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](LICENSE)

Runs [VaultScan](https://github.com/vaultscanhq/vaultscan-community) in a
workflow and turns the result into one verdict for the change:

| Verdict | Meaning | Job result |
| --- | --- | --- |
| **ALLOW** | Nothing needs attention | passes |
| **WARN** | Findings worth fixing | passes |
| **ASK HUMAN** | Deletes resources or changes access | fails |
| **BLOCK** | Should not go ahead as it stands | fails |

Secrets and GitHub Actions workflows are checked on every run. Terraform plans
and Kubernetes manifests are checked when you point the action at them. The
report is written to the job summary.

## Usage

```yaml
name: VaultScan

on:
  pull_request:

permissions:
  contents: read

jobs:
  gate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v7
      - uses: vaultscanhq/vaultscan-action@v2
```

With a Terraform plan and Kubernetes manifests:

```yaml
      - run: |
          terraform -chdir=infra init -input=false
          terraform -chdir=infra plan -input=false -out tfplan
          terraform -chdir=infra show -json tfplan > plan.json

      - uses: vaultscanhq/vaultscan-action@v2
        with:
          plan: plan.json
          manifests: deploy/
```

## Inputs

| Input | Default | Description |
| --- | --- | --- |
| `path` | `.` | Directory scanned for secrets and workflows |
| `plan` | | Terraform plan as JSON (`terraform show -json`) |
| `manifests` | | File or directory of Kubernetes manifests |
| `policy` | | Policy file; `.vaultscan.yml` in `path` is used if present |
| `fail-on-findings` | `true` | Set to `false` to report without failing the job |
| `version` | `main` | Git ref of `vaultscan-community` to install; pin a tag or SHA for reproducible runs |
| `ai` | `false` | Add the AI review (see below) |

## Outputs

| Output | Description |
| --- | --- |
| `verdict` | `ALLOW`, `WARN`, `ASK_HUMAN` or `BLOCK` |
| `report` | Path to the JSON report |

```yaml
      - id: vaultscan
        uses: vaultscanhq/vaultscan-action@v2
        with:
          fail-on-findings: "false"

      - if: steps.vaultscan.outputs.verdict == 'ASK_HUMAN'
        run: echo "Needs sign-off from the platform team"
```

## AI review

Set `ai: "true"` and provide a model through the job environment. The verdict
stays rule-based; the model explains the findings and can only escalate.

```yaml
      - uses: vaultscanhq/vaultscan-action@v2
        with:
          ai: "true"
        env:
          VAULTSCAN_AI_PROVIDER: anthropic
          VAULTSCAN_AI_MODEL: ${{ vars.VAULTSCAN_AI_MODEL }}
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
```

Secret values are redacted before anything is sent. See the
[AI review notes](https://github.com/vaultscanhq/vaultscan-community/blob/main/docs/ai.md).

## Upgrading from v1

| | v1 | v2 |
| --- | --- | --- |
| Checks | Secrets | Secrets, workflows, Terraform plans, Kubernetes manifests |
| Job result | Always passed | Fails on ASK HUMAN or BLOCK |
| Output | Log only | Log, job summary, `verdict` and `report` outputs |
| Install | Cloned the scanner into your workspace | `pip install`, nothing added to the workspace |

To keep the old report-only behaviour while you clean up findings, set
`fail-on-findings: "false"`.

## License

Apache-2.0. See [LICENSE](LICENSE) and [.github/NOTICE](.github/NOTICE).

Developed by [Pavan Gajjala](https://github.com/pavangajjala).
