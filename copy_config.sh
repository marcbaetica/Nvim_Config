echo "Removing /mnt/c/Users/$1/AppData/Local/nvim"
rm -fr /mnt/c/Users/$1/AppData/Local/nvim
echo "Recreating folder /mnt/c/Users/$1/AppData/Local/nvim"
mkdir /mnt/c/Users/$1/AppData/Local/nvim
echo "Copying content from nvim/ into /mnt/c/Users/$1/AppData/Local/nvim"
cp -a nvim/. /mnt/c/Users/$1/AppData/Local/nvim/

