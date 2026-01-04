Nvim lua code to save an opened buffer to the file it points to.


Here are the common ways to **save a file in Neovim using Lua**, depending on what you want to do.

---

## 1. Save the current buffer (same as `:w`)

```lua
vim.cmd("write")
```

or shorter:

```lua
vim.cmd("w")
```

---

## 2. Save only if the buffer has changes

```lua
if vim.bo.modified then
  vim.cmd("write")
end
```

---

## 3. Save a specific buffer by number

```lua
vim.api.nvim_buf_call(bufnr, function()
  vim.cmd("write")
end)
```

Example:

```lua
vim.api.nvim_buf_call(0, function() -- 0 = current buffer
  vim.cmd("write")
end)
```

---

## 4. Save to a specific file path (`:w filename`)

```lua
vim.cmd("write ~/test.txt")
```

---

## 5. Write content manually to a file (not using a buffer)

```lua
local lines = {
  "Hello",
  "from Lua",
}

vim.fn.writefile(lines, "/tmp/example.txt")
```

---

## 6. Auto-save on certain events (example)

```lua
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, {
  callback = function()
    if vim.bo.modified then
      vim.cmd("silent write")
    end
  end,
})
```

---

## 7. Save without triggering autocommands

```lua
vim.cmd("noautocmd write")
```

---

If you want, tell me **where** you’re using this (plugin, keymap, autocmd, config file), and I’ll tailor the code exactly for that.




How do I now which buffer is currently selected?


In Neovim, “currently selected buffer” usually means the **buffer shown in the current window**. Here are the main ways to get it in Lua.

---

## 1. Get the current buffer number (most common)

```lua
local bufnr = vim.api.nvim_get_current_buf()
```

This returns the buffer **ID** (an integer).

---

## 2. Check buffer info (name, modified, etc.)

```lua
local bufnr = vim.api.nvim_get_current_buf()
local name = vim.api.nvim_buf_get_name(bufnr)
local modified = vim.api.nvim_buf_get_option(bufnr, "modified")

print(bufnr, name, modified)
```

---

## 3. Check if a buffer is the current one

```lua
if vim.api.nvim_get_current_buf() == bufnr then
  print("This buffer is selected")
end
```

---

## 4. Current window → buffer relationship

```lua
local win = vim.api.nvim_get_current_win()
local bufnr = vim.api.nvim_win_get_buf(win)
```

This is useful if you’re working with **multiple windows**.

---

## 5. Get current buffer via `vim.bo`

```lua
-- buffer-local options always refer to the current buffer
if vim.bo.modified then
  print("Current buffer has unsaved changes")
end
```

---

## 6. List all buffers and mark the current one

```lua
local current = vim.api.nvim_get_current_buf()

for _, buf in ipairs(vim.api.nvim_list_bufs()) do
  if buf == current then
    print(buf .. " <-- current")
  else
    print(buf)
  end
end
```

---

### TL;DR

```lua
local current_buf = vim.api.nvim_get_current_buf()
```

If you’re doing this inside an **autocmd**, **keymap**, or **plugin**, tell me which one and I’ll show the best pattern for that case.


Here are the **correct ways to save the current buffer’s contents to a file in Neovim using Lua**, depending on what you mean by “save”.

---

## ✅ 1. Save the buffer normally (same file, like `:w`)

**Use this if the buffer already has a filename**

```lua
vim.cmd("write")
```

or explicitly:

```lua
vim.api.nvim_command("write")
```

---

## ✅ 2. Save current buffer to a specific file path

(like `:w /path/to/file.txt`)

```lua
vim.cmd("write /tmp/output.txt")
```

---

## ✅ 3. Save buffer contents to a file manually (full control)

This **does not rely on `:write`** and works even for unnamed buffers.

```lua
local bufnr = vim.api.nvim_get_current_buf()
local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

vim.fn.writefile(lines, "/tmp/output.txt")
```

📌 Use this when:

* The buffer has no name
* You want to export contents elsewhere
* You’re writing a plugin

---

## ✅ 4. Save only if buffer is modified

```lua
if vim.bo.modified then
  vim.cmd("write")
end
```

---

## ✅ 5. Save silently (no messages)

```lua
vim.cmd("silent write")
```

---

## 🔑 Recommendation

* **Normal editing** → `vim.cmd("write")`
* **Plugins / exporting / unnamed buffers** → `nvim_buf_get_lines + writefile`

---

If you want:

* autosave logic
* save on keypress
* save from an autocmd
* save to a temp file

tell me the use case and I’ll tailor the exact snippet 👍




What is vim.bo?
Is there no other alternative in lua for :w other than using vim.cmd?


Great questions — this gets into how Neovim’s Lua API is designed.

---

## 1️⃣ What is `vim.bo`?

`vim.bo` is a **Lua interface to Vim’s buffer-local options**.

Think of it as:

```
vim.bo  ⇔  :setlocal
```

### Example

```lua
print(vim.bo.modified)
```

is the same as:

```vim
:setlocal modified?
```

### Common `vim.bo` options

```lua
vim.bo.modified   -- has unsaved changes (boolean)
vim.bo.readonly   -- buffer is readonly
vim.bo.filetype   -- filetype string
vim.bo.buftype    -- "", "nofile", "terminal", etc.
vim.bo.bufhidden  -- how buffer is hidden
```

### How it works

* `vim.bo.option` → **current buffer**
* `vim.bo[bufnr].option` → **specific buffer**

```lua
vim.bo[bufnr].modified
```

---

## 2️⃣ Is there a Lua alternative to `:w` (without `vim.cmd`)?

### Short answer:

**No, not really.**
And that’s intentional.

---

### Why `:w` uses `vim.cmd`

Writing a file in Vim is **not just writing text**:

`:write` handles:

* file permissions
* backup / swap / undo
* `BufWritePre` / `BufWritePost` autocmds
* `:write!`
* `:write ++enc=utf-8`
* modelines
* file format (unix/dos)
* plugins hooked into save

All of that logic lives in **Vim’s core**, not Lua.

So Neovim exposes it as:

```lua
vim.cmd("write")
```

or:

```lua
vim.api.nvim_command("write")
```

Both call the **same internal code**.

---

## 3️⃣ Why not a `vim.api.nvim_buf_write()`?

Because such a function would:

* bypass autocmds
* ignore options
* break plugins
* duplicate decades of Vim logic

So Neovim intentionally **does not provide** a low-level “write buffer to disk” API.

---

## 4️⃣ When NOT to use `:w`

If you want **raw text output**, not a “Vim save”:

```lua
local bufnr = vim.api.nvim_get_current_buf()
local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

vim.fn.writefile(lines, "/tmp/output.txt")
```

This:

* ignores autocmds
* ignores undo/backup
* does not change buffer state
* does not mark buffer as saved

---

## 5️⃣ Summary

| Task                 | Correct API                            |
| -------------------- | -------------------------------------- |
| Normal save          | `vim.cmd("write")`                     |
| Silent save          | `vim.cmd("silent write")`              |
| Check modified       | `vim.bo.modified`                      |
| Save specific buffer | `nvim_buf_call(buf, vim.cmd("write"))` |
| Export contents      | `nvim_buf_get_lines + writefile`       |

---

### TL;DR

* `vim.bo` = buffer-local options
* `:w` **must** go through `vim.cmd`
* Anything else would break Vim’s guarantees

If you’re writing a **plugin**, tell me what you’re trying to do (autosave, export, formatter, backup) — there *are* best practices for each case.




Sorry. I don't know what setlocal is. I wish to know what vim.bo is.


No worries at all — let’s explain this **from zero**, without assuming Vim knowledge.

---

## What **`vim.bo`** is (plain explanation)

`vim.bo` is a **Lua table that lets you read and change settings that belong to a buffer**.

A **buffer** = the text you’re editing (a file, or unsaved text).

So:

```lua
vim.bo.modified
```

means:

> “Ask Neovim: does the *current buffer* have unsaved changes?”

It returns `true` or `false`.

---

## Think of it like this

Neovim has **settings**.
Some settings apply to:

* the whole editor
* one window
* **one buffer**

`vim.bo` is the **buffer settings object**.

---

## Simple examples

### Check if the current buffer has changes

```lua
if vim.bo.modified then
  print("You have unsaved changes")
end
```

---

### Get the filetype of the current buffer

```lua
print(vim.bo.filetype)
```

---

### Make the current buffer read-only

```lua
vim.bo.readonly = true
```

---

### Change a setting for a specific buffer

```lua
local buf = vim.api.nvim_get_current_buf()
vim.bo[buf].readonly = true
```

---

## What kind of things are in `vim.bo`?

Here are some common ones:

```lua
vim.bo.modified    -- has unsaved changes (true / false)
vim.bo.filetype    -- "lua", "python", "txt"
vim.bo.buftype     -- "" or "nofile" or "terminal"
vim.bo.readonly    -- prevent editing
vim.bo.swapfile    -- use a swap file
vim.bo.textwidth   -- max line width
```

All of these already exist in Neovim — `vim.bo` just lets Lua access them.

---

## What `vim.bo` is NOT

❌ It is **not** a buffer itself
❌ It is **not** file contents
❌ It is **not** how you save a file

To save:

```lua
vim.cmd("write")
```

To read text:

```lua
vim.api.nvim_buf_get_lines(...)
```

---

## Mental model (important)

Think:

```
vim.bo.modified
```

as:

> “Check a property of the current buffer”

Just like in JavaScript:

```js
document.title
```

---

## One-sentence summary

**`vim.bo` is how Lua reads and changes buffer-specific settings in Neovim.**

If you want, I can also explain:

* `vim.o` (global options)
* `vim.wo` (window options)
* how buffers/windows/tabs relate

Just say 👍




Which buffer are we talking about?


That’s a *very* good question — this is the key concept 👍
Let’s make it crystal clear.

---

## The buffer we’re talking about

When you see:

```lua
vim.bo.modified
```

we are talking about **the buffer that is currently shown in the active window**.

In plain words:

> **The text you are editing *right now***.

---

## Neovim’s three layers (simple model)

Neovim has three main objects:

```
Tab
 └─ Window
     └─ Buffer
```

* **Buffer** → the text (file contents)
* **Window** → a view onto a buffer
* **Tab** → a layout of windows

👉 Multiple windows can show **the same buffer**.

---

## “Current buffer” definition

The **current buffer** is:

> The buffer attached to the **currently focused window**

So this:

```lua
vim.api.nvim_get_current_buf()
```

returns **exactly** the buffer that:

* you are typing in
* your cursor is in
* `:w` would save

---

## `vim.bo` always means “current buffer”

```lua
vim.bo.modified
vim.bo.filetype
vim.bo.readonly
```

All of these refer to:

> **the buffer returned by `nvim_get_current_buf()`**

You can verify:

```lua
print(vim.bo.modified)
print(vim.api.nvim_buf_get_option(
  vim.api.nvim_get_current_buf(),
  "modified"
))
```

They give the same result.

---

## When there are multiple buffers

Example:

* `file1.lua` open
* `file2.lua` open
* split window

Each window has **its own current buffer**.

When you move focus:

* the “current buffer” changes
* `vim.bo` now points to a different buffer

---

## If you want to be explicit

Instead of “current buffer”, you can specify:

```lua
local buf = vim.api.nvim_get_current_buf()
vim.bo[buf].modified
```

This is useful in:

* plugins
* autocmds
* background tasks

---

## Key takeaway (one sentence)

**`vim.bo` refers to the buffer attached to the window you’re currently focused on.**

If you want, next I can explain:

* why buffers can exist without windows
* what `nofile` buffers are
* how `:w` decides what to save

Just tell me.




local buf = vim.api.nvim_get_current_buf()
vim.bo[buf].modified

So if vim.bo.whatever will tell me the current selected buffer's properties, what's with the index passed to vim.bo? Is it the current one or the currently opened ones?


Excellent — you’re asking exactly the *right* question.
Let’s clear up the confusion precisely.

---

## Short answer

```lua
vim.bo.whatever
```

→ **current buffer only**

```lua
vim.bo[bufnr].whatever
```

→ **that specific buffer**

The index (`[bufnr]`) does **not** mean “opened buffers” or “all buffers”.
It means **“this exact buffer ID”**.

---

## What `vim.bo` actually is

`vim.bo` is a **special proxy table**, not a normal Lua table.

It works like this:

* **No index** → current buffer
* **With index** → buffer with that ID

### These two are equivalent:

```lua
vim.bo.modified
vim.bo[vim.api.nvim_get_current_buf()].modified
```

---

## What is `bufnr`?

```lua
local bufnr = vim.api.nvim_get_current_buf()
```

* `bufnr` is an **integer ID**
* It uniquely identifies **one buffer**
* It does NOT change even if you switch windows
* It does NOT mean “buffer position” or “open order”

---

## Important: buffers vs “opened files”

Neovim can have:

* buffers **not visible in any window**
* buffers created by plugins
* hidden buffers
* terminal buffers

Example:

```lua
vim.api.nvim_list_bufs()
```

This returns **all buffers that exist**, not just visible ones.

---

## Why would you use `vim.bo[bufnr]`?

### Case 1: You’re already working with a known buffer

```lua
for _, buf in ipairs(vim.api.nvim_list_bufs()) do
  if vim.bo[buf].modified then
    print("Modified buffer:", buf)
  end
end
```

### Case 2: Autocmds

```lua
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(args)
    if vim.bo[args.buf].readonly then
      print("Readonly buffer!")
    end
  end,
})
```

Here:

* `args.buf` ≠ current buffer (always)
* So you **must** use `vim.bo[args.buf]`

---

## What the index is NOT

❌ Not “currently opened buffers”
❌ Not “current window’s buffers”
❌ Not “buffer list index”
❌ Not “tab index”

It is **exactly one buffer ID**.

---

## Mental model (very important)

Think of:

```lua
vim.bo
```

as:

```lua
BufferOptions(current_buffer)
```

and:

```lua
vim.bo[bufnr]
```

as:

```lua
BufferOptions(buffer_with_id_bufnr)
```

---

## Final takeaway

* `vim.bo.option` → current buffer
* `vim.bo[bufnr].option` → specific buffer
* The index is **explicit targeting**, not selection

You’ve basically understood 90% of Neovim’s Lua model now.
If you want, next I can explain:

* how buffers get created/destroyed
* why buffers can exist without windows
* how this differs from `vim.o` and `vim.wo`

Just say the word.




I understand now. Weird how vim.bo is a table of buffers but as soon as I call for a property of that object it defaults to pointing at the one for the currently selected buffer. Strange implementation detail.

And if I have a lot of windows with multiple buffers opened around, the current buffer is where my cursor currently is, yes?


Yes — **exactly right on both points** 👍
And your intuition about it being “weird” is spot-on.

---

## 1️⃣ Why `vim.bo` feels weird

You’re correct: **`vim.bo` is not really a table** in the normal Lua sense.

It’s a **proxy object implemented in C** that:

* Pretends to be a table
* Intercepts indexing and field access
* Decides *at access time* which buffer to use

So this:

```lua
vim.bo.modified
```

is internally treated as:

> “Get option `modified` for **the current buffer**”

That behavior is an **intentional convenience shortcut**, not a Lua pattern you’d normally design yourself.

---

## 2️⃣ Why Neovim did it this way

Neovim wanted Lua to feel **natural for Vim users**:

* Vimscript: `&modified`
* Lua: `vim.bo.modified`

Same mental model, different language.

That’s why:

* no index → current buffer
* index → explicit buffer

---

## 3️⃣ Your understanding of “current buffer” is correct

> **If I have many windows and buffers, the current buffer is where my cursor is**

✅ **Yes. Exactly.**

More precisely:

* The **current window** is the one with the cursor
* The **current buffer** is the buffer attached to that window

So:

```lua
vim.api.nvim_get_current_buf()
```

returns:

> The buffer shown in the window that currently has focus

---

## 4️⃣ Multiple windows showing the same buffer

One subtle detail (you’re ready for this):

You can have:

* 2 windows
* showing the **same buffer**

Moving the cursor between those windows:

* changes the *current window*
* but **not the buffer**

So `vim.bo` still refers to the same buffer in that case.

---

## 5️⃣ Summary (your mental model is now correct)

* `vim.bo` is a **magic proxy**, not a real table
* Access without index → **current buffer**
* Index = **explicit buffer ID**
* “Current buffer” = buffer under the cursor
* Multiple windows ≠ multiple buffers (always)

---

### Final reassurance

Nothing you’re thinking is wrong — most people find this design odd at first.
Once you accept that `vim.bo`, `vim.wo`, and `vim.o` are **smart facades**, Neovim’s Lua API suddenly becomes very consistent.

If you want, next we can:

* map the exact behavior of `vim.o`, `vim.bo`, `vim.wo`
* talk about buffer lifecycle
* explain how plugins safely track buffers

Just tell me where you want to go next.




That behavior is an intentional convenience shortcut, not a Lua pattern you’d normally design yourself. Or that vim.bo, vim.wo, and vim.o are "smart facades" as you call them.

I understand. Explain this kind of architecture to me please. What is it officially called in literature? In software architecture, where is this ok to exist? Give me python examples please.


Great question. You’ve now crossed from *“how do I use this API”* into *“what architectural pattern is this and when is it acceptable”*.
Let’s answer that properly, with correct terminology and grounded examples.

---

## 1. What this architecture is **officially called**

In software design literature, what Neovim is doing with `vim.bo`, `vim.wo`, and `vim.o` is best described as a combination of these patterns:

### ① **Proxy Pattern** (primary)

> A surrogate or placeholder object that controls access to another object.

`vim.bo` is a **proxy** for:

> “buffer-local options of *some* buffer”

The buffer is resolved **dynamically at access time**.

---

### ② **Contextual / Implicit Context Pattern**

> An object’s behavior depends on ambient context rather than explicit parameters.

Here, the *ambient context* is:

* “current buffer”
* “current window”

This is why:

```lua
vim.bo.modified
```

works without passing a buffer ID.

---

### ③ **Facade Pattern** (secondary)

> A simplified interface over a complex subsystem.

The real subsystem:

* buffer objects
* option scopes
* Vim internals
* autocmd interactions

`vim.bo` hides all of that behind:

```lua
vim.bo.option_name
```

---

### ④ **Late Binding**

> The target object is determined at runtime, not at call time.

The buffer is resolved **when the field is accessed**, not when `vim.bo` is created.

---

## 2. Why this feels “weird” in Lua

Lua (and Python) culture strongly favors:

* explicit parameters
* predictable object identity
* minimal hidden state

But Neovim is constrained by:

* Vim’s original design (global editor state)
* interactive editor workflows
* extremely frequent access to “current buffer”

So they optimized for **ergonomics over purity**.

---

## 3. Where this is considered OK in software architecture

This kind of design is generally acceptable **only** in these domains:

### ✅ Interactive systems

* editors
* IDEs
* REPLs
* game engines

Where there is:

* a dominant “current” object
* user-driven focus changes

---

### ✅ Embedded scripting layers

* host application controls context
* scripting language adapts to it

Examples:

* Vim / Neovim
* Blender Python API
* Maya Python API
* Unreal Engine scripting

---

### ❌ Where this is NOT acceptable

* backend services
* libraries
* distributed systems
* concurrency-heavy systems
* stateless APIs

Because implicit context breaks:

* testability
* concurrency safety
* reasoning about behavior

---

## 4. Python example: **Proxy with implicit context**

Here’s a **clean Python example** that mirrors `vim.bo`.

### Global editor state

```python
class EditorState:
    current_buffer = None

editor = EditorState()
```

---

### Buffer object

```python
class Buffer:
    def __init__(self, name):
        self.name = name
        self.modified = False
```

---

### Proxy object (`vim.bo` equivalent)

```python
class BufferOptionsProxy:
    def __getitem__(self, buffer):
        return buffer

    def __getattr__(self, attr):
        buf = editor.current_buffer
        if buf is None:
            raise RuntimeError("No current buffer")
        return getattr(buf, attr)

    def __setattr__(self, attr, value):
        if attr.startswith("_"):
            super().__setattr__(attr, value)
            return
        buf = editor.current_buffer
        setattr(buf, attr, value)
```

---

### Usage

```python
buf1 = Buffer("file1.txt")
buf2 = Buffer("file2.txt")

editor.current_buffer = buf1
bo = BufferOptionsProxy()

print(bo.modified)   # False

bo.modified = True
print(buf1.modified)  # True

editor.current_buffer = buf2
print(bo.modified)   # False
```

This behaves **exactly like `vim.bo`**.

---

## 5. Explicit override (like `vim.bo[bufnr]`)

```python
bo[buf1].modified = False
```

Which is:

* explicit
* predictable
* safer

Same as:

```lua
vim.bo[bufnr].modified
```

---

## 6. Why this design is controversial (and still used)

### Pros

* extremely concise
* perfect for interactive workflows
* matches mental model of users
* minimal boilerplate

### Cons

* hidden global state
* hard to reason about in isolation
* dangerous in async code
* surprising to newcomers (you noticed this!)

---

## 7. Modern best practice (important)

Neovim *itself* follows this rule:

> **Core/editor-facing APIs may use implicit context.
> Plugins should prefer explicit buffer IDs.**

That’s why you often see:

```lua
local buf = vim.api.nvim_get_current_buf()
vim.bo[buf].modified
```

You are already thinking like a plugin author — which is good.

---

## 8. One-sentence summary

**`vim.bo` is a proxy object using implicit context and late binding, acceptable in interactive systems but generally avoided in general-purpose software.**

If you want next, I can:

* map this to functional programming concepts
* compare this to thread-local storage
* explain how Neovim avoids race conditions
* show a “pure” alternative API design

Just say which direction you want.

