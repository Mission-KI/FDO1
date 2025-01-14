start:
	@echo "Start FDO AAS Adapter"
	docker compose up --detach

stop:
	@echo "Stop FDO AAS Adapter"
	docker compose down

clean: stop
	@echo "Clean FDO AAS Adapter"
	docker compose down -v --rmi local
	docker compose rm -vsf
