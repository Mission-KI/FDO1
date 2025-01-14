start:
	docker compose up --build -d keycloak-postgres
	sleep 3s
	. ./.env ; docker exec $${COMPOSE_PROJECT_NAME}-keycloak-postgres /usr/local/bin/psql -U username -f /tmp/postgresdump/dump.sql keycloak > /tmp/load_keycloak_dump.log || echo "loading keycloak sql dump failed, see /tmp/load_keycloak_dump.log"
	docker compose up --build -d keycloak nginx

stop:
	docker compose down

clean: stop
	docker compose down -v --rmi local
	docker compose rm -vsf

