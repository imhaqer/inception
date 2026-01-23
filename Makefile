# ============================================
# INCEPTION PROJECT MAKEFILE
# ============================================
# This Makefile manages Docker containers for
# NGINX, WordPress, and MariaDB services
# ============================================

# ============================================
# COLOR DEFINITIONS
# ============================================
RESET=$(shell echo -e "\033[0m")
GREEN=$(shell echo -e "\033[1;32m")
BLUE=$(shell echo -e "\033[1;34m")
YELLOW=$(shell echo -e "\033[1;33m")
RED=$(shell echo -e "\033[1;31m")

# ============================================
# DIRECTORY PATHS
# ============================================
DATA_DIR=/home/hahamdan/data
MARIADB_DIR=$(DATA_DIR)/mariadb
WORDPRESS_DIR=$(DATA_DIR)/wordpress

# ============================================
# DOCKER COMPOSE CONFIGURATION
# ============================================
COMPOSE_FILE=srcs/docker-compose.yml

# ============================================
# MAIN TARGETS
# ============================================

# Default target: Create directories, build images, and start containers
all: mariadb_data wordpress_data
	@echo "$(YELLOW)==> Creating MariaDB data directory...$(RESET)"
	@mkdir -p $(MARIADB_DIR)
	@echo "$(YELLOW)==> Creating WordPress data directory...$(RESET)"
	@mkdir -p $(WORDPRESS_DIR)
	@echo "$(YELLOW)==> Building and starting containers...$(RESET)"
	@$(MAKE) images
	@$(MAKE) up
	@echo "$(GREEN)==> Done!$(RESET)"

# Rebuild everything from scratch
re: fclean all

# ============================================
# DOCKER IMAGE MANAGEMENT
# ============================================

# Build all Docker images from Dockerfiles
images:
	@echo "$(BLUE)==> Building Docker images...$(RESET)"
	@docker compose -f $(COMPOSE_FILE) build

# ============================================
# CONTAINER MANAGEMENT
# ============================================

# Start all containers in detached mode
up:
	@echo "$(BLUE)==> Starting containers...$(RESET)"
	@docker compose -f $(COMPOSE_FILE) up -d

# Stop all running containers
down:
	@echo "$(RED)==> Stopping containers...$(RESET)"
	@docker compose -f $(COMPOSE_FILE) down

# ============================================
# CLEANUP TARGETS
# ============================================

# Remove containers, images, and volumes
clean:
	@echo "$(RED)==> Removing containers, images, and volumes...$(RESET)"
	@docker compose -f $(COMPOSE_FILE) down --rmi all -v

# Full cleanup: Remove everything including data directories
fclean: clean
	@echo "$(RED)==> Removing data directories...$(RESET)"
	@sudo rm -rf $(DATA_DIR)
	@docker system prune -f --volumes

# ============================================
# PHONY TARGETS
# ============================================
.PHONY: all clean fclean re up down mariadb_data wordpress_data images