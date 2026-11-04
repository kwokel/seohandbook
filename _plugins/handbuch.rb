# Baut die Navigation des Handbuchs automatisch aus der Ordnerstruktur:
#
#   handbuch/Foundations/foundations.md    (uebersicht: true)  ->  /foundations/
#   handbuch/Foundations/search-intent.md                     ->  /foundations/search-intent/
#
# - Der Ordnername ergibt die URL des Bereichs ("Technical SEO" -> /technical-seo/).
# - Die Seite mit "uebersicht: true" ist die Übersichtsseite des Bereichs;
#   alle anderen Seiten im Ordner werden automatisch ihre Unterkapitel.
# - "bereich_position" der Übersichtsseite bestimmt die Reihenfolge der Bereiche
#   (alternativ eine Nummer vor dem Ordnernamen, z. B. "02-search-engines").
Jekyll::Hooks.register :site, :post_read do |site|
  site.pages
      .select { |p| p.relative_path.start_with?("handbuch/") }
      .group_by { |p| File.dirname(p.relative_path).sub(%r{\Ahandbuch/?}, "") }
      .each do |dir, pages|
    next if dir.empty? || dir.include?("/")

    number = dir[/\A(\d+)/, 1]
    area   = Jekyll::Utils.slugify(dir.sub(/\A\d+[-_ ]*/, ""))
    overview = pages.find { |p| p.data["uebersicht"] } || pages.find { |p| p.name == "index.md" }

    pages.each do |p|
      p.data["layout"] = "chapter" if [nil, "default"].include?(p.data["layout"])
      if p.equal?(overview)
        p.data["has_children"] = pages.size > 1
        p.data["has_toc"]      = false # Kapitelliste kommt aus _layouts/chapter.html
        position = p.data["bereich_position"] || number
        p.data["nav_order"]    = position.to_i if position
        p.data.delete("parent")
        p.data["permalink"]    = "/#{area}/" unless p.data["permalink"]
      else
        p.data["parent"]    = overview.data["title"] if overview
        p.data["permalink"] = "/#{area}/#{p.basename}/" unless p.data["permalink"]
      end
    end
  end
end
