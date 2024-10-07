import os
import shutil
import platform


NVIM_CONFIG_FOLDER = 'nvim'
APPCONFIG_ROOT_FOLDER = {'Windows': f'C:\\Users\\{os.getlogin()}\\AppData\\Local'}
SRC, DEST, DEST_NVIM_CONFIG_PATH = '', '', ''


def define_src_dest_folders():
    global SRC, DEST, DEST_NVIM_CONFIG_PATH
    # TODO: Add more os flavors support. For platform.system(): Linux=Linux, Mac=Darwin, Windows=Windows.
    os_flavor = platform.system()
    if os_flavor == 'Windows':
        SRC = os.getcwd()                                       # ex: C:\Users\AAA\Desktop\Python_projects\Nvim_config
        DEST = APPCONFIG_ROOT_FOLDER['Windows']                 # ex: C:\Users\AAA\AppData\Local
        DEST_NVIM_CONFIG_PATH = f'{DEST}\{NVIM_CONFIG_FOLDER}'   # ex: C:\Users\AAA\AppData\Local\nvim
    else:
        raise NotImplementedError(f'OS {os_flavor} is not supported.')


def remove_nvim_config_if_it_exists():
    if os.path.exists(DEST_NVIM_CONFIG_PATH):
        shutil.rmtree(DEST_NVIM_CONFIG_PATH)
        print(f'Removed [{NVIM_CONFIG_FOLDER}] config folder located at {DEST_NVIM_CONFIG_PATH}.')
    else:
        print(f'{DEST_NVIM_CONFIG_PATH} does not exist. Doing nothing.')


def copy_new_config():
    # shutil.copy2()  # TODO: add stuff here!
    print(os.stat(f'{SRC}\{NVIM_CONFIG_FOLDER}\init.lua'))
    if not os.path.exists(DEST_NVIM_CONFIG_PATH):
        raise FileNotFoundError(F'Folder [{NVIM_CONFIG_FOLDER}] from {SRC} was not copied successfully under {DEST}.'
                                F' Contents under {DEST}:\n{os.listdir(DEST)}')


# if NVIM_CONFIG_FOLDER not in os.listdir(os.getcwd()):
#     print(f'Expected to find [{NVIM_CONFIG_FOLDER}] folder for source config in cwd.'
#           f' Cwd contents: {os.listdir(os.getcwd())}.')
# define_src_dest_folders()
# remove_nvim_config_if_it_exists()
# copy_new_config()


shutil.copytree('nvim', 'nvim2')

# dirs_exist_ok=False
# Traceback (most recent call last):
#   File "C:\Users\Marc\Desktop\Python_projects\Nvim_config\update_config_real_time.py", line 47, in <module>
#     shutil.copytree('nvim', 'nvim2')
#   File "C:\Users\ghostman\AppData\Local\Programs\Python\Python310\lib\shutil.py", line 558, in copytree
#     return _copytree(entries=entries, src=src, dst=dst, symlinks=symlinks,
#   File "C:\Users\ghostman\AppData\Local\Programs\Python\Python310\lib\shutil.py", line 457, in _copytree
#     os.makedirs(dst, exist_ok=dirs_exist_ok)
#   File "C:\Users\ghostman\AppData\Local\Programs\Python\Python310\lib\os.py", line 225, in makedirs
#     mkdir(name, mode)
# FileExistsError: [WinError 183] Cannot create a file when that file already exists: 'nvim2'
