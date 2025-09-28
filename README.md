# Server Monitor - CobaltaX

A professional cross-platform application to monitor and manage Ubuntu servers on your local network.

## Features

- 🖥️ Real-time server status monitoring (online/offline)
- 🔄 Remote server restart functionality via SSH
- 🎨 Professional GUI interface using Tkinter
- 🔧 Cross-platform support (Windows, macOS, Linux)
- ⚡ Automatic status refresh
- 📊 Visual status indicators with colors
- 🌍 **Multilanguage support** (English, Spanish, Catalan)
- 🎛️ **Language switching** in real-time without restart
 - 💬 **Telegram integration** (view recent group/channel messages, filter, auto-refresh, send custom messages)
 - 🔐 **Multi-user authentication** (env-configurable users, per-user passwords)
 - 🛡️ **Admin-only audit viewer** (table with filters & JSON details)
 - 🧾 **Structured audit logging** (JSON lines + in-app table: logins, restarts, audit access)
 - 🌓 Theme switching & layout modes (compact / condensed / card vs list)

## Prerequisites

- Python 3.11+ with Conda
- SSH access to your Ubuntu servers
- Network connectivity to target servers

## Setup

1. **Clone or download this repository**
   ```bash
   cd /path/to/servers_cobaltax
   ```

2. **Create and activate the Conda environment**
   ```bash
   conda env create -f environment.yml
   conda activate servers_cobaltax
   ```

3. **Configure your servers**
   - Edit the `config.py` file to add your server details
   - Add server IPs, SSH credentials, and display names

4. **Run the application**
   ```bash
   python server_monitor.py
   ```

## Configuration

Edit `config.py` to configure your servers:

```python
SERVERS = [
    {
        'name': 'Server 1',
        'ip': '192.168.1.100',
        'ssh_user': 'your_username',
        'ssh_password': 'your_password',  # Optional if using key
        'ssh_key_path': '/path/to/private/key'  # Optional
    },
    {
        'name': 'Server 2', 
        'ip': '192.168.1.101',
        'ssh_user': 'your_username',
        'ssh_password': 'your_password',
        'ssh_key_path': None
    }
]

# Language settings
DEFAULT_LANGUAGE = 'en'  # Options: 'en' (English), 'es' (Spanish), 'ca' (Catalan)
```

## Multilanguage Support

The application supports three languages:
- **English** (`en`) - Default
- **Spanish** (`es`) - Español
- **Catalan** (`ca`) - Català

### Changing Language
1. **Via GUI**: Use the language dropdown in the top bar or Settings menu
2. **Via Config**: Set `DEFAULT_LANGUAGE` in `config.py`
3. **Real-time**: Language changes immediately without restart

### Adding New Languages
Translation files are stored in `translations/` directory:
- `en.json` - English
- `es.json` - Spanish  
- `ca.json` - Catalan

To add a new language, create a new JSON file following the same structure.

## Usage

1. **Launch the application** - The GUI will show your configured servers
2. **Select language** - Use the language dropdown or Settings menu
3. **Monitor status** - Green indicates online, Red indicates offline
4. **Restart servers** - Click the "Restart" button next to any server
5. **Auto-refresh** - Status updates automatically every 30 seconds
6. **Test SSH** - Verify SSH connectivity before restart operations

## Security Notes

- Store SSH credentials securely
- Consider using SSH keys instead of passwords
- Ensure your servers accept SSH connections
- Test SSH connectivity before using restart functionality

### Authentication
The app supports a multi-user login dialog. Users and (optional) per-user passwords are provided via environment variables:

```
export COBALTAX_USERS="Jose,Eva,Abelardo,Mario,Llorenç"
export COBALTAX_PASS=globalFallback
export COBALTAX_PASS_JOSE=secret1
export COBALTAX_PASS_EVA=secret2
export COBALTAX_ADMINS=Jose
```

If `COBALTAX_ADMINS` is not set, the first user in the list is treated as admin.

### Audit Logging
All key actions are appended to `audit.log` as JSON lines. The admin-only "Audit" menu shows a table with:
- Filters: Event / User / Text Contains / Limit / Tail mode
- Columns: Timestamp, User, Event, Server, IP, Success
- Detail panel with formatted JSON

Events currently logged:
- login_success / login_failed / login_cancelled
- restart_executed / restart_cancelled
- audit_view_opened / audit_view_denied / audit_refreshed

Planned (future): telegram_send, telegram_fetch, server_refresh, sync_push, sync_error.

### (Planned) AWS Synchronization
Next phase will introduce an offline-first sync model:
- Local SQLite for audit + users cache
- Periodic sync to AWS (DynamoDB + API Gateway + Lambda)
- Secure Cognito-based authentication
- Fallback to local cache when offline

This README section will be updated once cloud sync code lands.

### Sealing Environment Variables into Encrypted SQLite (No .env in Production)

After defining servers and users (via `config.py` + environment variables for passwords) and running once, the application migrates them into an encrypted SQLite database (`config_store.sqlite`). To make this explicit and then remove the `.env` file from production:

1. Export / source your `.env` normally (contains TELEGRAM_* and COBALTAX_* vars).
2. Run the initialization helper:
   ```bash
   python scripts/init_from_env.py
   ```
3. Verify the summary: number of servers, users, and Telegram settings stored.
4. Secure / remove the `.env` file (keep `.env.example` for reference). The app now reads everything from the encrypted store.

Artifacts to protect (not committed):
```
config_store.sqlite
config_cache.json
.config_master.key
```

If you add new servers or users later, either:
 - Temporarily export new environment variables then rerun the helper, or
 - Use future in-app admin tools (planned) or a direct Python shell with `secure_config_store.upsert_server()` / `upsert_user()`.

Telegram settings are also captured into the settings table; you no longer need TELEGRAM_* env vars at runtime unless you rotate them.

## Troubleshooting

### Server Restart Issues

If server restart is not working, run the debug script:
```bash
conda activate servers_cobaltax
python debug_restart.py
```

**Common restart issues:**

1. **"SSH connection failed"** - Check network connectivity and IP addresses
2. **"User does not have sudo privileges"** - Ensure SSH user is in sudoers group
3. **"User requires password for sudo"** - Configure SSH password in config.py
4. **"All restart commands failed"** - Check server SSH service and firewall

**For passwordless sudo setup (recommended):**
```bash
# On your Ubuntu servers, add this line to /etc/sudoers:
your_username ALL=(ALL) NOPASSWD: /sbin/reboot, /sbin/shutdown
```

### Testing Tools

- **`debug_restart.py`** - Complete diagnostic tool
- **`test_restart_command.py`** - Test restart commands safely
- **GUI Debug button** - Per-server diagnostic information
- **GUI Test Sudo button** - Check sudo privileges

### Common Issues

1. **"Server unreachable"** - Check network connectivity and IP addresses
2. **"SSH connection failed"** - Verify SSH credentials and server SSH service
3. **"Permission denied"** - Ensure SSH user has sudo privileges for restart

### Dependencies Issues

If you encounter dependency issues:
```bash
conda env remove -n servers_cobaltax
conda env create -f environment.yml
conda activate servers_cobaltax
```

## License

This project is for personal/internal use. Modify as needed for your environment.

## Contributing
## Version Freezing & Release Tags

To "freeze" the current local/offline version before adding AWS sync:

```
git init               # if repository not yet initialized
git add .
git commit -m "feat: offline local monitor with auth + telegram + audit table"
git tag -a v1-offline-local -m "Baseline offline-first version before AWS sync layer"
git remote add origin <YOUR_GITHUB_REPO_URL>
git push -u origin main --tags
```

After tagging, AWS sync development can proceed on a new branch (e.g. `aws-sync`):

```
git checkout -b aws-sync
```

Keep production-ready local version referenced by `v1-offline-local` tag.

Feel free to modify and extend this application for your specific needs.

## 📦 Windows EXE Packaging (PyInstaller)

You can distribute the app as a standalone Windows executable. The encrypted configuration database, key, cache, and Telegram session are stored in:

```
%USERPROFILE%\.cobaltax\
   config_store.sqlite
   config_cache.json
   .config_master.key
   cobaltax_user_session.session
```

### 1. Install build dependencies (on Windows)
```
py -m venv venv
venv\Scripts\activate
pip install --upgrade pip
pip install -r requirements.txt
pip install pyinstaller
```

### 2. (Optional first run) Create Telegram user session
Run once in a console so Telethon stores the session:
```
python scripts/telegram_login.py
```
This creates the session under `%USERPROFILE%\.cobaltax`. (If you created it earlier in home as `.cobaltax_user_session.session`, you can move/rename it to the new location.)

### 3. Build executable
```
pyinstaller --noconfirm --clean ^
   --name CobaltaXMonitor ^
   --add-data "translations;translations" ^
   --hidden-import telethon ^
   --hidden-import cryptography ^
   --hidden-import paramiko ^
   main.py

Or simply run the helper script (one-folder + optional one-file):
```
scripts\build_windows.bat
```
Or use the spec file:
```
pyinstaller pyinstaller.spec
```
```
Result: `dist/CobaltaXMonitor/` folder containing `CobaltaXMonitor.exe` plus dependencies.

For a single-file exe (slower startup, larger file):
```
pyinstaller --noconfirm --clean --onefile ^
   --name CobaltaXMonitor ^
   --add-data "translations;translations" ^
   --hidden-import telethon --hidden-import cryptography --hidden-import paramiko ^
   main.py
```

### 4. First Launch
You may provide a `.env` next to the exe for the first run (auto-sealed). After sealing, you can delete it. If no credentials found, the GUI will offer an interactive prompt for Telegram credentials.

### 5. Updating / Resetting
To force a fresh configuration while testing:
```
CobaltaXMonitor.exe --reset-store
```
This removes the SQLite DB and cache (keeps the master key and session).

### 6. Common Packaging Issues
| Issue | Cause | Fix |
|-------|-------|-----|
| Missing translations | Data not bundled | Ensure `--add-data "translations;translations"` |
| Paramiko cryptography warning | Missing backend libs | Ship standard build; warnings are usually benign |
| Telegram history empty | Session not created | Run `scripts/telegram_login.py` locally first |
| Credentials prompt every run | Not sealed | Ensure DB write perms to `%USERPROFILE%` |

### 7. Code Signing (Optional)
For enterprise distribution, sign the exe with `signtool.exe` to reduce SmartScreen warnings.

### 8. Future Enhancements
- Add an admin GUI panel to rotate credentials
- Automatic update check
- SxS portable mode flag (`--portable`) that keeps data beside exe

---