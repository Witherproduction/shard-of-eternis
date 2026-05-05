import math
import unicodedata
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
MD_PATH = ROOT / "Liste_Cartes_Chap_2.md"


def normalize_key(s: str) -> str:
    s = (s or "").strip().lower().replace("’", "'")
    s = unicodedata.normalize("NFKD", s)
    s = "".join(ch for ch in s if not unicodedata.combining(ch))
    out = []
    for ch in s:
        out.append(ch if ch.isalnum() else "_")
    s = "".join(out)
    while "__" in s:
        s = s.replace("__", "_")
    return s.strip("_")


def rarity_bonus(rarity: str) -> float:
    r = normalize_key(rarity)
    if r.startswith("leg"):
        return 1.5
    if r.startswith("epi"):
        return 1.0
    if r.startswith("rar"):
        return 0.5
    return 0.0


def parse_effect_value(s: str) -> float:
    s = (s or "").strip().replace(",", ".")
    if not s:
        return 0.0
    try:
        return float(s)
    except Exception:
        return 0.0


def parse_rows(md_text: str):
    lines = md_text.splitlines()
    header_idx = next(i for i, l in enumerate(lines) if l.startswith("| # | Monstre WoW |"))
    magies_idx = next(i for i, l in enumerate(lines) if l.startswith("## Magies"))
    rows = []
    for line in lines[header_idx + 2 : magies_idx]:
        if not line.startswith("|"):
            continue
        parts = [p.strip() for p in line.strip().strip("|").split("|")]
        parts += [""] * (18 - len(parts))
        rows.append(parts[:18])
    return rows


def main():
    text = MD_PATH.read_text(encoding="utf-8")
    rows = parse_rows(text)

    abs_counts: dict[int, int] = {}
    max_abs = 0
    worst = []

    for r in rows:
        cost = int(r[7])
        atk = int(r[8])
        pv = int(r[9])
        stats = atk + pv
        std = int(r[11])
        ev = parse_effect_value(r[13])
        b = rarity_bonus(r[6])
        target = int(math.floor((std - ev + b) + 0.5))
        err = stats - target
        ae = abs(err)
        abs_counts[ae] = abs_counts.get(ae, 0) + 1
        if ae > max_abs:
            max_abs = ae
            worst = [(ae, err, r[0], r[3], r[2], r[6], cost, stats, std, ev, b)]
        elif ae == max_abs:
            worst.append((ae, err, r[0], r[3], r[2], r[6], cost, stats, std, ev, b))

    print("rows", len(rows))
    print("max_abs_error", max_abs)
    print("abs_error_counts", dict(sorted(abs_counts.items())))
    print("worst_examples")
    for ae, err, idx, cid, name, rar, cost, stats, std, ev, b in worst[:15]:
        print(
            f"#{idx} {cid} {name} rar={rar} C={cost} stats={stats} std={std} ev={ev} b={b} err={err}"
        )


if __name__ == "__main__":
    main()

