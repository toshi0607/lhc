STACK_NAME := lhc
TEMPLATE_FILE := template.yml
SAM_FILE := sam.yml

build:
	GOARCH=amd64 GOOS=linux go build -o artifact/lhc
.PHONY: build

deploy: build
	sam package \
		--template-file $(TEMPLATE_FILE) \
		--s3-bucket $(STACK_BUCKET) \
		--output-template-file $(SAM_FILE)
	sam deploy \
		--template-file $(SAM_FILE) \
		--stack-name $(STACK_NAME) \
		--capabilities CAPABILITY_IAM
	echo API endpoint URL for Prod environment:
	aws cloudformation describe-stacks \
		--stack-name $(STACK_NAME) \
		--query 'Stacks[0].Outputs[?OutputKey==`ApiUrl`].OutputValue' \
		--output text
.PHONY: deploy

delete:
	aws cloudformation delete-stack --stack-name $(STACK_NAME)
	aws s3 rm "s3://$(STACK_BUCKET)" --recursive
	aws s3 rb "s3://$(STACK_BUCKET)"
.PHONY: delete

test:
	go test ./...
.PHONY: test