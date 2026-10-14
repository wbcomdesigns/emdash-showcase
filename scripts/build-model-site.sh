#!/usr/bin/env bash
# Build the Fieldnote showcase database from the model data in model/ (content, settings,
# menus, categories and stock photos). Replaces data.db. Plugins are installed afterwards
# from the EmDash registry in the admin (see README.md).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
npx astro dev stop >/dev/null 2>&1 || true
rm -f data.db data.db-wal data.db-shm
mkdir -p uploads && cp -R model/uploads/. uploads/
npx emdash seed model/fieldnote-seed.json --on-conflict update >/dev/null
python3 -I - data.db model/media.json model/images.json <<'PY'
import json, sqlite3, sys
db = sqlite3.connect(sys.argv[1])
cols = {r[1] for r in db.execute("PRAGMA table_info(media)")}
for row in json.load(open(sys.argv[2])):
    row = {k: v for k, v in row.items() if k in cols}
    db.execute(f"INSERT OR REPLACE INTO media ({', '.join(row)}) VALUES ({', '.join('?' * len(row))})", list(row.values()))
for img in json.load(open(sys.argv[3])):
    db.execute(f'UPDATE "ec_{img["collection"]}" SET "{img["field"]}" = ? WHERE slug = ?', (json.dumps(img["value"]), img["slug"]))
db.commit()
PY
echo "Fieldnote built in $ROOT/data.db. Next: npm run dev, then install the five plugins from Admin > Plugins > Registry (see README.md)."
