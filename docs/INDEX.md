# Private Setup Documentation Index

Complete reference for setting up and securing the Token Distribution Wizard.

## Quick Start

**New to the project?** Start here:

1. **[Quick Reference](./QUICK-REFERENCE.md)** (5 min read)
   - Fast setup checklist
   - Common commands
   - Environment variable format
   - Testnet vs Mainnet comparison

2. **[Private Setup Guide](./PRIVATE-SETUP.md)** (10 min read)
   - Detailed environment configuration
   - Private key management
   - Safe deployment workflow
   - File security

3. **[Security Checklist](./SECURITY-CHECKLIST.md)** (5 min read)
   - Pre-deployment validation
   - Source code review
   - Git configuration
   - Emergency procedures

## Advanced Topics

### GitHub Actions & CI/CD

**[GitHub Secrets Setup](./GITHUB-SECRETS-SETUP.md)** (15 min read)
- Creating and managing GitHub secrets
- Workflow configuration
- Multi-environment deployments (testnet/mainnet)
- Branch protection and approvals
- Audit logging
- Secret rotation

### Security & Compliance

**[Security Checklist](./SECURITY-CHECKLIST.md)**
- Pre-run validation
- Post-deployment verification
- Incident response
- Audit trail maintenance
- Periodic key rotation

## File Structure

```
token-distribution/
├── docs/
│  ├── INDEX.md                   # This file
│  ├── QUICK-REFERENCE.md         # Quick setup checklist
│  ├── PRIVATE-SETUP.md           # Detailed configuration
│  ├── SECURITY-CHECKLIST.md      # Pre-deployment validation
│  └── GITHUB-SECRETS-SETUP.md    # CI/CD configuration
│
├── .githooks/
│  └── pre-commit                 # Secret scanner hook
│
├── .env.example                  # Template (safe to commit)
├── .env                          # ⚠️  NEVER commit
├── .gitignore                    # Protects sensitive files
│
├── wizard/
│  ├── run.js                     # Main deployment script
│  └── transfer.js                # Token transfer script
│
├── core/
│  ├── blockchain.js              # Blockchain integration
│  ├── prompt.js                  # User prompts
│  └── results.js                 # Result reporting
│
└── results/                      # Deployment receipts
```

## Environment Variables

### Required

| Variable | Example | Purpose |
|----------|---------|---------|
| `PRIVATE_KEY` | `0xabc123...` | Deployer wallet private key (64 hex chars) |
| `RPC_URL` | `https://bsc-dataseed1.binance.org` | Network RPC endpoint |

### Optional

| Variable | Example | Purpose |
|----------|---------|---------|
| `TOKEN_ADDRESS` | `0x123...` | Token contract address for transfers |
| `BSC_PRIVATE_KEY` | `0xdef456...` | BSC-specific deployer key |
| `BSCSCAN_API_KEY` | `ABC123XYZ` | BscScan verification |
| `ALCHEMY_URL` | `https://eth-mainnet.g.alchemy.com/v2/...` | Alchemy endpoint |

## Setup Workflow

### Step-by-Step

```
1. Clone Repository
   └─ git clone https://github.com/TZGT-PARTNERS-SOLUTION-LLC/token-distribution.git
   └─ cd token-distribution

2. Create Environment
   └─ cp .env.example .env
   └─ Edit .env with your credentials

3. Install Dependencies
   └─ npm install

4. Test Configuration
   └─ node wizard/run.js --dry-run

5. Validate Security
   └─ Review SECURITY-CHECKLIST.md

6. Deploy Token
   └─ node wizard/run.js

7. Verify Deployment
   └─ Check results/deploy_<timestamp>.json
   └─ Verify on blockchain

8. Archive Results
   └─ Safely store receipt
   └─ Update audit log
```

## Network Configuration

### Public Networks

| Network | RPC Endpoint | Testnet | Purpose |
|---------|---|---|---|
| **BSC** | https://bsc-dataseed1.binance.org | https://data-seed-prebsc-1-s0-testnet.bnbchain.org:8545 | Primary (Binance) |
| **Ethereum** | https://eth-mainnet.g.alchemy.com/v2/KEY | https://sepolia.infura.io/v3/KEY | Fallback |
| **Polygon** | https://polygon-rpc.com | https://rpc-mumbai.maticvigil.com | Alternative |

### Setting RPC URL

```bash
# In .env file
RPC_URL=https://bsc-dataseed1.binance.org  # Mainnet
RPC_URL=https://data-seed-prebsc-1-s0-testnet.bnbchain.org:8545  # Testnet
```

## Security Layers

### Layer 1: File Protection
- `.env` excluded from git via `.gitignore`
- Results directory excluded (contains transaction data)
- Enhanced `.gitignore` patterns added

### Layer 2: Git Hooks
- Pre-commit hook scans for secrets
- Prevents accidental credential commits
- Auto-enables when repo is cloned

### Layer 3: GitHub Actions
- Secrets stored in GitHub vault
- Requires explicit approval for mainnet
- Environment-based protection
- Audit logs all access

### Layer 4: Runtime Protection
- Private keys never logged to console
- Credentials loaded from environment only
- In-memory processing (no storage)
- Automatic cleanup after deployment

## Common Tasks

### Initialize Repository for Private Setup

```bash
# 1. Clone repo
git clone https://github.com/TZGT-PARTNERS-SOLUTION-LLC/token-distribution.git
cd token-distribution

# 2. Setup git hooks
git config core.hooksPath .githooks
chmod +x .githooks/pre-commit

# 3. Create environment file
cp .env.example .env

# 4. Edit with your values
# Use your preferred editor:
nano .env          # Linux/Mac
code .env          # VS Code
vim .env           # Vim
```

### Deploy to Testnet

```bash
RPC_URL=https://data-seed-prebsc-1-s0-testnet.bnbchain.org:8545 node wizard/run.js --dry-run
RPC_URL=https://data-seed-prebsc-1-s0-testnet.bnbchain.org:8545 node wizard/run.js
```

### Deploy to Mainnet

```bash
# Always test on testnet first!
node wizard/run.js --dry-run
node wizard/run.js
```

### Rotate Private Keys

```bash
# 1. Generate new key
node -e "const {Wallet} = require('ethers'); console.log(Wallet.createRandom().privateKey)"

# 2. Update .env
nano .env

# 3. Update GitHub secrets
# GitHub Settings → Secrets and variables → Actions

# 4. Test new key
node wizard/run.js --dry-run

# 5. Proceed with deployment
node wizard/run.js
```

### Setup GitHub Actions

```bash
# 1. Create GitHub secrets
# GitHub Settings → Secrets and variables → Actions
#   - PRIVATE_KEY: your deployer wallet key
#   - RPC_URL: your network RPC endpoint

# 2. Copy workflow files
mkdir -p .github/workflows
# (Already exists in repo, just update secrets)

# 3. Trigger manual deployment
# GitHub Actions → [workflow name] → Run workflow
```

## Emergency Procedures

### If Private Key is Leaked

1. **IMMEDIATE:** Delete GitHub secret
   ```
   GitHub Settings → Secrets → Delete PRIVATE_KEY
   ```

2. **URGENT:** Transfer all funds from compromised key
   - Use different wallet for transfer
   - Verify all balance moved

3. **URGENT:** Update with new key
   ```bash
   nano .env
   # Update PRIVATE_KEY with new value
   ```

4. **URGENT:** Update GitHub secret
   ```
   GitHub Settings → Secrets → Edit PRIVATE_KEY
   ```

5. **CRITICAL:** Review all recent transactions
   - Check blockchain explorer
   - Verify no unauthorized deployments

### If Deployment Fails

1. Check error message in console
2. Review `SECURITY-CHECKLIST.md`
3. Run with `--dry-run` to test
4. Verify wallet has sufficient gas
5. Try from different network RPC

### If You Lose Your Private Key

**DO NOT:**
- Attempt to recover (cryptographically impossible)
- Share recovery phrases
- Use services claiming to recover keys

**DO:**
- Consider funds in wallet as lost (if mainnet)
- Generate completely new key
- Deploy with new key to new wallet

## Support Resources

### Documentation Links

- [Ethers.js Documentation](https://docs.ethers.org/)
- [BSC Developer Guide](https://www.bnbchain.org/en/developers)
- [GitHub Actions Secrets](https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions)
- [OWASP Secrets Management](https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html)

### Explorer Links

- [BscScan (BSC)](https://bscscan.com/)
- [Etherscan (Ethereum)](https://etherscan.io/)
- [PolygonScan (Polygon)](https://polygonscan.com/)

## Document Maintenance

### Last Updated
- 2024-01-15 - Initial setup documentation
- 2024-01-15 - Enhanced security guidelines
- 2024-01-15 - GitHub Actions configuration

### Review Schedule
- Monthly: Security checklist
- Quarterly: Dependency updates
- Bi-annually: Key rotation

### Contributing Changes
- All documentation updates require code review
- Security changes need approval from team leads
- Documentation should stay current with code

---

## Quick Help

**Lost? Follow this path:**

1. **First time setup?** → [QUICK-REFERENCE.md](./QUICK-REFERENCE.md)
2. **Need detailed setup?** → [PRIVATE-SETUP.md](./PRIVATE-SETUP.md)
3. **Before deployment?** → [SECURITY-CHECKLIST.md](./SECURITY-CHECKLIST.md)
4. **GitHub Actions?** → [GITHUB-SECRETS-SETUP.md](./GITHUB-SECRETS-SETUP.md)
5. **Emergency?** → Read "Emergency Procedures" section above

**Can't find answer?** Check the `README.md` in project root.
