# Nettunneller-Client

Welcome to NetTunneller, a powerful tool for creating and maintaining SSH reverse tunnels easily. This client component works seamlessly with the NetTunneller server, providing a secure and efficient way to manage your network connections.


## Features

1. Easy Installation: The installation process is straightforward, requiring only two command-line arguments: *hostname* and *host port*. The script handles the key generation and setup automatically.
2. Secure Credentials Transfer: During installation, it generates SSH keys and securely transfers them to the specified server.
3. Service Creation and Management: The client script creates a systemd service (nettunneller.service) that maintains an SSH reverse tunnel. This service ensures a persistent and reliable connection, automatically restarting in case of failure.

## Getting Started
### Prerequisites
- Ensure you have SSH access to the target server.
- Have the NetTunneller server component installed and configured.

### Installation

```bash
./nettunneller-client <hostname/ip> <hostport>
```
Note: ```sudo``` may be required

**Example**: 
```bash
./nettunneller-client example.com 2222
```

### Customization

Adjust the ```/etc/nettunneller-client/nettunneller-client.service``` file to fit your specific needs. You can modify parameters such as ServerAliveInterval, RestartSec, and more.
