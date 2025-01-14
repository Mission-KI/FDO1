start: repositories repositories/* ../test-handle-system/.handle
	docker compose up -d --build
	. ./.env ; docker cp ../cordra/docker/wait-for-it.sh $${COMPOSE_PROJECT_NAME}-fdo-manager-service:/opt/
	. ./.env ; docker exec $${COMPOSE_PROJECT_NAME}-fdo-manager-service /opt/wait-for-it.sh localhost:$${FDO_MANAGER_SERVICE_INTERNAL_PORT} -t 500 -- echo "FDO MANAGER SERVICE ONLINE"
	. ./.env ; docker network connect $${COMPOSE_PROJECT_NAME}-hs-network $${COMPOSE_PROJECT_NAME}-fdo-manager-service || true

../test-handle-system/.handle:
	$(MAKE) -C ../test-handle-system/ .handle

repositories:
	mkdir $@

repositories/*:

stop:
	docker compose down

clean: stop
	docker compose down -v --rmi local
	docker compose rm -vsf
	rm -r repositories || true
