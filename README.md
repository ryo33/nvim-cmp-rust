# cmp rust

```lua
local compare = require "cmp.config.compare"
cmp.setup.filetype({ "rust" }, {
  sorting = {
    priority_weight = 2,
    comparators = {
      -- deprioritize `.box`, `.mut`, etc.
      require("cmp-rust").deprioritize_postfix,
      -- deprioritize `Borrow::borrow` and `BorrowMut::borrow_mut`
      require("cmp-rust").deprioritize_borrow,
      -- deprioritize `Deref::deref` and `DerefMut::deref_mut`
      require("cmp-rust").deprioritize_deref,
      -- deprioritize `Into::into`, `Clone::clone`, etc.
      require("cmp-rust").deprioritize_common_traits,
      compare.offset,
      compare.exact,
      compare.score,
      compare.recently_used,
      compare.locality,
      compare.sort_text,
      compare.length,
      compare.order,
    },
  },
})
```
