# Private Setup Quick Reference

Fast setup checklist for the Token Distribution Wizard.

## 5-Minute Setup

```bash
# 1. Clone and navigate
git clone https://github.com/TZGT-PARTNERS-SOLUTION-LLC/token-distribution.git
cd token-distribution

# 2. Create environment file
cp .env.example .env

# 3. Edit with your credentials (use your editor)
nano .env  # or code .env / vim .env

# 4. Install dependencies
npm install

# 5. Dry run test
node wizard/run.js --dry-run

# 6. Deploy (if dry run succeeds)
node wizard/run.js
```

## Required Environment Variables

```env
PRIVATE_KEY=0x...              # Your deployer wallet private key (64 hex chars)
RPC_URL=https://...            # Network RPC endpoint (HTTPS only)
```

## Key Formats

### Private Key (64 hex characters)

```
✓ VALID:   0xabc123def456...   (with 0x prefix)
✓ VALID:   abc123def456...     (without 0x prefix)
✗ INVALID: abc123...           (too short)
✗ INVALID: 0xZZZ               (non-hex characters)
```

### RPC URL

```
✓ VALID:   https://bsc-dataseed1.binance.org
✓ VALID:   https://eth-mainnet.g.alchemy.com/v2/YOUR_KEY
✓ VALID:   https://sepolia.infura.io/v3/YOUR_KEY
✗ INVALID: http://localhost    (not HTTPS)
✗ INVALID: bsc-dataseed1...    (no protocol)
```

## Common Errors & Fixes

### Error: `PRIVATE_KEY not found`

**Fix:** Add `PRIVATE_KEY` to `.env` file
```bash
echo 'PRIVATE_KEY=0x...' >> .env
```

### Error: `Invalid private key length`

**Fix:** Key must be 64 hex characters (plus optional 0x)
```bash
# Check length (should be 64, not counting 0x)
echo -n 'abc123...' | wc -c
```

### Error: `RPC endpoint unreachable`

**Fix:** Verify RPC URL is correct and online
```bash
curl -X POST https://bsc-dataseed1.binance.org \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"net_version","params":[],"id":1}'
```

### Error: `Insufficient gas`

**Fix:** Deployer wallet needs minimum balance:
- **BSC:** 0.5+ BNB
- **Ethereum:** 0.5+ ETH
- **Polygon:** 10+ MATIC

## Verify Setup

```bash
# 1. Check environment loaded
node -e "console.log(process.env.PRIVATE_KEY ? 'OK' : 'MISSING')"

# 2. Test RPC connection
node wizard/run.js --dry-run

# 3. Verify file permissions
ls -la .env    # Should show -rw-r--r-- (not executable)

# 4. Confirm .env in .gitignore
grep '.env' .gitignore
```

## Network Information

| Network | RPC Endpoint | Chain ID | Token |
|---------|---|---|---|
| BSC Mainnet | https://bsc-dataseed1.binance.org | 56 | BNB |
| BSC Testnet | https://data-seed-prebsc-1-s0-testnet.bnbchain.org:8545 | 97 | tBNB |
| Ethereum | https://eth-mainnet.g.alchemy.com/v2/KEY | 1 | ETH |
| Sepolia Testnet | https://sepolia.infura.io/v3/KEY | 11155111 | SEP |

## Security Reminders

- **NEVER** commit `.env` file
- **NEVER** share private key
- **ALWAYS** test on testnet first
- **ALWAYS** verify recipient address multiple times
- **ROTATE** keys after production deployments

## Get Help

| Topic | File |
|-------|------|
| Full setup guide | `docs/PRIVATE-SETUP.md` |
| Security checklist | `docs/SECURITY-CHECKLIST.md` |
| GitHub Actions setup | `docs/GITHUB-SECRETS-SETUP.md` |
| General info | `README.md` |

## File Locations

```
project-root/
├── .env                          # ⚠️  NEVER commit (local credentials)
├── .env.example                  # ✓ Safe to commit (template only)
├── docs/
│  ├── PRIVATE-SETUP.md          # Detailed setup guide
│  ├── SECURITY-CHECKLIST.md     # Pre-deployment validation
│  ├── GITHUB-SECRETS-SETUP.md   # CI/CD secrets
│  └── QUICK-REFERENCE.md        # This file
├── results/                      # Deployment receipts
├── wizard/                       # Deployment scripts
└── .gitignore                    # Protects sensitive files
```

## Deployment Workflow

```
1. Setup
   └─ Create .env with credentials

2. Validation
   └─ node wizard/run.js --dry-run

3. Review
   └─ Check console output for correctness

4. Deploy
   └─ node wizard/run.js

5. Verify
   └─ Check results/deploy_<timestamp>.json
   └─ Confirm transaction on blockchain
   └─ Check recipient wallet received tokens

6. Archive
   └─ Safely store receipt and audit log
   └─ Clean up results/ if needed
```

## Testnet vs Mainnet

### Testnet (SAFE - Use for testing)
```bash
RPC_URL=https://data-seed-prebsc-1-s0-testnet.bnbchain.org:8545
# Get testnet funds at: https://testnet.binance.org/faucet-smart
```

### Mainnet (LIVE - Real transactions, real money)
```bash
RPC_URL=https://bsc-dataseed1.binance.org
# Uses REAL BNB for gas - be careful!
```

**Always test on testnet first!**

## Post-Deployment

```bash
# 1. View receipt
cat results/deploy_*.json | jq

# 2. Check on block explorer
# BSC: https://bscscan.com/tx/0xTxHash

# 3. Verify token in wallet
# Add token contract address to wallet

# 4. Review audit log
cat .private-audit.log  # If created
```

## Emergency Commands

### If Private Key Compromised

```bash
# 1. Immediately revoke in GitHub
# Settings → Secrets → Delete PRIVATE_KEY

# 2. Update local .env with new key
nano .env

# 3. Update GitHub secret
# Settings → Secrets → New secret PRIVATE_KEY

# 4. Verify old key no longer works
# (don't share the old key with anyone)
```

### Rotate Keys

```bash
# 1. Generate new key
node -e "const {Wallet} = require('ethers'); console.log(Wallet.createRandom().privateKey)"

# 2. Transfer funds to new wallet
# (manual transaction)

# 3. Update .env
nano .env

# 4. Test with dry run
node wizard/run.js --dry-run

# 5. Proceed with deployment
node wizard/run.js
```

## Links

- **Binance Smart Chain:** https://www.bnbchain.org/
- **BscScan Explorer:** https://bscscan.com/
- **Ethers.js Docs:** https://docs.ethers.org/
- **Security Best Practices:** https://cheatsheetseries.owasp.org/

---

**Questions?** Review the full guides in `docs/` directory.
