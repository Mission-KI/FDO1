start: .handle
	@echo "Start Handle System"
	docker compose up --build --detach
	. ./.env && docker exec test-handle-net-hs_server-1 /hs/templates/wait-for-it.sh $${HANDLE_SERVER_IPV4_ADDRESS}:8000 -t 500 -- echo "HANDLE SERVICE ONLINE"
	docker exec test-handle-net-hs_server-1 bin/hdl-genericbatch /hs/setup.batch.hdl

.handle:
	mkdir $@

stop:
	@echo "Stop Handle System"
	docker compose down

clean: stop
	@echo "Clean-up Handle System"
	rm -rf .handle
	docker compose down -v --rmi all
	docker compose rm -vsf
