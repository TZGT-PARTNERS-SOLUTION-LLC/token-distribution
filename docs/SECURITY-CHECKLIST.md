# Security Checklist

Pre-deployment security validation for the Token Distribution Wizard.

## Before First Run

- [ ] Node.js version 18+ installed (`node --version`)
- [ ] `.env` file created from `.env.example`
- [ ] Private key loaded with proper format (0x prefix optional)
- [ ] RPC URL is HTTPS (not HTTP) and valid
- [ ] Deployer wallet address matches your key
- [ ] Wallet has sufficient gas (>0.5 BNB for BSC, varies by network)

## Source Code Review

- [ ] No hardcoded private keys in any `.js` files
- [ ] No hardcoded private keys in any `.py` files
- [ ] No credentials in `.env.example` (should be placeholders only)
- [ ] No API keys in comments or console.log statements
- [ ] All sensitive data marked with comments: `// PRIVATE` or `# PRIVATE`

## Environment Setup

- [ ] `.env` is listed in `.gitignore`
- [ ] `.env.*` pattern covers all local env files
- [ ] `!.env.example` allows `.env.example` to be tracked
- [ ] Results directory in `.gitignore` (contains transaction data)
- [ ] No `.env.local` files accidentally committed
- [ ] `push_and_private.ps1` marked private in `.gitignore`

## Git Configuration

- [ ] `.git/config` does not contain credentials
- [ ] Git global config clean (`git config --global --list`)
- [ ] No sensitive data in git history
- [ ] Branch protection on main (if team workflow)
- [ ] Commit messages don't contain secrets

## Pre-Run Validation

```bash
# Check for accidentally committed secrets
git log -p -S "0x" --all | grep -i "private" | head -20
git grep "PRIVATE_KEY" -- '*.js' '*.py' '*.env'

# Verify .env is not tracked
git status .env
# Should output: nothing
```

## Dry Run Validation

```bash
node wizard/run.js --dry-run
```

Verify output:
- Correct deployer address
- Correct network
- Correct token parameters
- No error messages

## Post-Deployment

- [ ] Receipt file saved to `results/` directory
- [ ] Transaction confirmed on block explorer
- [ ] Token shows in recipient wallet
- [ ] Deployer gas balance decreased appropriately
- [ ] No funds remained on deployer (sweep if needed)

## GitHub Actions Setup (if applicable)

- [ ] GitHub secrets created for `PRIVATE_KEY`, `RPC_URL`
- [ ] No secrets hardcoded in workflow files
- [ ] Workflow file doesn't echo secrets (use action masking)
- [ ] `persist-credentials: false` set in checkout step
- [ ] Temporary credentials cleaned up after workflow

Example secure workflow step:
```yaml
- uses: actions/checkout@v4
  with:
    persist-credentials: false

- name: Deploy
  env:
    PRIVATE_KEY: ${{ secrets.PRIVATE_KEY }}
    RPC_URL: ${{ secrets.RPC_URL }}
  run: node wizard/run.js
```

## API & RPC Security

- [ ] RPC endpoint uses HTTPS
- [ ] RPC endpoint is from official source (Alchemy, Infura, etc.)
- [ ] No rate limits exceeded in production
- [ ] API keys rotated regularly (if using Alchemy, Infura, etc.)
- [ ] Consider using private RPC endpoint for sensitive deployments

## Key Rotation (Periodic)

Every 6 months or after incidents:

- [ ] Generate new private key
- [ ] Move funds to new key
- [ ] Update `.env` with new key
- [ ] Update GitHub secrets
- [ ] Archive old audit logs

## Incident Response

If private key is compromised:

1. **IMMEDIATE:** Kill GitHub workflows
2. **IMMEDIATE:** Revoke secrets in GitHub Settings
3. **IMMEDIATE:** Transfer funds from compromised key
4. **URGENT:** Generate new key and rotate
5. **URGENT:** Review all recent transactions
6. **URGENT:** Check for unauthorized contract interactions
7. Log incident and notify team

## Audit Logging

Maintain a private audit log (`.private-audit.log`, not in git):

```
2024-01-15 10:30:00 UTC: Deployed MyToken to 0xRecipient - Tx: 0xHash
2024-01-15 10:35:00 UTC: Transfer successful - 1M tokens received
```

## Tools for Verification

```bash
# Check for committed secrets
npm install -g git-secrets
git secrets --scan

# Validate private key format
node -e "const k = '0x123...'; console.log(k.length === 66 ? 'VALID' : 'INVALID')"

# Test RPC connection
curl -X POST <RPC_URL> \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"net_version","params":[],"id":1}'
```

## Final Deployment Readiness

- [ ] All checklist items complete
- [ ] Dry run passed without errors
- [ ] Recipient address verified multiple times
- [ ] Team approval (if required)
- [ ] Mainnet deployment? Use testnet first
- [ ] High value transaction? Consider insurance
- [ ] Ready to proceed confidently
