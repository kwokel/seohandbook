# SEO Handbook

Deutschsprachiges SEO-Nachschlagewerk, gebaut mit [Jekyll](https://jekyllrb.com) und dem Theme [Just the Docs](https://just-the-docs.github.io/just-the-docs/).

Live: https://kwokel.github.io/seohandbook/

## Struktur

- `index.md` – Startseite
- `handbuch/` – ein Ordner pro Bereich (`Foundations/` …); `index.md` ist die Übersichtsseite des Bereichs, alle anderen Dateien sind seine Unterkapitel
- `_plugins/handbuch.rb` – baut Navigation und URLs automatisch aus der Ordnerstruktur
- `glossar.md` – Glossar
- `_layouts/chapter.html` – Kapitel-Layout: setzt Titel und Inhaltsverzeichnis automatisch
- `.pages.yml` – Konfiguration für [Pages CMS](https://app.pagescms.org)

Inhalte werden über Pages CMS gepflegt. Der Dateiname eines Kapitels bestimmt seine URL (`handbuch/Foundations/search-intent.md` → `/foundations/search-intent/`).

## Lokal ansehen

```bash
bundle install
bundle exec jekyll serve
```

Danach unter http://localhost:4000 öffnen.
