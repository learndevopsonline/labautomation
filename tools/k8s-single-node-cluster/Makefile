help:		## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

setup:		## Setup Cluster
	@sh setup.sh
delete:		## Delete Cluster, Same as Destroy
	@sh delete.sh
destroy:	## Destroy Cluster, Same as Delete
	@sh delete.sh
