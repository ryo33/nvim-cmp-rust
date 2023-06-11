local function deprioritize_postfix(entry1, entry2)
  local kind1 = entry1:get_kind()
  local kind2 = entry2:get_kind()
  -- if one of them is nil, compare is pointless
  if kind1 ~= kind2 then
    -- 15 is text
    if kind1 == 15 then
      return false
    end
    if kind2 == 15 then
      return true
    end
  end
end

local function deprioritize_common_traits(entry1, entry2)
  local function extract_trait(entry)
    local label = entry.completion_item.label
    if label == nil then
      return nil
    end
    -- find `(as Trait)` in the label
    return label:match "%(as ([^)]+)%)"
  end
  local function is_common_trait(trait)
    return vim
      .iter({
        "Clone",
        "Copy",
        "Deref",
        "DerefMut",
        "Borrow",
        "BorrowMut",
        "Drop",
        "ToString",
        "ToOwned",
        "PartialEq",
        "PartialOrd",
        "AsRef",
        "AsMut",
        "From",
        "Into",
        "TryFrom",
        "TryInto",
        "Default",
      })
      :find(function(x)
        return x == trait
      end) ~= nil
  end
  local trait1 = extract_trait(entry1)
  local trait2 = extract_trait(entry2)
  if trait1 ~= trait2 then
    -- prioritize no trait
    if trait1 == nil then
      return true
    end
    if trait2 == nil then
      return false
    end
    local is_common_1 = is_common_trait(trait1)
    local is_common_2 = is_common_trait(trait2)
    -- deprioritize common traits
    if is_common_1 ~= is_common_2 then
      return not is_common_1
    end
  end
end

local function deprioritize_borrow(entry1, entry2)
  local function has_borrow(entry)
    local label = entry.completion_item.label
    if label == nil then
      return false
    end
    -- find `(use ...)` in the label
    return label:match "%(use %a+::borrow::Borrow" ~= nil
  end
  local use1 = has_borrow(entry1)
  local use2 = has_borrow(entry2)
  if use1 ~= use2 then
    return not use1
  end
end

local function deprioritize_deref(entry1, entry2)
  local function has_deref(entry)
    local label = entry.completion_item.label
    if label == nil then
      return false
    end
    return label:match "Deref" ~= nil
  end
  local use1 = has_deref(entry1)
  local use2 = has_deref(entry2)
  if use1 ~= use2 then
    return not use1
  end
end

return {
  deprioritize_postfix = deprioritize_postfix,
  deprioritize_common_traits = deprioritize_common_traits,
  deprioritize_borrow = deprioritize_borrow,
  deprioritize_deref = deprioritize_deref,
}
