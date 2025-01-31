import subprocess
from instalation.exceptions import NonZeroReturnCodeError


def run_powershell(cmd):
    completed = subprocess.run(["powershell", "-Command", cmd], capture_output=True)
    return completed


def get_execution_policy():
    res = run_powershell('Get-ExecutionPolicy')
    if res.returncode != 0:
        raise NonZeroReturnCodeError(res.returncode)
    return res.stdout.decode().rstrip()


def is_execution_policy_restricted():
    res = get_execution_policy()
    if 'restricted' in res.lower():
        return True
    return False


def set_execution_policy_to(state):
    permitted_states = ['Restricted', 'RemoteSigned']
    if state not in permitted_states:
        raise ValueError(f'Only states allowed are: {permitted_states}')

    res = run_powershell(f'Set-ExecutionPolicy -ExecutionPolicy {state} -Scope CurrentUser')
    if res.returncode != 0:
        raise NonZeroReturnCodeError(res.returncode)
    print(f'Execution policy now set to: {get_execution_policy()}')


def enable_execution_policy():
    set_execution_policy_to('RemoteSigned')


def disable_execution_policy():
    set_execution_policy_to('Restricted')
