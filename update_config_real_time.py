import os
import platform
import shutil
from pathlib import Path


NVIM_CONFIG_FOLDER = 'nvim'
APPCONFIG_ROOT_FOLDER = {'Windows': f'C:\\Users\\{os.getlogin()}\\AppData\\Local'}
SRC, DEST, SRC_NVIM_CONFIG_PATH, DEST_NVIM_CONFIG_PATH = '', '', '', ''


def define_src_dest_folders():
    global SRC, DEST, SRC_NVIM_CONFIG_PATH, DEST_NVIM_CONFIG_PATH
    # TODO: Add more os flavors support. For platform.system(): Linux=Linux, Mac=Darwin, Windows=Windows.
    os_flavor = platform.system()
    if os_flavor == 'Windows':
        SRC = Path.cwd()                                        # ex: C:\Users\AAA\Desktop\Python_projects\Nvim_config
        SRC_NVIM_CONFIG_PATH = Path(SRC, NVIM_CONFIG_FOLDER)    # ex: C:\Users\AAA\Desktop\Python_projects\Nvim_config\nvim
        DEST = APPCONFIG_ROOT_FOLDER['Windows']                 # ex: C:\Users\AAA\AppData\Local
        DEST_NVIM_CONFIG_PATH = Path(DEST, NVIM_CONFIG_FOLDER)  # ex: C:\Users\AAA\AppData\Local\nvim
    else:
        raise NotImplementedError(f'OS {os_flavor} is not supported.')


def check_required_paths_not_empty():
    required_paths = (SRC, DEST, SRC_NVIM_CONFIG_PATH, DEST_NVIM_CONFIG_PATH)
    are_paths_empty = [path_string=='' for path_string in required_paths]
    if any(are_paths_empty):
        raise ValueError(f'Some required paths were left empty: [{required_paths}].')


def check_src_folder_exists():
    if NVIM_CONFIG_FOLDER not in os.listdir(os.getcwd()):
        raise FileNotFoundError(f'Missing [{NVIM_CONFIG_FOLDER}] folder for source config in cwd.'
                                f' Cwd contents: {os.listdir(os.getcwd())}.')


def copy_new_config():
    check_required_paths_not_empty()
    check_src_folder_exists()
    try:
        shutil.copytree(SRC_NVIM_CONFIG_PATH, DEST_NVIM_CONFIG_PATH)
    except FileExistsError as e:
        shutil.rmtree(DEST_NVIM_CONFIG_PATH)
        print(f'Removed existing [{NVIM_CONFIG_FOLDER}] config folder located at {DEST_NVIM_CONFIG_PATH}.')
        shutil.copytree(SRC_NVIM_CONFIG_PATH, DEST_NVIM_CONFIG_PATH)

    if not os.path.exists(DEST_NVIM_CONFIG_PATH):
        raise FileNotFoundError(F'Folder [{NVIM_CONFIG_FOLDER}] from {SRC} was not copied successfully under {DEST}.'
                                F' Contents under {DEST}:\n{os.listdir(DEST)}')
    else:
        print(f'Copied config dir {SRC_NVIM_CONFIG_PATH} to {DEST_NVIM_CONFIG_PATH}.')


define_src_dest_folders()
copy_new_config()


# Bonus, start the editor.
os.system('start /max nvim')
