Ah! Now we’re in the nitty-gritty of **Neovim terminal channels and job status codes**. Let me break this down carefully, because it explains exactly why you see that error and how to guard against it.

---

## 1️⃣ What the “stream” is in Neovim

* Every **terminal buffer** in Neovim has a **channel**:

```lua
local chan = vim.api.nvim_buf_get_option(buf, "channel")
```

* This channel is essentially **a bi-directional pipe**:

  1. Neovim → terminal process (sending keystrokes, like Ctrl-C)
  2. Terminal process → Neovim (output, events)

* When you do:

```lua
vim.fn.chansend(chan, "\003")
```

* You’re sending the character `^C` (SIGINT) **through that channel** to the shell running in the terminal.
* The channel must be **open and active**, otherwise Neovim throws:

```
E5113: Error while calling lua chunk: ... can't send data to closed stream
```

* The stream is **closed** when the terminal buffer’s job has exited and the buffer/channel is dead.

---

## 2️⃣ Why you now see `-1073741510` instead of `-1`

* `-1` → `jobwait` with 0ms timeout → still running
* `-1073741510` → **Windows exit code** for `STATUS_STACK_BUFFER_OVERRUN` / terminated by Ctrl-C (or more generally, “process was killed”)
* On Linux/macOS, you’d likely see `130` (128 + SIGINT) when a process is killed by Ctrl-C.

✅ The key point: the **job status changes once the process dies**, so `jobwait` will no longer return `-1`.

---

## 3️⃣ How to safely check if the channel is open before sending

* You want to avoid `chansend` on a **closed stream**.
* You can check the **job status** before sending.

```lua
local buf_type = vim.api.nvim_buf_get_option(buf, "buftype")
if buf_type == "terminal" then
    local ok, buf_job_id = pcall(vim.api.nvim_buf_get_var, buf, "terminal_job_id")
    if ok and buf_job_id then
        local job_status = vim.fn.jobwait({buf_job_id}, 0)[1]
        if job_status == -1 then
            -- job still running, safe to send
            local chan = vim.api.nvim_buf_get_option(buf, "channel")
            if chan and chan > 0 then
                vim.fn.chansend(chan, "\003")  -- Ctrl-C
            end
        else
            -- job finished, do NOT send
            vim.print("Job is already finished with exit code: " .. tostring(job_status))
        end
    end
end
```

### Explanation:

* `jobwait({buf_job_id}, 0)[1]` → returns:

  * `-1` → still running → safe to send Ctrl-C
  * `>= 0` (or negative exit code) → finished → **channel is dead**, don’t `chansend`

* This prevents the “can't send data to closed stream” crash.

---

## 4️⃣ Summary

| Concept          | What happens                                                                        |
| ---------------- | ----------------------------------------------------------------------------------- |
| Stream / channel | Communication pipe between Neovim and terminal                                      |
| Sending Ctrl-C   | Goes through this channel                                                           |
| Closed stream    | Terminal process finished; buffer may still exist; `chansend` fails                 |
| Job status       | `jobwait({job_id}, 0)` → `-1` if running, otherwise exit code (e.g., `-1073741510`) |
| Guard            | Only `chansend` if `jobwait` == `-1` (job still running)                            |

---

✅ So the **pattern** you want is:

1. Check terminal buffer
2. Get `buf_job_id`
3. `jobwait({buf_job_id}, 0)[1]`
4. Only `chansend` if result is `-1`
5. Stop/delete buffer if needed

This way:

* You **see a different number** once the Python process has been killed
* You **don’t crash** on a second run

---

If you want, I can rewrite your **<A-b> mapping** so it:

* Safely sends Ctrl-C **only if running**
* Stops the job
* Deletes the buffer
* Prints **job status before and after**

…so you can **observe the exit code change** without ever crashing.

Do you want me to do that?

