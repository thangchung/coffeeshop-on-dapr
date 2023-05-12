include .env
export

acr-login:
	docker login ${DOCKER_REGISTRY} -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}
.PHONY: acr-login

push-cr:
	docker push ${DOCKER_REGISTRY}/product-service:latest
	docker push ${DOCKER_REGISTRY}/counter-service:latest
	docker push ${DOCKER_REGISTRY}/barista-service:latest
	docker push ${DOCKER_REGISTRY}/kitchen-service:latest
	docker push ${DOCKER_REGISTRY}/reverse-proxy:latest
.PHONY: push-cr

apply-dapr-component:
	kubectl apply -f iac/dapr/azure/orderup_pubsub.yaml
	kubectl apply -f iac/dapr/azure/barista_pubsub.yaml
	kubectl apply -f iac/dapr/azure/kitchen_pubsub.yaml
.PHONY: apply-dapr-component

get-dapr-component:
	kubectl get component
.PHONY: get-dapr-component