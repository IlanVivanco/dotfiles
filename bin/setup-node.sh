#!/bin/bash

set -e

# ─── NVM ─────────────────────────────────────────────────────────────────────
if [ -d "$HOME/.nvm" ]; then
  echo "✓ nvm already installed, skipping."
else
  echo "→ Installing nvm v0.40.3..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# ─── Node.js LTS ─────────────────────────────────────────────────────────────
if command -v node &>/dev/null; then
  echo "✓ Node.js $(node -v) already installed, skipping."
else
  echo "→ Installing Node.js LTS..."
  nvm install --lts
  nvm use --lts
  nvm alias default 'lts/*'
fi

# ─── Bun ─────────────────────────────────────────────────────────────────────
if command -v bun &>/dev/null; then
  echo "✓ bun $(bun --version) already installed, skipping."
else
  echo "→ Installing bun..."
  curl -fsSL https://bun.sh/install | bash
fi

# ─── npm global packages ─────────────────────────────────────────────────────
# Note: npx is bundled with npm and does not need to be installed separately.
NPM_GLOBALS=(
  npm-check-updates
  pnpm
  yarn
  typescript
  ts-node
  prettier
  eslint
  nodemon
  http-server
  cloudflared
  gulp-cli
  netlify-cli
  @wordpress/scripts
)

echo "→ Installing global npm packages..."
npm install -g "${NPM_GLOBALS[@]}"

echo "✓ Node.js setup complete."
