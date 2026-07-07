#!/usr/bin/env node

const path = require('path');
const fs = require('fs-extra');

async function buildPagesSite() {
  const rootDir = path.resolve(__dirname, '..');
  const sourceDir = path.join(rootDir, 'site');
  const outputDir = path.join(rootDir, 'dist');

  if (!(await fs.pathExists(sourceDir))) {
    throw new Error(`Pages source directory not found: ${sourceDir}`);
  }

  await fs.emptyDir(outputDir);
  await fs.copy(sourceDir, outputDir);

  const indexPath = path.join(outputDir, 'index.html');
  const fallbackPath = path.join(outputDir, '404.html');

  await fs.copy(indexPath, fallbackPath);
  await fs.writeFile(path.join(outputDir, '.nojekyll'), '');

  console.log(`Built GitHub Pages site in ${outputDir}`);
}

buildPagesSite().catch((error) => {
  console.error(error.message);
  process.exit(1);
});
