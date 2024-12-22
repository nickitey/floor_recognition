#install python packages
python3.7 -m pip uninstall -r ./scripts/old_versions.txt
python3.7 -m pip install -r ./scripts/requirements.txt

#install mrcnn
sudo chmod +x ./scripts/install_mrcnn.sh
sh ./scripts/install_mrcnn.sh
