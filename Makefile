.PHONY: init plan apply destroy fmt validate lint

export GITHUB_OWNER := anyfld

init:
	cd terraform && terraform init

plan:
	cd terraform && terraform plan

apply:
	cd terraform && terraform apply

destroy:
	cd terraform && terraform destroy

fmt:
	cd terraform && terraform fmt -recursive

validate:
	cd terraform && terraform validate

lint:
	cd terraform && tflint --recursive
