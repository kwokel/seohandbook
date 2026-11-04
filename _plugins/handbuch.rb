# Baut die Navigation des Handbuchs automatisch aus der Ordnerstruktur:
#
#   handbuch/01-foundations/foundations.md   (uebersicht: true)  ->  /foundations/
#   handbuch/01-foundations/search-intent.md                     ->  /foundations/search-intent/
#
# - Die Nummer im Ordnernamen bestimmt die Reihenfolge der Bereiche.
# - Die Seite mit "uebersicht: true" ist die Übersichtsseite des Bereichs;
#   alle anderen Seiten im Ordner werden automatisch ihre Unterkapitel.
Jekyll::Hooks.register :site, :post_read do |site|
  site.pages
      .select { |p| p.relative_path.start_with?("handbuch/") }
      .group_by { |p| File.dirname(p.relative_path).sub(%r{\Ahandbuch/?}, "") }
      .each do |dir, pages|
    next if dir.empty? || dir.include?("/")

    number = dir[/\A(\d+)/, 1]
    area   = dir.sub(/\A\d+[-_ ]*/, "")
    overview = pages.find { |p| p.data["uebersicht"] } || pages.find { |p| p.name == "index.md" }

    pages.each do |p|
      p.data["layout"] = "chapter" unless p.data["layout"]
      if p.equal?(overview)
        p.data["has_children"] = pages.size > 1
        p.data["nav_order"]    = number.to_i if number
        p.data.delete("parent")
        p.data["permalink"]    = "/#{area}/" unless p.data["permalink"]
      else
        p.data["parent"]    = overview.data["title"] if overview
        p.data["permalink"] = "/#{area}/#{p.basename}/" unless p.data["permalink"]
      end
    end
  end
end
