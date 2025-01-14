#!make

include .env
export $(shell sed 's/=.*//' .env)

all: help

help:
	@echo "# Important Commands:"
	@echo "  make start - start the testbed."
	@echo "  make stop  - stop the testbed."
	@echo "  make clean - remove containers, networks, volumes, and locally built images."
	@echo -e "\n# Other Useful Commands:"
	@echo "  make start_mock_manager - start the FDO Manager Service only with mock"
	@echo "                            repositories and w/o the handle system."
	@echo "  make info  - print information about current configured ports, etc."

info:
	@. test-handle-system/.env && echo "Handle server: http://$$HANDLE_SERVER_IPV4_ADDRESS:8000                 Login: see ./test-handle-system/README.md"
	@. nginx-keycloak/.env &&     echo "     KeyCloak: http://localhost:$$MAIN_PORT/auth/admin       Login: username 'admin', password 'admin'"
	@. cordra/.env &&             echo "       Cordra: https://localhost:$$CORDRA_HTTPS_PORT                 Login: username 'admin', password 'cordra'"
	@. linkahead/.env && echo "    LinkAhead: http://localhost:$$LINKAHEAD_HTTP_PORT                 Login: username 'admin', password 'caosdb'"
	@. fdo-manager/.env && echo "  FDO Manager: http://localhost:$$MAIN_PORT                  Login: username 'user', password 'password'"

start: start_handle_system start_cordra start_linkahead start_fdo_manager start_nginx_keycloak start_aas_adapter
	$(MAKE) info

start_mock_manager:
	FDO_MANAGER_MOCK=true $(MAKE) -C fdo-manager start

stop: stop_aas_adapter stop_nginx_keycloak stop_fdo_manager stop_cordra stop_linkahead stop_handle_system

clean: clean_aas_adapter clean_nginx_keycloak clean_fdo_manager clean_cordra clean_linkahead clean_handle_system

.PHONY: clean_nginx_keycloak
clean_nginx_keycloak:
	$(MAKE) -C nginx-keycloak clean || true

.PHONY: clean_aas_adapter
clean_aas_adapter:
	$(MAKE) -C fdo-aas-adapter clean || true

.PHONY: clean_handle_system
clean_handle_system:
	$(MAKE) -C test-handle-system clean || true

.PHONY: clean_linkahead
clean_linkahead:
	$(MAKE) -C linkahead clean || true

.PHONY: clean_cordra
clean_cordra:
	$(MAKE) -C cordra clean || true

.PHONY: clean_fdo_manager
clean_fdo_manager:
	$(MAKE) -C fdo-manager clean || true

.PHONY: start_cordra
start_cordra:
	$(MAKE) -C cordra start

.PHONY: stop_cordra
stop_cordra:
	$(MAKE) -C cordra stop || true

.PHONY: start_handle_system
start_handle_system:
	$(MAKE) -C test-handle-system start

.PHONY: stop_handle_system
stop_handle_system:
	$(MAKE) -C test-handle-system stop || true
	docker volume rm test-handle-net_hs_srv1 || true

.PHONY: start_linkahead
start_linkahead:
	$(MAKE) -C linkahead start

.PHONY: stop_linkahead
stop_linkahead:
	$(MAKE) -C linkahead stop || true

.PHONY: start_fdo_manager
start_fdo_manager:
	$(MAKE) -C fdo-manager start

.PHONY: stop_fdo_manager
stop_fdo_manager:
	$(MAKE) -C fdo-manager stop || true

.PHONY: start_aas_adapter
start_aas_adapter:
	$(MAKE) -C fdo-aas-adapter start

.PHONY: stop_aas_adapter
stop_aas_adapter:
	$(MAKE) -C fdo-aas-adapter stop || true

.PHONY: start_nginx_keycloak
start_nginx_keycloak:
	$(MAKE) -C nginx-keycloak start

.PHONY: stop_nginx_keycloak
stop_nginx_keycloak:
	$(MAKE) -C nginx-keycloak stop || true
