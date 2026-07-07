# Quick Start Guide

## Run the wizard

**PowerShell**

```powershell
.\run.ps1
```

**Windows CMD**

```bat
run.bat
```

**Linux / macOS**

```bash
bash run.sh
```

**Direct Node.js**

```bash
node wizard/run.js
```

## Optional setup

Create a `.env` file from `.env.example` if you want to prefill your private key and RPC URL.

## Dry run

```bash
node wizard/run.js --dry-run
```

## GitHub Pages landing page

Build the static Pages frontend locally with:

```bash
npm ci
npm run build:pages
```

Then open `dist/index.html` to preview the deployed landing page output.
