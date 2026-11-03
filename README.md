# SEO Handbook

Deutschsprachiges SEO-Nachschlagewerk, gebaut mit [Jekyll](https://jekyllrb.com) und dem Theme [Just the Docs](https://just-the-docs.github.io/just-the-docs/).

Live: https://kwokel.github.io/seohandbook/

## Struktur

- `index.md` – Startseite
- `docs/foundations/` – Bereich 01 Foundations (eine Datei pro Kapitel)
- `docs/glossar.md` – Glossar

Neue Kapitel brauchen im Front Matter `title`, `parent` (Name des Bereichs), `nav_order` und `permalink`.

## Lokal ansehen

```bash
bundle install
bundle exec jekyll serve
```

Danach unter http://localhost:4000 öffnen.
