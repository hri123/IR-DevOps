# copy the public key
which ssh-copy-id || curl -L https://raw.githubusercontent.com/beautifulcode/ssh-copy-id-for-OSX/master/install.sh | sh
chmod 400 ${SSH_PUBLIC_KEY}
ssh-copy-id -i ${SSH_PUBLIC_KEY} ${LOGIN_USER}@${TARGET_IP}
chmod 400 ${SSH_PRIVATE_KEY}
scp -i ${SSH_PRIVATE_KEY} ${SSH_PRIVATE_KEY} ${LOGIN_USER}@${TARGET_IP}:~/.ssh/$(basename ${SSH_PRIVATE_KEY})
#
# setup git access to github.ibm.com
chmod 400 ${GITHUB_PRIVATE_KEY}
scp -i ${SSH_PRIVATE_KEY} ${GITHUB_PRIVATE_KEY} ${LOGIN_USER}@${TARGET_IP}:~/.ssh/id_rsa_github
scp -i ${SSH_PRIVATE_KEY} ~/git/github-hri123/IR-DevOps/setup/controller/ubuntu/git_config ${LOGIN_USER}@${TARGET_IP}:~/git_config
ssh -i ${SSH_PRIVATE_KEY} ${LOGIN_USER}@${TARGET_IP} 'touch ~/.ssh/config && cat ~/git_config >> ~/.ssh/config && rm -rf ~/git_config'
#
# clone repo
## To avoid: The authenticity of host 'github.ibm.com....
ssh -i ${SSH_PRIVATE_KEY} ${LOGIN_USER}@${TARGET_IP} "ssh-keyscan github.ibm.com >> ~/.ssh/known_hosts"
## use double quotes instead of single quotes to evaluate the GIT_REPO env variable
ssh -i ${SSH_PRIVATE_KEY} ${LOGIN_USER}@${TARGET_IP} "mkdir -p ~/git && cd ~/git && git clone ${GIT_REPO}"
#
# Install ansible and other tools (https://github.com/ggreer/the_silver_searcher)
ssh -i ${SSH_PRIVATE_KEY} ${LOGIN_USER}@${TARGET_IP} 'apt-get update && apt-get install -y ca-certificates python2.7 curl make silversearcher-ag'
ssh -i ${SSH_PRIVATE_KEY} ${LOGIN_USER}@${TARGET_IP} 'curl https://bootstrap.pypa.io/get-pip.py | python2.7 && pip install ansible==2.4'
#
# Install autojump, use `j -i` to add a folder to the list of folders
ssh -i ${SSH_PRIVATE_KEY} ${LOGIN_USER}@${TARGET_IP} "git clone git://github.com/joelthelion/autojump.git ~/git/autojump && chmod 755 ~/git/autojump/install.py && cd ~/git/autojump && ./install.py"
#
# Additional setting to ~/.bashrc
scp -i ${SSH_PRIVATE_KEY} ~/git/github-hri123/IR-DevOps/setup/controller/ubuntu/.my_bashrc ${LOGIN_USER}@${TARGET_IP}:~/.my_bashrc
ssh -i ${SSH_PRIVATE_KEY} ${LOGIN_USER}@${TARGET_IP} "touch ~/.bashrc && echo 'if [ -f ~/.my_bashrc ]; then source ~/.my_bashrc; fi' >> ~/.bashrc"
#
# Install storm - https://github.com/emre/storm - http://stormssh.readthedocs.io/en/master/
ssh -i ${SSH_PRIVATE_KEY} ${LOGIN_USER}@${TARGET_IP} "pip install stormssh"
#
# Setup SSH config
ssh -i ${SSH_PRIVATE_KEY} ${LOGIN_USER}@${TARGET_IP} 'rm ~/.ssh/config && ln -s ~/git/github-hri123/IR-DevOps/setup/controller/ubuntu/ssh_config ~/.ssh/config'

#
# Install fuzzy search fzf
ssh -i ${SSH_PRIVATE_KEY} ${LOGIN_USER}@${TARGET_IP} 'git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf'
ssh -i ${SSH_PRIVATE_KEY} ${LOGIN_USER}@${TARGET_IP} '~/.fzf/install --key-bindings --completion --update-rc'
ssh -i ${SSH_PRIVATE_KEY} ${LOGIN_USER}@${TARGET_IP} 'set rtp+=~/.fzf'
#
# history searches
ssh -i ${SSH_PRIVATE_KEY} ${LOGIN_USER}@${TARGET_IP} "touch ~/.inputrc && echo '\"\e[A\": history-search-backward' >> ~/.inputrc"
ssh -i ${SSH_PRIVATE_KEY} ${LOGIN_USER}@${TARGET_IP} "echo '\"\e[B\": history-search-forward' >> ~/.inputrc"
#
# Install VIM Plugins - https://github.com/tpope/vim-pathogen; https://github.com/scrooloose/nerdtree
ssh -i ${SSH_PRIVATE_KEY} ${LOGIN_USER}@${TARGET_IP} "mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim"
ssh -i ${SSH_PRIVATE_KEY} ${LOGIN_USER}@${TARGET_IP} "git clone https://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtree"
ssh -i ${SSH_PRIVATE_KEY} ${LOGIN_USER}@${TARGET_IP} 'rm ~/.vimrc && ln -s ~/git/github-hri123/IR-DevOps/setup/controller/ubuntu/vim_config ~/.vimrc'
#
# Install docker and other prereqs
ssh -i ${SSH_PRIVATE_KEY} ${LOGIN_USER}@${TARGET_IP} "cd ~/git/github-hri123/IR-DevOps/setup/controller/ubuntu/ansible && ansible-playbook -vvvv setup.yml -e apt_cache_valid_time=1800 -e ansible_distribution_release=xenial -e docker_community=True -e docker_package=docker-engine -e ansible_user_id=${LOGIN_USER} -e perform_ufw_operations=True -e the_network_interface=${NETWORK_INTERFACE}"

