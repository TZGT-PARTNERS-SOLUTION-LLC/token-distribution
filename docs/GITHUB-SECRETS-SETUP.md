# GitHub Secrets Configuration

Complete guide for setting up secure GitHub Actions for token deployment.

## Step 1: Create GitHub Secrets

### Navigate to Secrets

1. Go to your GitHub repo
2. Click **Settings** (top right)
3. Click **Secrets and variables** → **Actions** (left sidebar)
4. Click **New repository secret**

### Required Secrets

Create these secrets in GitHub:

| Secret Name | Description | Example |
|---|---|---|
| `PRIVATE_KEY` | Deployer wallet private key | `0xabc123...` (64 hex chars) |
| `RPC_URL` | Network RPC endpoint | `https://bsc-dataseed1.binance.org` |

### Optional Secrets (if using)

| Secret Name | Description | Example |
|---|---|---|
| `BSC_PRIVATE_KEY` | BSC-specific deployer key | `0xdef456...` |
| `BSCSCAN_API_KEY` | BscScan API key for verification | `ABC123XYZ` |
| `ALCHEMY_URL` | Alchemy endpoint | `https://eth-mainnet.g.alchemy.com/v2/...` |

## Step 2: Verify Secrets Are Masked

GitHub automatically masks secret values in logs:

```bash
✓ Correct: Secret appears as *** in logs
✗ Wrong: Secret appears in plain text in logs
```

Example safe output:
```
Setting up deployment...
Using private key: ***
Using RPC: https://bsc-dataseed1.binance.org
Deploying token...
```

## Step 3: Create Secure Workflow

### Create Workflow File

Create `.github/workflows/deploy-token.yml`:

```yaml
name: Deploy Token

on:
  workflow_dispatch:  # Manual trigger only
  
jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        with:
          persist-credentials: false  # IMPORTANT: Don't persist GitHub credentials
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
      
      - name: Install dependencies
        run: npm install --production
      
      - name: Dry run validation
        env:
          PRIVATE_KEY: ${{ secrets.PRIVATE_KEY }}
          RPC_URL: ${{ secrets.RPC_URL }}
        run: node wizard/run.js --dry-run
      
      - name: Deploy token (requires approval)
        if: github.event_name == 'workflow_dispatch'
        env:
          PRIVATE_KEY: ${{ secrets.PRIVATE_KEY }}
          RPC_URL: ${{ secrets.RPC_URL }}
          BSC_PRIVATE_KEY: ${{ secrets.BSC_PRIVATE_KEY }}
          BSCSCAN_API_KEY: ${{ secrets.BSCSCAN_API_KEY }}
          ALCHEMY_URL: ${{ secrets.ALCHEMY_URL }}
        run: node wizard/run.js
      
      - name: Upload deployment receipt
        if: always()
        uses: actions/upload-artifact@v3
        with:
          name: deployment-receipt
          path: results/
          retention-days: 90
          if-no-files-found: ignore
```

## Step 4: Environment-Specific Workflows

### For Multiple Networks

Create separate workflows for testnet vs. mainnet:

**`.github/workflows/deploy-testnet.yml`**
```yaml
name: Deploy to Testnet

on:
  workflow_dispatch:

jobs:
  deploy-testnet:
    runs-on: ubuntu-latest
    environment: testnet  # Requires approval
    
    steps:
      - uses: actions/checkout@v4
        with:
          persist-credentials: false
      
      - uses: actions/setup-node@v4
        with:
          node-version: '18'
      
      - run: npm install --production
      
      - env:
          PRIVATE_KEY: ${{ secrets.TESTNET_PRIVATE_KEY }}
          RPC_URL: https://data-seed-prebsc-1-s0-testnet.bnbchain.org:8545
        run: node wizard/run.js
```

**`.github/workflows/deploy-mainnet.yml`**
```yaml
name: Deploy to Mainnet

on:
  workflow_dispatch:

jobs:
  deploy-mainnet:
    runs-on: ubuntu-latest
    environment: mainnet  # Requires approval + human review
    
    steps:
      - uses: actions/checkout@v4
        with:
          persist-credentials: false
      
      - uses: actions/setup-node@v4
        with:
          node-version: '18'
      
      - run: npm install --production
      
      - env:
          PRIVATE_KEY: ${{ secrets.MAINNET_PRIVATE_KEY }}
          RPC_URL: https://bsc-dataseed1.binance.org
        run: node wizard/run.js
```

## Step 5: Branch Protection & Approvals

### Require Manual Approval

1. Go to **Settings** → **Environments**
2. Click **New environment** or edit existing
3. Add required reviewers
4. Configure deployment branches

### Example: Mainnet Environment Protection

```
Environment name: mainnet
Deployment branches: Only selected branches → main
Required reviewers: ✓ Require reviewers
Reviewers: Add team members (min 2 for mainnet)
```

## Step 6: Audit Logs

### Monitor Secret Access

GitHub logs all secret access:

1. Go to **Settings** → **Audit log**
2. Filter by action: `workflows.approve_workflow_run`
3. Review all deployments and approvals

Example log entries:
```
User X approved workflow run Y on repo Z
Workflow completed with status: success
Artifacts uploaded: deployment-receipt
```

## Step 7: Rotate Secrets

### Monthly Rotation (Recommended)

```bash
# Generate new private key
node -e "const {Wallet} = require('ethers'); const w = Wallet.createRandom(); console.log(w.privateKey)"

# Transfer funds to new address
# Update GitHub secret with new key
# Verify new key in dry run
```

### Rotation Checklist

- [ ] Generate new private key
- [ ] Transfer funds to new wallet
- [ ] Update `PRIVATE_KEY` secret in GitHub
- [ ] Run dry run with new key
- [ ] Confirm old key is no longer used
- [ ] Archive old key securely
- [ ] Document rotation in audit log

## Step 8: Security Best Practices

### DO

- ✓ Use separate keys for testnet and mainnet
- ✓ Require manual approval for mainnet deployments
- ✓ Rotate keys monthly
- ✓ Use `persist-credentials: false` in checkout
- ✓ Review audit logs regularly
- ✓ Keep workflow files in main branch only
- ✓ Test on testnet first

### DON'T

- ✗ Don't hardcode secrets in workflow files
- ✗ Don't echo secrets in logs
- ✗ Don't share secrets in PRs or comments
- ✗ Don't store secrets outside GitHub Secrets
- ✗ Don't use the same key for multiple networks
- ✗ Don't allow PRs from forks to access secrets
- ✗ Don't commit `.env` files

## Step 9: Troubleshooting

### Secrets Not Available

**Problem:** `env.PRIVATE_KEY` is undefined

**Solution:** 
1. Verify secret name matches exactly (case-sensitive)
2. Restart workflow run
3. Check GitHub Secrets configuration

### Workflow Fails with Auth Error

**Problem:** "Unauthorized" or "Invalid private key"

**Solution:**
1. Verify private key format: `0x` + 64 hex characters
2. Test locally: `node wizard/run.js --dry-run`
3. Check RPC URL is correct and accessible

### Artifacts Not Saved

**Problem:** No deployment receipt in artifacts

**Solution:**
1. Check if `results/` directory is created
2. Verify `upload-artifact` step runs after deployment
3. Check retention-days setting (default 90 days)

## Step 10: Access Control

### Repository Access

Restrict who can:
- Trigger deployments
- Approve mainnet deployments
- View secrets (only admins)

Go to **Settings** → **Collaborators and teams** to manage access.

### Team Collaboration

Example team roles:
- **Admins**: Can manage secrets, approve mainnet
- **Developers**: Can trigger testnet, view logs
- **Auditors**: Can view audit logs, receipt artifacts

## Emergency Secret Revocation

If a secret is compromised:

1. **Immediately** update the secret in GitHub
2. Edit **Settings** → **Secrets and variables**
3. Click secret name → Update value
4. All workflows use new secret on next run

Example:
```
OLD: 0xabc123...
NEW: 0xdef456... (new key from new wallet)
```

No workflow restarts needed—new value takes effect immediately.
