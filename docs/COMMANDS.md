# Token Distribution Wizard - Commands Reference

## 🚀 Core Operations

### Setup & Installation
```bash
# Install dependencies
npm install

# Copy environment template
cp .env.example .env

# Edit configuration
nano .env          # macOS/Linux
notepad .env       # Windows
```

### Dry Run (TEST FIRST!)
```bash
# Test configuration without sending transactions
node wizard/run.js --dry-run

# Test with specific network
node wizard/run.js --dry-run --network=sepolia

# Test with specific CSV file
node wizard/run.js --dry-run --input=data/recipients.csv

# Verbose dry run (detailed logging)
node wizard/run.js --dry-run --verbose
```

### Production Deployment
```bash
# Deploy to testnet (ALWAYS do this first)
node wizard/run.js --network=sepolia

# Deploy to mainnet (CAREFULLY)
node wizard/run.js --network=mainnet

# Deploy specific CSV file
node wizard/run.js --input=data/distribution-batch-1.csv

# Deploy with custom gas settings
node wizard/run.js --gas-price=50 --gas-limit=500000

# Deploy with confirmation prompts
node wizard/run.js --interactive
```

---

## 🔐 Environment & Secrets Management

### Local Setup
```bash
# View loaded environment variables (SAFE - no secrets printed)
npm run env:check

# Validate environment configuration
npm run validate:env

# Test connection to RPC endpoint
npm run test:rpc

# Verify private key format
npm run verify:key
```

### GitHub Secrets (CI/CD)
```bash
# Using GitHub CLI
gh secret set PRIVATE_KEY < private-key.txt
gh secret set RPC_URL --body "https://your-rpc.com"
gh secret set NETWORK --body "mainnet"
gh secret set RECIPIENT_CSV --body "$(cat data/recipients.csv | base64)"

# List all secrets
gh secret list

# Delete secret
gh secret delete PRIVATE_KEY

# Update secret
gh secret set PRIVATE_KEY --body "new-key-value"
```

### Key Rotation
```bash
# Generate new key pair (local)
npm run generate:keypair

# Export public address from existing key
npm run export:address

# Rotate to new key (step by step)
1. Generate new keypair: npm run generate:keypair
2. Fund new address with test tokens
3. Update GitHub secret: gh secret set PRIVATE_KEY
4. Deploy test transaction
5. Archive old key: tar czf old-key-backup.tar.gz .env
```

---

## 📊 Data & CSV Operations

### Prepare Recipients List
```bash
# Validate CSV format
npm run validate:csv --input=data/recipients.csv

# Check for duplicate addresses
npm run check:duplicates --input=data/recipients.csv

# Calculate total distribution
npm run calculate:total --input=data/recipients.csv

# Split large CSV into batches
npm run split:csv --input=data/recipients.csv --batch-size=100

# Merge multiple CSVs
npm run merge:csv --files=batch1.csv,batch2.csv --output=combined.csv
```

### Preview Distribution
```bash
# Show distribution plan
npm run preview --input=data/recipients.csv

# Export distribution plan as JSON
npm run preview:json --input=data/recipients.csv > preview.json

# Show estimated gas costs
npm run estimate:gas --input=data/recipients.csv
```

---

## 📋 Status & Monitoring

### Check Distribution Status
```bash
# Show pending distributions
npm run status:pending

# Show completed distributions
npm run status:completed

# Show failed transactions
npm run status:failed

# Full status report
npm run status:full
```

### Transaction Verification
```bash
# Verify transaction on blockchain
npm run verify:tx --tx-hash=0x...

# Get balance of target address
npm run check:balance --address=0x...

# Get transaction receipt
npm run get:receipt --tx-hash=0x...

# Trace transaction details
npm run trace:tx --tx-hash=0x...
```

### Logs & Audit Trail
```bash
# View distribution logs
tail -f distribution_results_*.json

# View error logs
tail -f results/errors.log

# View audit trail
cat results/audit.log

# Search logs for specific address
grep "0xAddress" distribution_results_*.json
```

---

## 🧪 Testing & Validation

### Pre-Deployment Checks
```bash
# Run full validation suite
npm run validate:all

# Check network connectivity
npm run test:connection

# Validate gas settings
npm run validate:gas

# Verify contract interface
npm run validate:contract

# Check API health
npm run test:api-health
```

### Network Testing
```bash
# Test on Sepolia (testnet)
node wizard/run.js --network=sepolia --dry-run

# Test on Goerli (deprecated testnet)
node wizard/run.js --network=goerli --dry-run

# Test transaction simulation
npm run simulate:tx --input=data/recipients.csv
```

### Gas Estimation
```bash
# Estimate total gas
npm run estimate:gas --input=data/recipients.csv

# Estimate per-recipient gas
npm run estimate:gas:detailed --input=data/recipients.csv

# Show gas price trends
npm run gas:trends --network=mainnet
```

---

## 🔧 Maintenance & Cleanup

### Clean Up Files
```bash
# Remove old result files
npm run cleanup:results

# Remove log files
npm run cleanup:logs

# Clear temporary files
npm run cleanup:temp

# Full cleanup (safe)
npm run cleanup:all

# Archive results for storage
npm run archive:results
```

### Database/Cache Operations
```bash
# Reset internal state
npm run reset:state

# Clear cache
npm run clear:cache

# Rebuild cache
npm run rebuild:cache

# Verify data integrity
npm run verify:integrity
```

---

## 🛡️ Security & Compliance

### Security Checks
```bash
# Run security audit
npm run audit

# Check for exposed secrets
npm run check:secrets

# Validate Git hooks
npm run validate:hooks

# Run pre-commit check manually
./.githooks/pre-commit
```

### Key Management
```bash
# Encrypt private key
npm run encrypt:key --key-file=.env

# Decrypt private key (local only)
npm run decrypt:key

# Backup key safely
npm run backup:key

# Secure delete key from memory
npm run securely:delete-key
```

---

## 📡 GitHub Actions / CI-CD

### Trigger Workflows
```bash
# Trigger distribution workflow via GitHub CLI
gh workflow run distribute.yml -f network=sepolia

# View workflow runs
gh run list

# View specific workflow run
gh run view <run-id>

# Check workflow status
gh workflow list

# Enable/disable workflow
gh workflow enable distribute.yml
gh workflow disable distribute.yml
```

### Manage Pull Requests
```bash
# Create PR for code changes
gh pr create --title "Add new recipients" --body "Distribution batch 5"

# Check PR status
gh pr status

# Review PR
gh pr review <pr-number> --approve

# Merge PR
gh pr merge <pr-number> --auto --delete-branch
```

---

## 🐛 Debugging & Troubleshooting

### Debug Mode
```bash
# Run in verbose debug mode
DEBUG=* node wizard/run.js --dry-run

# Debug with additional logging
node wizard/run.js --dry-run --debug=all

# Debug specific component
DEBUG=wizard:tx npm run distribute
```

### Inspect Internal State
```bash
# Show parsed config
npm run debug:config

# Show recipient list
npm run debug:recipients --input=data/recipients.csv

# Show transaction queue
npm run debug:queue

# Trace execution flow
npm run debug:trace
```

### Error Recovery
```bash
# Retry failed transactions
npm run retry:failed

# Skip failed transaction and continue
npm run retry:skip --tx-hash=0x...

# Reset stuck transaction
npm run reset:tx --tx-hash=0x...

# Rollback last distribution (if possible)
npm run rollback:last
```

---

## 📚 Help & Documentation

### Get Help
```bash
# Show available commands
npm run help

# Show command help
npm run help -- --command=distribute

# Show examples
npm run examples

# Show FAQ
npm run faq
```

### Generate Reports
```bash
# Generate distribution report
npm run report:distribution

# Generate compliance report
npm run report:compliance

# Generate audit report
npm run report:audit

# Export all reports
npm run report:all --output=reports/
```

---

## 🚨 Emergency Commands

### If Something Goes Wrong
```bash
# IMMEDIATE: Stop all operations
npm run emergency:stop

# IMMEDIATE: Disable automated workflows
gh workflow disable distribute.yml

# IMMEDIATE: Revoke GitHub secret
gh secret delete PRIVATE_KEY

# Check what's stuck
npm run status:all

# Emergency rescue logs
npm run collect:emergency-logs

# Get support info
npm run support:info
```

### Key Compromise
```bash
# IF KEY IS EXPOSED:
1. Revoke immediately:
   gh secret delete PRIVATE_KEY

2. Generate new key:
   npm run generate:keypair

3. Export public address:
   npm run export:address

4. Drain old address (if mainnet):
   Transfer remaining funds to new address

5. Set new secret:
   gh secret set PRIVATE_KEY --body "new-key"

6. Verify new setup:
   node wizard/run.js --dry-run
```

---

## 🔗 Useful Blockchain Tools

### Manual Verification
```bash
# Etherscan URL for transaction
# Replace NETWORK and TX_HASH:
# Mainnet:  https://etherscan.io/tx/0xTX_HASH
# Sepolia:  https://sepolia.etherscan.io/tx/0xTX_HASH

# Check address balance
# https://etherscan.io/address/0xYOUR_ADDRESS

# View token contract
# https://etherscan.io/token/0xTOKEN_ADDRESS
```

---

## 📝 Quick Reference Table

| Task | Command |
|------|---------|
| **Test Before Deploy** | `node wizard/run.js --dry-run` |
| **Deploy to Testnet** | `node wizard/run.js --network=sepolia` |
| **Deploy to Mainnet** | `node wizard/run.js --network=mainnet` |
| **Check Status** | `npm run status:full` |
| **Validate CSV** | `npm run validate:csv --input=data/recipients.csv` |
| **Estimate Gas** | `npm run estimate:gas --input=data/recipients.csv` |
| **View Logs** | `tail -f distribution_results_*.json` |
| **Rotate Key** | `npm run generate:keypair` |
| **Emergency Stop** | `npm run emergency:stop` |

---

## 📞 Support & Resources

- **Documentation**: `docs/` directory
- **Quick Start**: `docs/QUICK-REFERENCE.md`
- **Security**: `docs/SECURITY-CHECKLIST.md`
- **Setup Guide**: `docs/PRIVATE-SETUP.md`
- **GitHub Issues**: Report bugs in Issues tab
- **Logs**: Check `results/` and `*.log` files

---

**Last Updated**: 2026-07-08
**Version**: 1.0.0
