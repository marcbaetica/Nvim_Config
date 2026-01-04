In Neovim Lua, I run a headless nvim job and check its status using
`local job_status = vim.fn.jobwait({buf_job_id}, 0)`
but it returns `-3`. Why does this happen, and how can I properly check if the headless nvim process has finished?



Ah! That makes sense — that `-3` is **not random**, it comes straight from Neovim’s `jobwait()` behavior. Let me break it down carefully.

---

## 1️⃣ What `vim.fn.jobwait()` returns

```lua
local result = vim.fn.jobwait({job_id}, timeout)
```

* `job_id` = a job started via `vim.fn.jobstart()`
* `timeout` = in milliseconds (`0` = “don’t wait”)
* Returns a **list of statuses** (one per job)

### Status codes

| Value | Meaning                            |
| ----- | ---------------------------------- |
| ≥ 0   | Exit code of the job (0 = success) |
| `-1`  | Job hasn’t finished yet            |
| `-2`  | Invalid job id                     |
| `-3`  | **Timeout occurred**               |

---

## 2️⃣ Why you’re seeing `-3`

```lua
local job_status = vim.fn.jobwait({buf_job_id}, 0)[1]
```

* `0` = **immediate timeout**
* `jobwait()` does **not wait at all**
* If the job is still running → `-3` (timeout)

> This is **expected behavior**. `-3` just means “the job is still alive at the moment we checked.”

---

## 3️⃣ How to check correctly

### Option 1: Wait for it to finish

```lua
-- Wait up to 5 seconds (5000 ms)
local job_status = vim.fn.jobwait({buf_job_id}, 5000)[1]

if job_status >= 0 then
  print("Job finished, exit code:", job_status)
elseif job_status == -1 then
  print("Job not finished")
elseif job_status == -2 then
  print("Invalid job id")
elseif job_status == -3 then
  print("Job timed out (still running)")
end
```

* `0`ms = just a **snapshot**
* Use a positive timeout if you want to **actually wait**

---

### Option 2: Poll repeatedly (non-blocking)

```lua
local function check_job(job_id)
  local status = vim.fn.jobwait({job_id}, 0)[1]
  if status == -3 then
    print("Still running…")
    vim.defer_fn(function() check_job(job_id) end, 100)  -- check again in 100ms
  else
    print("Job finished with:", status)
  end
end

check_job(buf_job_id)
```

* Non-blocking
* Works in **headless + terminal**
* Lets you show progress while waiting

---

## 4️⃣ TL;DR

* `-3` = **timeout** (job is still alive)
* `0`ms timeout → very likely if job is slow
* Use a **positive timeout** or **poll with defer_fn** to wait properly
* `-1` = not started / still running
* `-2` = invalid job id

---

If you want, I can write a **complete AsyncRun + jobwait boilerplate** that:

* Runs headless Lua in a terminal
* Prints output line by line
* Waits for the job to finish safely
* Cleans up any leftover nvim processes

This is exactly what you need for testing scripts. Do you want me to do that?

