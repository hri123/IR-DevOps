# From: https://gist.github.com/prwhite/8168133

# Add the following 'help' target to your Makefile
# And add help text after each target name starting with '\#\#'
# A category can be added with @category

# CORE #

HELP_FUN = \
        %help; \
        while(<>) { push @{$$help{$$2 // 'options'}}, [$$1, $$3] if /^(\w+)\s*:.*\#\#(?:@(\w+))?\s(.*)$$/ }; \
        print "usage: make [target]\n\n"; \
    for (sort keys %help) { \
        print "$$_:\n"; $$sep = " " x (20 - length $$_->[0]); \
        my @sorted_values = sort { $$a->[0] cmp $$b->[0] } @{$$help{$$_}}; \
        print "  $$_->[0]$$sep$$_->[1]\n" for @sorted_values; \
        print "\n"; }

help:           ##@miscellaneous Show this help.
	@perl -e '$(HELP_FUN)' $(MAKEFILE_LIST)

# kubectl #
kubectl_install: ##@kube - https://kubernetes.io/docs/tasks/tools/install-kubectl/
	@curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.8.1/bin/linux/amd64/kubectl
	@chmod +x ./kubectl
	@mv ./kubectl /usr/local/bin/kubectl

# softlayer slcli #
slcli_install:
	@pip install softlayer

slcli_setup:
	@slcli setup

# minikube #
minikube_install: ##@kube - https://github.com/kubernetes/minikube
	@curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube
	@mv ./minikube /usr/local/bin/minikube

minikube_start: ##@kube
	./start_minikube.sh

minikube_stop: ##@kube
	@minikube stop

minikube_delete: ##@kube
	@minikube delete

minikube_dashboard: ##@kube - replace the ip with vm public ip and open it from mac
	@minikube dashboard --url

# vim plugins #
nerdtree_install: 
	@echo "TODO: install NERDTree Plugin for vim"

# helm #
helm_install:
	@curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash
