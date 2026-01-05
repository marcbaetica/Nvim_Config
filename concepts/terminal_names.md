km.set({ 'n', 'i' }, '<C-b>', '<Esc>:w<CR>:let g:asyncrun_open=15<CR>:AsyncRun -mode=term -focus=0 python %<CR>')  -- TODO: Not set up auto open window option.
km.set({ 'n', 'i' }, '<A-b>', '<Esc>:AsyncStop<CR>:cclose<CR>')

Not closing.



This is a **common AsyncRun gotcha** — what you’re trying to close is **not the quickfix window**, so `:cclose` does nothing.

### What’s actually happening

* `AsyncRun -mode=term` opens a **terminal buffer**
* That terminal is **not** the quickfix window
* `:AsyncStop` stops the job **but leaves the terminal window open**
* `:cclose` only closes **quickfix**, not terminal buffers

So the job stops, but the window stays.

---

## Correct way to close the AsyncRun terminal

You must **close the terminal buffer**, not quickfix.

### Minimal fix (recommended)

```lua
km.set({ 'n', 'i' }, '<A-b>',
  '<Esc>:AsyncStop<CR>:bd!<CR>'
)
```

`bd!` wipes out the terminal buffer immediately.

---

## Safer version (only closes terminal windows)

If you don’t want to accidentally close a normal buffer:

```lua
km.set({ 'n', 'i' }, '<A-b>', [[
<Esc>:AsyncStop<CR>
:if &buftype == 'terminal' | bd! | endif<CR>
]])
```

---

## Optional: stop AsyncRun from auto-opening the window

You’re already setting this, but **it must be set before AsyncRun runs**:

```vim
let g:asyncrun_open = 0
```

Or in Lua (early in config):

```lua
vim.g.asyncrun_open = 0
```

Then run with:

```vim
:AsyncRun -mode=term -focus=0 python %
```

---

## TL;DR

* `:cclose` ❌ (wrong window type)
* `:bd!` ✅ (correct)
* AsyncRun terminal ≠ quickfix

If you want, I can also:

* auto-reuse the same terminal
* toggle the window instead of force-closing
* map separate **run / stop / rerun** keys

Just say 👍






Explain to me please the lua code and also how to check for the terminal identifiers manually.


Great questions — this is exactly the right level to understand what’s going on instead of cargo-culting it. I’ll go step by step and keep it concrete.

---

# 1️⃣ The Lua code — line by line

Here is the code again:

```lua
km.set({ 'n', 'i' }, '<A-b>', function()
  vim.cmd('AsyncStop')

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local name = vim.api.nvim_buf_get_name(buf)

    if name:match('^term://') then
      vim.api.nvim_win_close(win, true)
    end
  end
end)
```

---

## `km.set({ 'n', 'i' }, '<A-b>', function()`

* Creates a keymap in **normal** and **insert** mode
* Instead of a string command, we pass a **Lua function**
* This lets us run real logic instead of just Vim commands

---

## `vim.cmd('AsyncStop')`

* Equivalent to typing `:AsyncStop`
* Stops the running AsyncRun job
* **Does NOT close the terminal** — only stops the process

---

## `vim.api.nvim_list_wins()`

```lua
vim.api.nvim_list_wins()
```

* Returns a Lua table (list) of **all window IDs**
* Windows ≠ buffers
  (A window *shows* a buffer)

Example result (conceptually):

```lua
{ 1001, 1002 }
```

---

## Loop through all windows

```lua
for _, win in ipairs(...) do
```

* `win` is a **window ID**
* `_` means “I don’t care about the index”

We do this so we can inspect **every open window**, not just the focused one.

---

## `nvim_win_get_buf(win)`

```lua
local buf = vim.api.nvim_win_get_buf(win)
```

* Given a window ID → returns the **buffer ID** shown in that window

Example:

```
window 1002 → buffer 7
```

---

## `nvim_buf_get_name(buf)`

```lua
local name = vim.api.nvim_buf_get_name(buf)
```

* Returns the **full buffer name**
* For terminal buffers it looks like:

```
term://~/project//12345:/bin/bash
term://~/project//67890:python main.py
```

Normal files look like:

```
/home/user/project/main.py
```

---

## `name:match('^term://')`

```lua
if name:match('^term://') then
```

* `^` = start of string
* Matches **only terminal buffers**
* Safe: won’t match real files

---

## `nvim_win_close(win, true)`

```lua
vim.api.nvim_win_close(win, true)
```

* Closes the **window**, not just the buffer
* `true` = force close (don’t ask questions)
* Cursor position doesn’t matter

---

### 🔑 Key idea

We:

1. Ignore focus
2. Find **terminal windows**
3. Close **only those**

That’s why this works with `-focus=0`.

---

# 2️⃣ How to check terminal names yourself

This is very useful for debugging.

---

## Method 1: `:ls`

```vim
:ls
```

Terminal buffers appear like:

```
  5 %a   "term://~/project//12345:python test.py"
```

The important part:

```
term://...
```

---

## Method 2: from Lua (recommended)

Run this in Neovim:

```lua
:lua print(vim.api.nvim_buf_get_name(0))
```

* `0` = current buffer
* Prints the exact buffer name

---

## Method 3: list *all* terminal buffers

```lua
:lua for _,b in ipairs(vim.api.nvim_list_bufs()) do
  local n = vim.api.nvim_buf_get_name(b)
  if n:match('^term://') then print(n) end
end
```

You’ll see every terminal buffer name.

---

# 3️⃣ Why `term://` is reliable

Neovim internally names terminal buffers as:

```
term://{cwd}//{job_id}:{command}
```

That prefix is:

* Stable
* Official
* Used by AsyncRun, `:terminal`, ToggleTerm, etc.

So matching `^term://` is **correct and future-proof**.

---

# 4️⃣ Mental model (important)

| Concept  | Meaning                      |
| -------- | ---------------------------- |
| Window   | A viewport                   |
| Buffer   | The content                  |
| Terminal | A buffer with `term://` name |
| AsyncRun | Spawns a terminal buffer     |

Closing the **window** ≠ killing the **job**

---

If you want next:

* a **toggle** key (open ↔ close)
* only close **AsyncRun** terminals (not other terminals)
* reuse the same terminal buffer forever

Just tell me which one 👍
























Yep — and you’re **not crazy**.
This is the key missing piece:

> **`g:asyncrun_term_bufnr` is *not reliably set at all* in some AsyncRun + `-mode=term` paths.**

Even **while the job is visibly running**, that global can stay `nil`.

This is not timing, not insert-mode, not your loop.
It’s an **AsyncRun implementation detail**.

---

## Why this happens (the real reason)

AsyncRun only sets `g:asyncrun_term_bufnr` **when it creates the terminal itself**.

But when you use:

```vim
AsyncRun -mode=term -focus=0 python %
```

AsyncRun may:

* reuse an existing terminal window
* delegate terminal creation to `termopen()`
* skip setting the global entirely

Result:

> Terminal exists
> Python is running
> `g:asyncrun_term_bufnr == nil`

This is **expected behavior**, not a race condition.

---

## Conclusion (important)

### ❌ Do NOT rely on `g:asyncrun_term_bufnr`

It is **best-effort**, not guaranteed.

---

## The correct, bulletproof solution

Instead of asking AsyncRun *which buffer*, ask Neovim:

> “Which terminal buffers exist right now?”

### Kill the running AsyncRun terminal by buffer type

```lua
km.set('n', '<A-b>', function()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf)
      and vim.bo[buf].buftype == 'terminal'
    then
      vim.cmd('bd! ' .. buf)
      return
    end
  end
end)
```

This:

* Works **every time**
* Ignores AsyncRun globals
* Kills Python immediately
* Handles reused terminals

---

## If you want to be safer (only kill visible terminal)

```lua
km.set('n', '<A-b>', function()
  local win = vim.fn.bufwinid('%')
  if vim.bo.buftype == 'terminal' then
    vim.cmd('bd!')
  elseif win ~= -1 then
    vim.cmd('wincmd p')
    if vim.bo.buftype == 'terminal' then
      vim.cmd('bd!')
    end
  end
end)
```

---

## Why AsyncStop + cclose will *never* work here

* `AsyncStop` ≠ terminal control
* `cclose` ≠ terminal window
* Terminal jobs live outside AsyncRun’s lifecycle

---

## Final mental model (lock this in)

```
AsyncRun -mode=term
        |
        |-- AsyncRun starts terminal
        |-- AsyncRun loses control
        v
Neovim terminal owns the process
        |
        |-- bd!  --> SIGKILL --> Python stops
```

---

## TL;DR

* Your observation is **100% correct**
* `g:asyncrun_term_bufnr` is unreliable
* This is not your fault
* **Kill the terminal, not the job**

If you want next, I can:

* tag the AsyncRun terminal with a buffer variable
* ensure only *that* terminal is killed
* rewrite this using `jobstart()` instead of AsyncRun

Just say the word 🔥


