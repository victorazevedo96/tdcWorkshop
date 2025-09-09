#cloud-config

apt:
  sources:
    docker.list:
      source: deb [arch=amd64] https://download.docker.com/linux/ubuntu $RELEASE stable
      keyid: 9DC858229FC7DD38854AE2D88D81803C0EBFCD88
      
package_upgrade: true
packages:
  - docker-ce
  - docker-ce-cli
  - apt-transport-https
  - ca-certificates
  - curl
  - gnupg
  - lsb-release
runcmd:
  - mkdir -p /etc/apt/keyrings
  - curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/keyrings/microsoft.gpg > /dev/null
  - SUITE=$(lsb_release -cs)
  - echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $SUITE main" | sudo tee /etc/apt/sources.list.d/microsoft.list
  - |
    cat << EOF | sudo tee /etc/apt/preferences.d/99-microsoft.pref
    Package: *
    Pin: origin https://packages.microsoft.com/repos/azure-cli
    Pin-Priority: 1

    Package: azure-cli
    Pin: origin https://packages.microsoft.com/repos/azure-cli
    Pin-Priority: 500
    EOF
  - sudo apt-get update && sudo apt-get install -y azure-cli
