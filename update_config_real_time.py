import os
import shutil


NVIM_DEV_CONFIG_FOLDER = 'nvim'
CWD = os.getcwd()
USER = os.getlogin()
NVIM_CONFIG_LOCATION = {'windows': f'C:\\Users\\{USER}\\AppData\\Local\\nvim'}


folder_items = os.listdir(CWD)

if NVIM_DEV_CONFIG_FOLDER not in folder_items:
    print(f'Expected to find [{NVIM_DEV_CONFIG_FOLDER}] folder in cwd. Cwd contents: {folder_items}.')


def remove_config_if_it_exists():
    # TODO: if win vs others
    print(NVIM_CONFIG_LOCATION['windows'])
    print(os.listdir(NVIM_CONFIG_LOCATION['windows']))
    os.remove(NVIM_CONFIG_LOCATION['windows'])
    print(os.listdir(NVIM_CONFIG_LOCATION['windows']))


remove_config_if_it_exists()

# echo "Removing /mnt/c/Users/$1/AppData/Local/nvim"
# rm -fr /mnt/c/Users/$1/AppData/Local/nvim
# echo "Recreating folder /mnt/c/Users/$1/AppData/Local/nvim"
# mkdir /mnt/c/Users/$1/AppData/Local/nvim
# echo "Copying content from nvim/ into /mnt/c/Users/$1/AppData/Local/nvim"
# cp -a nvim/. /mnt/c/Users/$1/AppData/Local/nvim/
