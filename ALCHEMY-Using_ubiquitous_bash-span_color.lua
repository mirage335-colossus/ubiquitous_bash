function Span(elem)
  local style = elem.attributes.style
  if style then
    local color = style:match("color:%s*#(%x+)")
    local weight = style:match("font%-weight:%s*bold")
    if color then
      local text = pandoc.utils.stringify(elem.content)
      local colored = '\\textcolor[HTML]{' .. color .. '}{' .. text .. '}'
      if weight then
        colored = '\\textbf{' .. colored .. '}'
      end
      return pandoc.RawInline('latex', colored)
    end
  end
end
