local function format_purs_declaration(s)
  -- the special chars used by purescript for type signatures will count for multiple chars, so we reduce them to `.` before counting
  local charCount = #s:gsub("⇒", "."):gsub("→", "."):gsub("∀", ".")
  -- we only unfold the type signature if it takes up more than 100 chars in width
  if charCount > 100 then
    return s
      :gsub("::", "\n ::", 1)
      :gsub("%.", "\n  .", 1)
      :gsub("⇒",  "\n  ⇒")
      :gsub("→",  "\n  →")
      -- fix situations where the previous step has added a newline inside a function signature
      -- for example `(a →\n    b)` which we correct to `(a → b)`
      :gsub("%(([^%)]-)\n[ ]+", "(%1")
  else
    return s
  end
end

local function split_inner_lists(input_string)
  for matched_list in string.gmatch(input_string, "(%([^()]+%))") do

    local inner_list = {}
    for item in string.gmatch(matched_list, "([^,()]+)") do
      local trimmed = item:gsub("^%s*(.-)%s*$", "%1")
      table.insert(inner_list, trimmed)
    end

    -- if an inner list contains more than 3 elements then we split it into multiple lines
    if #inner_list > 3 then
      local multi_line_list_content = "\n      ( " .. table.concat(inner_list, "\n      , ") .. "\n      )\n  "
      input_string = input_string:gsub(matched_list, multi_line_list_content, 1)
    end
  end

  return input_string
end

function format_purescript_hover_text(hover_text)
    -- Split the hover text into signature and description
    local signature_block, description = hover_text:match("```purescript\n(.-)\n```\n(.*)")
    if not signature_block then
        return hover_text -- Return original if pattern doesn't match
    end

    -- Split the signature block into individual declarations
    local declarations = {}
    for declaration in signature_block:gmatch("[^\n]+") do
        table.insert(declarations, declaration)
    end

    -- Check if we have at least one declaration to format
    if #declarations == 0 then
        return hover_text
    end

    local surround_with_markdown = function(decl)
      return {
        "```purescript",
        decl,
        "```"
      }
    end

    local formatted_signature_lines = surround_with_markdown(
      format_purs_declaration(declarations[1])
    )

    -- Adding description with a separation line
    if #description > 0 then
      table.insert(formatted_signature_lines, "--------------------")
      table.insert(formatted_signature_lines, description)
    end

    -- Adding second declaration at the end with a separation line
    if #declarations >= 2 then
      table.insert(formatted_signature_lines, "--------------------")

      local second_declaration = surround_with_markdown(
        split_inner_lists(
          format_purs_declaration(declarations[2])
        )
      )
      for _, value in ipairs(second_declaration) do
          table.insert(formatted_signature_lines, value)
      end

    end

    -- Concatenate the formatted first signature with the description
    local formatted_hover_text = table.concat(formatted_signature_lines, "\n")

    return formatted_hover_text
end

--local input = [[
--  select 
--   :: ∀ (w ∷ Type) (i ∷ Type)
--    . Array (IProp ( accessKey ∷ String , autofocus ∷ Boolean , class ∷ String , contentEditable ∷ Boolean , dir ∷ DirValue , disabled ∷ Boolean , draggable ∷ Boolean , form ∷ String , hidden ∷ Boolean , id ∷ String , lang ∷ String , multiple ∷ Boolean , name ∷ String , onAuxClick ∷ MouseEvent , onBeforeInput ∷ Event , onBlur ∷ FocusEvent , onChange ∷ Event , onClick ∷ MouseEvent , onContextMenu ∷ Event , onCopy ∷ ClipboardEvent , onCut ∷ ClipboardEvent , onDoubleClick ∷ MouseEvent , onDrag ∷ DragEvent , onDragEnd ∷ DragEvent , onDragEnter ∷ DragEvent , onDragExit ∷ DragEvent , onDragLeave ∷ DragEvent , onDragOver ∷ DragEvent , onDragStart ∷ DragEvent , onDrop ∷ DragEvent , onFocus ∷ FocusEvent , onFocusIn ∷ FocusEvent , onFocusOut ∷ FocusEvent , onGotPointerCapture ∷ PointerEvent , onInput ∷ Event , onKeyDown ∷ KeyboardEvent , onKeyPress ∷ KeyboardEvent , onKeyUp ∷ KeyboardEvent , onLostPointerCapture ∷ PointerEvent , onMouseDown ∷ MouseEvent , onMouseEnter ∷ MouseEvent , onMouseLeave ∷ MouseEvent , onMouseMove ∷ MouseEvent , onMouseOut ∷ MouseEvent , onMouseOver ∷ MouseEvent , onMouseUp ∷ MouseEvent , onPaste ∷ ClipboardEvent , onPointerCancel ∷ PointerEvent , onPointerDown ∷ PointerEvent , onPointerEnter ∷ PointerEvent , onPointerLeave ∷ PointerEvent , onPointerMove ∷ PointerEvent , onPointerOut ∷ PointerEvent , onPointerOver ∷ PointerEvent , onPointerUp ∷ PointerEvent , onScroll ∷ Event , onTouchCancel ∷ TouchEvent , onTouchEnd ∷ TouchEvent , onTouchEnter ∷ TouchEvent , onTouchLeave ∷ TouchEvent , onTouchMove ∷ TouchEvent , onTouchStart ∷ TouchEvent , onTransitionEnd ∷ Event , onWheel ∷ WheelEvent , required ∷ Boolean , selectedIndex ∷ Int , size ∷ Int , spellcheck ∷ Boolean , style ∷ String , tabIndex ∷ Int , title ∷ String , value ∷ String ) i ) 
--    → Array (HTML w i) 
--    → HTML w i
--]]


--for match in string.gmatch(input, "(%([^()]+%))") do
--  local inner_list = {}
--  for match2 in string.gmatch(match, "([^,()]+)") do
--    table.insert(inner_list, match2)
--  end
--  if #inner_list > 3 then
--    local trimmed_items = {}
--    for _, item in ipairs(inner_list) do
--      local trimmed = item:gsub("^%s*(.-)%s*$", "%1")
--      table.insert(trimmed_items, trimmed)
--    end
--    local multi_line_list_content = "\n      ( " .. table.concat(trimmed_items, "\n      , ") .. "\n      )\n  "
--    input = input:gsub(match, multi_line_list_content, 1)
--  end
--end

--print(split_inner_lists(input))

--for match in string.gmatch(input, "([^,()]+)") do
--    local trimmed = match:gsub("^%s*(.-)%s*$", "%1")
--    print(trimmed)
--end

