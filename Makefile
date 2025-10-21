.PHONY: help install check deploy test backup restore clean

help:
	@echo "Jenkins CI/CD Automation"
	@echo "========================"
	@echo "Available commands:"
	@echo "  make install    - Install dependencies"
	@echo "  make check      - Run syntax check"
	@echo "  make deploy     - Deploy Jenkins infrastructure"
	@echo "  make test       - Test Jenkins deployment"
	@echo "  make backup     - Backup Jenkins"
	@echo "  make restore
# Continue the completion script
cat >> complete_jenkins_project.sh << 'SCRIPT'

# Complete the Makefile
cat > Makefile << 'EOF'
.PHONY: help install check deploy test backup restore clean

help:
	@echo "Jenkins CI/CD Automation"
	@echo "========================"
	@echo "Available commands:"
	@echo "  make install    - Install dependencies"
	@echo "  make check      - Run syntax check"
	@echo "  make deploy     - Deploy Jenkins infrastructure"
	@echo "  make test       - Test Jenkins deployment"
	@echo "  make backup     - Backup Jenkins"
	@echo "  make restore    - Restore Jenkins from backup"
	@echo "  make clean      - Clean temporary files"

install:
	@echo "Installing dependencies..."
	pip3 install python-jenkins
	ansible-galaxy collection install community.general

check:
	@echo "Checking syntax..."
	ansible-playbook site.yml --syntax-check
	@echo "Running dry-run..."
	ansible-playbook site.yml --check

deploy:
	@echo "Deploying Jenkins infrastructure..."
	ansible-playbook site.yml

test:
	@echo "Testing Jenkins deployment..."
	ansible jenkins_master -m uri -a "url=http://localhost:8080 status_code=200"

backup:
	@echo "Running Jenkins backup..."
	ansible jenkins_master -m shell -a "/usr/local/bin/jenkins_backup.sh" --become

restore:
	@echo "Restoring Jenkins from backup..."
	@echo "Please specify backup file to restore"

clean:
	@echo "Cleaning up..."
	find . -name "*.retry" -delete
	find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
	find . -name "*.pyc" -delete
