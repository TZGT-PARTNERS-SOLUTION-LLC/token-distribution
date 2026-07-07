# Token Distribution Wizard

Deploy an ERC-20 token, mint the initial supply directly to a recipient wallet, and run guided transfer workflows from the same toolkit.

## What it does

- Guides you through network selection
- Uses your deployer wallet to pay gas
- Deploys the token contract
- Mints the full initial supply to a recipient address
- Saves a deployment report in `results/`

## Quick Start

### Requirements

- Node.js 18+

### Run

| Platform | Command |
| --- | --- |
| Windows PowerShell | `.\run.ps1` |
| Windows CMD | `run.bat` |
| Linux / macOS | `bash run.sh` |
| Direct Node.js | `node wizard/run.js` |

Dependencies install automatically on first run.

## GitHub Pages landing page

The public GitHub Pages site is built from the static frontend in `site/` and deployed from the generated `dist/` directory.

### Build the Pages site locally

```bash
npm ci
npm run build:pages
```

Open `dist/index.html` in a browser to preview the landing page locally.

## Configuration

You can create a `.env` file from `.env.example` to skip prompts:

```env
PRIVATE_KEY=0xYOUR_PRIVATE_KEY_HERE
RPC_URL=https://bsc-dataseed1.binance.org
```

## Dry Run

```bash
node wizard/run.js --dry-run
```

## Output

Deployment reports are written to `results/deploy_<timestamp>.json`.

Transfer reports are written to `results/` by the transfer wizard as well.

## Security Notes

- Never commit private keys or live RPC credentials
- The deployer key is only used in memory during the session
- Always test on a testnet before using mainnet funds
- The GitHub Pages landing page is informational only; live token operations continue to run locally through the Node.js wizard scripts
