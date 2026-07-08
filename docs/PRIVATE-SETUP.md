# Private Setup Guide

This guide covers secure setup for the Token Distribution Wizard with sensitive credentials.

## 1. Environment Configuration

### Create Local Environment File

```bash
cp .env.example .env
```

### Configure Your Credentials

Edit `.env` with your values (DO NOT commit this file):

```env
# ── Deployer wallet private key (from your wallet export) ──
PRIVATE_KEY=0xYOUR_64_HEX_CHARS_HERE

# ── Network RPC endpoint ──
RPC_URL=https://bsc-dataseed1.binance.org

# ── Optional: Token contract address for transfers ──
TOKEN_ADDRESS=0xYourTokenAddress

# ── Optional: BSC-specific configuration ──
BSC_PRIVATE_KEY=0xYOUR_BSC_PRIVATE_KEY_HERE
BSC_AMOUNT_BNB=1.1
BSC_TOKEN_ADDRESS=0x55d398326f99059ff775485246999027b3197955
BSCSCAN_API_KEY=your_bscscan_api_key
ALCHEMY_URL=https://eth-mainnet.g.alchemy.com/v2/YOUR_ALCHEMY_KEY
```

## 2. Private Key Management

### Secure Key Generation

**Option A: Use your wallet provider's export**
- MetaMask → Account Settings → Private Key Export
- Trust Wallet → Settings → Wallets → Private Key
- Hardware wallet → Recovery phrase → Derive key

**Option B: Generate new key (ethers.js)**
```javascript
const { Wallet } = require('ethers');
const wallet = Wallet.createRandom();
console.log('Address:', wallet.address);
console.log('Private Key:', wallet.privateKey);
```

### Key Security Rules

- **NEVER** commit `.env` to git
- **NEVER** share private keys via email, chat, or unsecured channels
- **NEVER** hardcode keys in source files
- **ALWAYS** use separate keys for testnet and mainnet
- **ALWAYS** verify the wallet has sufficient gas before deployment
- **Rotate keys** after production deployments

## 3. Secrets in GitHub Actions

### Setup GitHub Secrets

For CI/CD pipeline, add secrets to GitHub:

1. Go to: `Settings → Secrets and variables → Actions`
2. Create these secrets:

```
PRIVATE_KEY              → Your deployer wallet private key
RPC_URL                  → Network RPC endpoint
BSC_PRIVATE_KEY          → BSC deployer key (if used)
BSCSCAN_API_KEY          → API key for block explorer
ALCHEMY_URL              → Alchemy API endpoint
```

### Reference in Workflows

```yaml
- name: Deploy Token
  env:
    PRIVATE_KEY: ${{ secrets.PRIVATE_KEY }}
    RPC_URL: ${{ secrets.RPC_URL }}
  run: node wizard/run.js
```

## 4. Pre-Deployment Checklist

- [ ] `.env` file created and added to `.gitignore`
- [ ] Private key loaded into `.env` (not in source code)
- [ ] RPC URL tested and accessible
- [ ] Deployer wallet has sufficient gas funds
- [ ] Running `--dry-run` to validate configuration
- [ ] All environment variables present and correct
- [ ] GitHub secrets configured (if using Actions)
- [ ] No hardcoded keys in any files
- [ ] `.gitignore` includes `.env*` patterns
- [ ] Verify `push_and_private.ps1` is in `.gitignore` (admin script)

## 5. Safe Deployment Workflow

### Step 1: Test on Testnet

```bash
# Using testnet RPC
RPC_URL=https://data-seed-prebsc-1-s0-testnet.bnbchain.org:8545 node wizard/run.js --dry-run
```

### Step 2: Dry Run

```bash
node wizard/run.js --dry-run
```

### Step 3: Check Receipts

Review generated receipt in `results/deploy_<timestamp>.json`:
- Correct token name and symbol
- Correct initial supply
- Correct recipient address
- Correct deployer address

### Step 4: Production Deployment

```bash
node wizard/run.js
```

## 6. Emergency Key Rotation

If private key is compromised:

1. **Immediately** transfer all funds to a new wallet
2. Generate new private key
3. Update `.env` with new key
4. Update GitHub secrets
5. Document incident in security log

## 7. File Security

### Critical Files (Never Commit)

```
.env                      # Environment variables
.env.local                # Local overrides
.env.*.local              # Environment-specific local
results/                  # Deployment receipts (contains sensitive data)
push_and_private.ps1      # Admin utilities (in .gitignore)
```

### Verify .gitignore

Confirm these patterns are in `.gitignore`:

```
.env
.env.*
!.env.example
results/
*.log
push_and_private.ps1
```

## 8. Accessing Results Securely

Deployment results are saved to `results/deploy_<timestamp>.json`:

```json
{
  "deployerAddress": "0x...",
  "tokenAddress": "0x...",
  "txHash": "0x...",
  "blockNumber": 12345678,
  "timestamp": "2024-01-15T10:30:00Z"
}
```

**Security notes:**
- Receipts contain transaction data (public)
- Never share receipts with credentials in them
- Clean results/ directory before sharing codebase
- Archive receipts securely offline

## 9. Audit Trail

Track deployments in a private log:

```bash
# Create private audit log (not in git)
echo "$(date): Deployed token to recipient:0x... - Tx:0x..." >> .private-audit.log
```

## 10. Support & Issues

If credentials are exposed:
1. Revoke on GitHub immediately (Settings → Secrets)
2. Rotate private keys
3. Check blockchain for unauthorized transactions
4. Consider security consultation for mainnet funds
