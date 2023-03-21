.PHONY: default
default: local_data build ;

clear_all: clear_containers clear_images

clear_containers:
	@ docker stop `docker ps -a -q` && docker rm `docker ps -a -q`

clear_images:
	@ docker rmi -f `docker images -q`

local_data:
	@ mkdir -p /root/work/your_data_dir/mariadb || true
	@ mkdir -p /root/work/your_data_dir/wordpress || true

build: ## Build image and start all containers in background
	@ docker compose -f ./srcs/docker-compose.yml up -d --build

up: ## Start all containers in background
	@ docker compose -f ./srcs/docker-compose.yml up -d

status: ## Show status of containers
	@ docker compose -f ./srcs/docker-compose.yml ps

restart: ## Restart all containers
	@ docker compose -f ./srcs/docker-compose.yml stop
	@ docker compose -f ./srcs/docker-compose.yml up -d

down: ##Clean all data stop containers
	@ docker compose -f srcs/docker-compose.yml down

fclean:
	@ docker stop $$(docker ps -qa) || true
	@ docker system prune --all --force --volumes || true
	@ docker network prune --force || true
	@ docker volume prune --force || true
	# @ docker volume rm srcs_mariadb_volume || true
	# @ docker volume rm srcs_wordpress_volume || true
	# @ rm -rf ../your_data_dir/mariadb/* || true
	# @ rm -rf ../your_data_dir/wordpress/* || true
