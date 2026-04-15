#!/bin/bash
set -e

# Launcher for aretta MCP server (OpenCode).
# Downloads the compiled binary + mutagen + ws-bridge on first use.
# No runtime dependencies (no bun, no npm).

ARETTA_BIN="${HOME}/.aretta/bin"
BINARY="$ARETTA_BIN/aretta-proof-mcp"
PROOF_MCP_VERSION="0.3.2"
MUTAGEN_VERSION="0.17.6"
WS_BRIDGE_VERSION="1.0.0"

mkdir -p "$ARETTA_BIN"

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
case "$ARCH" in x86_64) ARCH="amd64";; aarch64|arm64) ARCH="arm64";; esac

# --- Download proof-mcp binary (re-downloads if version changed) ---
VERSION_FILE="$ARETTA_BIN/.aretta-proof-mcp-version"
CURRENT_VERSION=""
if [ -f "$VERSION_FILE" ]; then CURRENT_VERSION=$(cat "$VERSION_FILE"); fi

if [ ! -f "$BINARY" ] || [ "$CURRENT_VERSION" != "$PROOF_MCP_VERSION" ]; then
  echo "Downloading aretta-proof-mcp v${PROOF_MCP_VERSION}..." >&2
  URL="https://aretta.ai/releases/aretta-proof-mcp/v${PROOF_MCP_VERSION}/aretta-proof-mcp-${OS}-${ARCH}"
  if ! curl -fsSL "$URL" -o "$BINARY"; then
    echo "Error: Failed to download aretta-proof-mcp from $URL" >&2
    echo "You may need to build from source: cd aretta-code/packages/proof-mcp && bun build src/index.ts --compile --outfile ~/.aretta/bin/aretta-proof-mcp" >&2
    exit 1
  fi
  chmod +x "$BINARY"
  echo "$PROOF_MCP_VERSION" > "$VERSION_FILE"
  echo "aretta-proof-mcp v${PROOF_MCP_VERSION} installed" >&2
fi

# --- Download mutagen ---
if [ ! -f "$ARETTA_BIN/mutagen" ]; then
  echo "Downloading mutagen v${MUTAGEN_VERSION}..." >&2
  curl -fsSL "https://github.com/mutagen-io/mutagen/releases/download/v${MUTAGEN_VERSION}/mutagen_${OS}_${ARCH}_v${MUTAGEN_VERSION}.tar.gz" \
    -o /tmp/mutagen.tar.gz
  tar -xzf /tmp/mutagen.tar.gz -C "$ARETTA_BIN" mutagen mutagen-agents.tar.gz 2>/dev/null || true
  if [ -f "$ARETTA_BIN/mutagen-agents.tar.gz" ]; then
    tar -xzf "$ARETTA_BIN/mutagen-agents.tar.gz" -C /tmp "${OS}_${ARCH}" 2>/dev/null || true
    mv "/tmp/${OS}_${ARCH}" "$ARETTA_BIN/mutagen-agent" 2>/dev/null || true
    rm -f "$ARETTA_BIN/mutagen-agents.tar.gz"
  fi
  chmod +x "$ARETTA_BIN/mutagen" "$ARETTA_BIN/mutagen-agent" 2>/dev/null || true
  rm -f /tmp/mutagen.tar.gz
  echo "mutagen installed" >&2
fi

# --- Download ws-bridge ---
if [ ! -f "$ARETTA_BIN/ws-bridge" ]; then
  echo "Downloading ws-bridge v${WS_BRIDGE_VERSION}..." >&2
  WS_URL="https://aretta.ai/releases/ws-bridge/v${WS_BRIDGE_VERSION}/ws-bridge-${OS}-${ARCH}"
  if curl -fsSL "$WS_URL" -o "$ARETTA_BIN/ws-bridge" 2>/dev/null; then
    chmod +x "$ARETTA_BIN/ws-bridge"
    echo "ws-bridge installed" >&2
  else
    echo "Warning: could not download ws-bridge. File sync will not work." >&2
  fi
fi

# --- Run the binary (cwd is user's project directory, set by Claude Code) ---
exec "$BINARY"
