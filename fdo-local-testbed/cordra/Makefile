start: docker/data/repoInit.json
	@echo "Start Cordra"
	docker compose up --build --detach
	docker network connect $${COMPOSE_PROJECT_NAME}-hs-network $${COMPOSE_PROJECT_NAME}-cordra
	docker exec $${COMPOSE_PROJECT_NAME}-cordra /opt/cordra/wait-for-it.sh localhost:8080 -t 500 -- echo "CORDRA ONLINE"
	docker exec $${COMPOSE_PROJECT_NAME}-cordra /opt/cordra/schema/setup.sh
	$(MAKE) cordra-handles
	$(MAKE) doip-cordra.json
	mkdir ../fdo-manager/repositories || true
	cp doip-cordra.json ../fdo-manager/repositories/.test.cordra.json

docker/data/repoInit.json: docker/data/repoInit.template.json .env
	. ./.env && sed "s:CORDRA_HOST_IP:$$CORDRA_DOIP_SERVICE_HOST_IP:" $< > $@
	. ./.env && sed -i "s:CORDRA_HTTPS_PORT:$$CORDRA_HTTPS_PORT:" $@
	. ./.env && sed -i "s:CORDRA_HTTP_PORT:$$CORDRA_HTTP_PORT:" $@
	. ./.env && sed -i "s|KEY_CLOAK_ISSUER|$$KEY_CLOAK_ISSUER|" $@

stop:
	@echo "Stop Cordra"
	docker compose down
	rm ../fdo-manager/repositories/.test.cordra.json || true
	rm doip-cordra.json || true

clean: stop
	@echo "Clean Cordra"
	docker compose down -v --rmi local
	docker compose rm -vsf
	rm docker/data/repoInit.json || true

doip-cordra.json: doip-cordra.template.json .env docker/data/pubkey.pem
	sed "s:PUBKEY:$$(sed "/-----/d" docker/data/pubkey.pem | tr -d '\n\t\r'):" $< > $@
	. ./.env && sed -i "s:DOIP_PORT:$$CORDRA_DOIP_PORT:" $@
	. ./.env && sed -i "s:DOIP_HOST:$$CORDRA_DOIP_SERVICE_HOST_IP:" $@
	. ./.env && sed -i "s:DOIP_SERVICE_ID:$$CORDRA_DOIP_SERVICE_ID:" $@

cordra-handles: docker/cordra.batch.hdl
	docker exec $${COMPOSE_PROJECT_NAME}-cordra /opt/cordra/bin/hdl-getsiteinfo localhost 2641 /tmp/cordra.siteinfo.bin
	docker cp $${COMPOSE_PROJECT_NAME}-cordra:/tmp/cordra.siteinfo.bin /tmp/cordra.siteinfo.bin
	docker cp /tmp/cordra.siteinfo.bin $${COMPOSE_PROJECT_NAME}-hs-server:/hs/cordra.siteinfo.bin
	docker cp docker/cordra.batch.hdl $${COMPOSE_PROJECT_NAME}-hs-server:/hs/cordra.batch.hdl
	docker cp docker/cordra.batch2.hdl $${COMPOSE_PROJECT_NAME}-hs-server:/hs/cordra.batch2.hdl
	docker exec $${COMPOSE_PROJECT_NAME}-hs-server bin/hdl-genericbatch /hs/cordra.batch.hdl || true
	docker exec $${COMPOSE_PROJECT_NAME}-hs-server bin/hdl-genericbatch /hs/cordra.batch2.hdl
