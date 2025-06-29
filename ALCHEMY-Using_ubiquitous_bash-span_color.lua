local M = {}

-- Parse raw HTML blocks so that nested spans become regular AST elements.
function M.RawBlock(elem)
  if elem.format == 'html' then
    local html = elem.text
    if html:match('^%s*<!%-%-') then
      return {}
    end
    html = html:gsub('<pre>', ''):gsub('</pre>', '')
    -- remove newlines immediately after an opening span to avoid splitting
    -- colorized regions across lines
    html = html:gsub('(<span[^>]*>)%s*\n', '%1')
    local function esc(t)
      t = t:gsub('&#64;', '@'):gsub('&gt;', '>'):gsub('&lt;', '<')
      -- escape characters that would otherwise break LaTeX commands
      t = t:gsub('([\\{}])', '\\%1')
      t = t:gsub('([#%%$&_])', '\\%1')
      return t
    end
    html = html:gsub('<span style="font%-weight:bold;color:#(%x+);?">([\0-\255]-)</span>',
                     function(c,t) return '\\textbf{\\textcolor[HTML]{'..c..'}{'..esc(t)..'}}' end)
    html = html:gsub('<span style="color:#(%x+);?">([\0-\255]-)</span>',
                     function(c,t) return '\\textcolor[HTML]{'..c..'}{'..esc(t)..'}' end)
    html = html:gsub('<span style="[^"]*"></span>', '')
    html = html:gsub('&#64;', '@'):gsub('&gt;', '>'):gsub('&lt;', '<')
    html = html:gsub('\n', '\\newline\n')
    return pandoc.RawBlock('latex', html)
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
