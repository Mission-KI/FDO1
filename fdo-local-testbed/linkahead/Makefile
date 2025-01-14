
start: cert doip-linkahead.json
	@echo "Start LinkAhead"
	docker compose up --detach
	docker network connect $${COMPOSE_PROJECT_NAME}-hs-network $${COMPOSE_PROJECT_NAME}-linkahead
	. ./.env ; docker exec $${COMPOSE_PROJECT_NAME}-linkahead /opt/caosdb/git/caosdb-advanced-user-tools/.docker/wait-for-it.sh localhost:10443 -t 500 -- echo "LINKAHEAD ONLINE"
	$(MAKE) doip-linkahead.json
	mkdir ../fdo-manager/repositories || true
	cp doip-linkahead.json ../fdo-manager/repositories/.test.linkahead.json
	$(MAKE) linkahead_handles || true

linkahead_handles: tools/linkahead.batch.hdl tools/get_serviceinfo.sh .env
	. ./.env && echo -n "https://$${LINKAHEAD_DNS_HOST_NAME}:$${LINKAHEAD_HTTPS_PORT}" > tools/linkahead.url
	docker cp tools $${COMPOSE_PROJECT_NAME}-hs-server:/hs/
	docker exec $${COMPOSE_PROJECT_NAME}-hs-server /hs/tools/get_serviceinfo.sh
	docker exec $${COMPOSE_PROJECT_NAME}-hs-server bin/hdl-genericbatch /hs/tools/linkahead.batch.hdl || true
	docker exec $${COMPOSE_PROJECT_NAME}-hs-server bin/hdl-genericbatch /hs/tools/linkahead.batch2.hdl


doip-linkahead.json: doip-linkahead.template.json cert/pubkey.pem .env
	sed "s:PUBKEY:$$(sed "/-----/d" cert/pubkey.pem | tr -d '\n\t\r'):" $< > $@
	. ./.env && sed -i "s:DOIP_PORT:$$LINKAHEAD_DOIP_PORT:" $@
	. ./.env && sed -i "s:DOIP_SERVICE_ID:$$LINKAHEAD_DOIP_SERVICE_ID:" $@
	. ./.env && sed -i "s:DOIP_HOST:$$LINKAHEAD_DOIP_SERVICE_HOST_IP:" $@

stop:
	@echo "Stop LinkAhead"
	docker compose down
	rm ../fdo-manager/repositories/.test.linkahead.json || true
	rm doip-linkahead.json || true

clean: stop
	@echo "Clean LinkAhead"
	docker compose down -v --rmi local
	docker compose rm -vsf

cert/pubkey.pem: cert

cert: .env
	rm -r cert || true
	docker run -e CERT_OWNER=$$UID -v./:/run/ -w /run eclipse-temurin:21 /run/cert.sh
