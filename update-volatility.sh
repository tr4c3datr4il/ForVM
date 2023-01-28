sudo rm -rf ~/.local/lib/python2.7/dist-packages/volatility
sudo rm `which vol.py`
sudo rm -rf ~/.local/contrib/plugins
sudo rm 'which vol'
python2 -m pip install -U git+https://github.com/volatilityfoundation/volatility.git
python3 -m pip install -U git+https://github.com/volatilityfoundation/volatility3.git
export PATH=/home/$USER/.local/bin:$PATH
