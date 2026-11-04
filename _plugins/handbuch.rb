# Baut die Navigation des Handbuchs automatisch aus der Ordnerstruktur
# (passend zur Baumansicht in Pages CMS):
#
#   handbuch/Foundations/index.md          ->  Bereich "Foundations"      /foundations/
#   handbuch/Foundations/search-intent.md  ->  Unterkapitel davon         /foundations/search-intent/
#   handbuch/neuer-bereich.md              ->  Bereich ohne Unterkapitel  /neuer-bereich/
#
# "nav_order" einer index.md bestimmt die Reihenfolge der Bereiche,
# "nav_order" aller anderen Seiten die Reihenfolge der Unterkapitel im Bereich.
Jekyll::Hooks.register :site, :post_read do |site|
  pages = site.pages.select { |p| p.relative_path.start_with?("handbuch/") }

  pages.each do |p|
    p.data["layout"] = "chapter" if [nil, "default"].include?(p.data["layout"])
  end

  pages.group_by { |p| File.dirname(p.relative_path).sub(%r{\Ahandbuch/?}, "") }.each do |dir, group|
    if dir.empty?
      # Bereich ohne Unterkapitel (direkt im Ordner "handbuch")
      group.each { |p| p.data["permalink"] ||= "/#{Jekyll::Utils.slugify(p.basename)}/" }
      next
    end
    next if dir.include?("/")

    area     = Jekyll::Utils.slugify(dir)
    overview = group.find { |p| p.name == "index.md" }

    group.each do |p|
      if p.equal?(overview)
        p.data["has_children"] = group.size > 1
        p.data["has_toc"]      = false # Kapitelliste kommt aus _layouts/chapter.html
        p.data["permalink"]  ||= "/#{area}/"
      else
        p.data["parent"]      = overview.data["title"] if overview
        p.data["permalink"] ||= "/#{area}/#{p.basename}/"
      end
    end
  end
end
