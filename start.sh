#!/usr/bin/env bash
# VinylVault — servidor local
# Uso: ./start.sh          (porta 8080 por defeito)
#      ./start.sh 3000     (porta personalizada)

PORT=${1:-8082}
DIR="$(cd "$(dirname "$0")" && pwd)"

echo ""
echo "  🎵  VinylVault"
echo "  ─────────────────────────────────────────"
echo "  URL local:  http://localhost:$PORT"
echo "  Pasta:      $DIR"
echo "  Para parar: Ctrl+C"
echo "  ─────────────────────────────────────────"
echo ""

# Abre o browser automaticamente (Mac e Linux)
if command -v open &>/dev/null; then
  sleep 0.8 && open "http://localhost:$PORT" &
elif command -v xdg-open &>/dev/null; then
  sleep 1.0 && xdg-open "http://localhost:$PORT" &
fi

# Inicia o servidor Python na pasta do script
cd "$DIR"
python3 -m http.server "$PORT"
