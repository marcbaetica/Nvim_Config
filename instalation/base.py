from lib.pshell_execution_policy import is_execution_policy_restricted, enable_execution_policy, \
                                        disable_execution_policy, get_execution_policy


if is_execution_policy_restricted():
    print(f'Execution policy is restricted! Enabling...')
    enable_execution_policy()
else:
    print(f'Execution policy is already set to [{get_execution_policy()}]. Moving on...')

# Installing scoop.
# Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression


# Uninstalling scoop.



# if not is_execution_policy_restricted():
#     print(f'Execution policy is enabled! Disabling...')
#     disable_execution_policy()
