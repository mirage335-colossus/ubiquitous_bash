local M = {}

-- Parse raw HTML blocks so that nested spans become regular AST elements.
function M.RawBlock(elem)
  if elem.format == 'html' then
    local html = elem.text
    if html:match('^%s*<!%-%-') then
      return {}
    end
    html = html:gsub('<pre>', ''):gsub('</pre>', '')
    local lines = {}
    local function esc(t)
      t = t:gsub('&#64;', '@'):gsub('&gt;', '>'):gsub('&lt;', '<')
      return t:gsub('([#%%$&_])', '\\%1')
    end
    for line in html:gmatch('[^\n]+') do
      line = line:gsub('<span style="font%-weight:bold;color:#(%x+);?">(.-)</span>',
                       function(c,t) return '\\textbf{\\textcolor[HTML]{'..c..'}{'..esc(t)..'}}' end)
      line = line:gsub('<span style="color:#(%x+);?">(.-)</span>',
                       function(c,t) return '\\textcolor[HTML]{'..c..'}{'..esc(t)..'}' end)
      line = line:gsub('<span style="[^"]*"></span>', '')
      line = line:gsub('&#64;', '@'):gsub('&gt;', '>'):gsub('&lt;', '<')
      table.insert(lines, line)
    end
    local out = table.concat(lines, '\\newline\n')
    return pandoc.RawBlock('latex', out)
  end
end

-- Convert spans with inline CSS color and weight into LaTeX commands.
function M.Span(elem)
  local style = elem.attributes.style
  if style then
    local color = style:match('color:%s*#(%x+)')
    local weight = style:match('font%-weight:%s*bold')
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

return {M}
