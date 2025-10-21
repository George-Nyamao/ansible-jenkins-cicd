# Ansible Jenkins CI/CD Pipeline Automation

Complete Jenkins CI/CD infrastructure automation using Ansible - from installation to job configuration.

## Features

- ✅ Jenkins master installation and configuration
- ✅ Automated plugin management
- ✅ Pipeline job creation
- ✅ Jenkins Configuration as Code (JCasC)
- ✅ Agent configuration
- ✅ Automated backups
- ✅ Security hardening
- ✅ Integration with Git, Docker, and Ansible

## 🔗 Connect With Me

[![GitHub](https://img.shields.io/badge/GitHub-George--Nyamao-181717?style=for-the-badge&logo=github)](https://github.com/George-Nyamao)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-George_Nyamao-0A66C2?style=for-the-badge&logo=linkedin)](https://www.linkedin.com/in/george-nyamao-842137218/)
[![Email](https://img.shields.io/badge/Email-gmnyamao@hotmail.com-D14836?style=for-the-badge&logo=gmail)](mailto:gmnyamao@hotmail.com)

## Project Structure

```
.
├── ansible.cfg
├── site.yml
├── Makefile
├── inventory/
│   └── hosts
├── group_vars/
│   ├── all.yml
│   ├── jenkins_master.yml
│   └── jenkins_agents.yml
└── roles/
    ├── jenkins/
    │   ├── tasks/
    │   ├── handlers/
    │   ├── templates/
    │   └── defaults/
    ├── jenkins-plugins/
    ├── jenkins-jobs/
    └── jenkins-agents/
```

## Quick Start

### 1. Clone Repository

```bash
git clone https://github.com/George-Nyamao/ansible-jenkins-cicd.git
cd ansible-jenkins-cicd
```

### 2. Configure Inventory

Edit `inventory/hosts`:

```ini
[jenkins_master]
jenkins1 ansible_host=192.168.1.40 ansible_user=ubuntu

[jenkins_agents]
agent1 ansible_host=192.168.1.41 ansible_user=ubuntu
```

### 3. Install Dependencies

```bash
make install
```

### 4. Deploy Jenkins

```bash
make deploy
```

### 5. Access Jenkins

Navigate to: `http://YOUR_SERVER_IP:8080`

Get initial admin password:
```bash
ansible jenkins_master -m shell -a "cat /tmp/jenkins_admin_password.txt" --become
```

## Usage

### Deploy Full Stack

```bash
ansible-playbook site.yml
```

### Deploy Specific Components

```bash
# Jenkins only
ansible-playbook site.yml --tags jenkins

# Plugins only
ansible-playbook site.yml --tags plugins

# Jobs only
ansible-playbook site.yml --tags jobs
```

### Backup Jenkins

```bash
make backup
# or
ansible jenkins_master -m shell -a "/usr/local/bin/jenkins_backup.sh" --become
```

### Check Jenkins Status

```bash
ansible jenkins_master -m shell -a "systemctl status jenkins" --become
```

## Configuration

### Jenkins Settings

Edit `group_vars/all.yml`:

```yaml
jenkins_url: "http://jenkins.example.com:8080"
jenkins_admin_user: "admin"
jenkins_admin_email: "admin@example.com"
jenkins_num_executors: 2
```

### Plugin Configuration

Modify plugin list in `roles/jenkins-plugins/tasks/main.yml`:

```yaml
loop:
  - git
  - workflow-aggregator
  - docker-workflow
  - ansible
  - blueocean
  # Add more plugins here
```

### Job Configuration

Create custom pipeline jobs in `roles/jenkins-jobs/templates/`.

## Jenkins Pipeline Examples

### Basic Pipeline

```groovy
pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh 'echo "Building..."'
            }
        }
        stage('Test') {
            steps {
                sh 'echo "Testing..."'
            }
        }
        stage('Deploy') {
            steps {
                sh 'echo "Deploying..."'
            }
        }
    }
}
```

### Docker Pipeline

```groovy
pipeline {
    agent {
        docker {
            image 'node:18-alpine'
        }
    }
    stages {
        stage('Build') {
            steps {
                sh 'npm install'
                sh 'npm run build'
            }
        }
    }
}
```

### Multi-stage Pipeline

```groovy
pipeline {
    agent any
    
    environment {
        DOCKER_REGISTRY = 'docker.io'
        IMAGE_NAME = 'myapp'
    }
    
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/user/repo.git'
            }
        }
        
        stage('Build') {
            steps {
                sh 'docker build -t ${IMAGE_NAME} .'
            }
        }
        
        stage('Test') {
            steps {
                sh 'docker run ${IMAGE_NAME} npm test'
            }
        }
        
        stage('Push') {
            steps {
                sh 'docker push ${DOCKER_REGISTRY}/${IMAGE_NAME}'
            }
        }
        
        stage('Deploy') {
            steps {
                sh 'kubectl apply -f k8s/'
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
    }
}
```

## Management

### Restart Jenkins

```bash
ansible jenkins_master -m systemd -a "name=jenkins state=restarted" --become
```

### View Jenkins Logs

```bash
ansible jenkins_master -m shell -a "journalctl -u jenkins -n 100" --become
```

### Update Jenkins

```bash
ansible jenkins_master -m apt -a "name=jenkins state=latest update_cache=yes" --become
```

### Install Additional Plugins

```bash
# Add plugin to roles/jenkins-plugins/tasks/main.yml
# Then run:
ansible-playbook site.yml --tags plugins
```

## Troubleshooting

### Jenkins Won't Start

```bash
# Check service status
ansible jenkins_master -m shell -a "systemctl status jenkins" --become

# Check logs
ansible jenkins_master -m shell -a "journalctl -u jenkins -n 50" --become

# Check Java version
ansible jenkins_master -m shell -a "java -version"
```

### Plugin Installation Failed

```bash
# Check plugin manager logs
ansible jenkins_master -m shell -a "cat /var/lib/jenkins/logs/plugin-install.log" --become

# Restart Jenkins
ansible jenkins_master -m systemd -a "name=jenkins state=restarted" --become
```

### Jobs Not Appearing

```bash
# Reload Jenkins configuration
ansible jenkins_master -m uri -a "url=http://localhost:8080/reload method=POST user=admin password=yourpassword force_basic_auth=yes"

# Check job directory
ansible jenkins_master -m shell -a "ls -la /var/lib/jenkins/jobs/" --become
```

### Permission Issues

```bash
# Fix Jenkins home permissions
ansible jenkins_master -m file -a "path=/var/lib/jenkins owner=jenkins group=jenkins recurse=yes" --become

# Restart Jenkins
ansible jenkins_master -m systemd -a "name=jenkins state=restarted" --become
```

## Security Best Practices

1. **Change Default Admin Password**: Immediately after installation
2. **Enable CSRF Protection**: Configured by default
3. **Use Matrix Authorization**: Limit user permissions
4. **Enable Security Realm**: Use LDAP or Active Directory
5. **Regular Updates**: Keep Jenkins and plugins updated
6. **Backup Regularly**: Automated daily backups configured
7. **Use HTTPS**: Configure reverse proxy with SSL
8. **Limit Script Permissions**: Use Script Security plugin
9. **Audit Logs**: Enable and monitor audit logs
10. **Credentials Management**: Use Jenkins Credentials plugin

## Integration

### GitHub Integration

```groovy
pipeline {
    agent any
    
    triggers {
        githubPush()
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
    }
}
```

### Docker Integration

```bash
# Add Jenkins user to docker group
ansible jenkins_master -m user -a "name=jenkins groups=docker append=yes" --become
```

### Ansible Integration

```groovy
pipeline {
    agent any
    
    stages {
        stage('Deploy with Ansible') {
            steps {
                ansiblePlaybook(
                    playbook: 'deploy.yml',
                    inventory: 'inventory/hosts'
                )
            }
        }
    }
}
```

### Slack Integration

Configure in `group_vars/all.yml`:

```yaml
slack_webhook_url: "https://hooks.slack.com/services/YOUR/WEBHOOK/URL"
```

## Backup and Recovery

### Manual Backup

```bash
make backup
```

### Restore from Backup

```bash
# Stop Jenkins
ansible jenkins_master -m systemd -a "name=jenkins state=stopped" --become

# Restore backup
ansible jenkins_master -m shell -a "tar -xzf /var/backups/jenkins/jenkins_backup_DATE.tar.gz -C /var/lib/jenkins/" --become

# Start Jenkins
ansible jenkins_master -m systemd -a "name=jenkins state=started" --become
```

### Automated Backups

Backups run daily at 2 AM. Configure in:
- `roles/jenkins/tasks/main.yml` (cron job)
- `roles/jenkins/templates/jenkins_backup.sh.j2` (backup script)

## CI/CD Pipeline Best Practices

1. **Version Control Everything**: Store Jenkinsfiles in Git
2. **Use Declarative Pipeline**: More maintainable than scripted
3. **Implement Multi-stage Builds**: Separate build, test, deploy
4. **Use Shared Libraries**: Reuse common pipeline code
5. **Implement Quality Gates**: SonarQube, linting, security scans
6. **Parallel Execution**: Speed up builds with parallel stages
7. **Artifact Management**: Use Nexus or Artifactory
8. **Container-based Builds**: Use Docker agents
9. **Infrastructure as Code**: Deploy with Ansible/Terraform
10. **Monitor and Alert**: Track build metrics and failures

## Performance Optimization

### Increase Executors

Edit `group_vars/all.yml`:

```yaml
jenkins_num_executors: 4
```

### Optimize JVM Settings

Edit `/etc/default/jenkins`:

```bash
JAVA_ARGS="-Xmx2048m -XX:MaxPermSize=512m"
```

### Use Build Agents

Distribute builds across multiple agents for parallel execution.

## Requirements

- Ansible 2.9+
- Ubuntu 20.04/22.04 target servers
- Minimum 2GB RAM for Jenkins master
- Minimum 20GB disk space
- Java 11 (installed automatically)
- Python 3.6+

## Support

[![GitHub Issues](https://img.shields.io/github/issues/George-Nyamao/ansible-jenkins-cicd)](https://github.com/George-Nyamao/ansible-jenkins-cicd/issues)
[![GitHub Discussions](https://img.shields.io/badge/GitHub-Discussions-181717?style=flat&logo=github)](https://github.com/George-Nyamao/ansible-jenkins-cicd/discussions)

- **Issues**: [GitHub Issues](https://github.com/George-Nyamao/ansible-jenkins-cicd/issues)
- **Documentation**: See [DEPLOYMENT.md](DEPLOYMENT.md) for detailed guide
- **Jenkins Documentation**: [jenkins.io](https://www.jenkins.io/doc/)

## Changelog

### v1.0.0 (2025-10-21)
- Initial release
- Jenkins master installation
- Plugin management
- Job configuration
- Backup automation
- Security hardening

## Author

**George Nyamao**
- GitHub: [@George-Nyamao](https://github.com/George-Nyamao)
- LinkedIn: [George Nyamao](https://www.linkedin.com/in/george-nyamao-842137218/)
- Email: gmnyamao@hotmail.com

## Acknowledgments

- Jenkins community
- Ansible community
- Contributors

---

⭐ **Star this repository if you find it helpful!**

## Related Projects

- [Ansible LAMP Stack](https://github.com/George-Nyamao/ansible-lamp-stack)
- [Ansible Docker Automation](https://github.com/George-Nyamao/ansible-docker-automation)
- [Ansible Kubernetes](https://github.com/George-Nyamao/ansible-kubernetes)
