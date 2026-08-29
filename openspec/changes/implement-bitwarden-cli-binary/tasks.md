## Tasks

- [x] Revert devops module changes (delete config/bitwarden.zsh, internal/bitwarden.zsh, pkg/bitwarden.zsh)
- [x] Revert devops/config/base.zsh (remove bitwarden from DEVOPS_TOOLS)
- [x] Revert devops/config/main.zsh (remove source line)
- [x] Revert devops/internal/main.zsh (remove source line)
- [x] Revert devops/pkg/main.zsh (remove source line)
- [x] Add BITWARDEN_INSTALL_URL, BITWARDEN_BIN_DIR, BITWARDEN_BIN_PATH to bitwarden/config/base.zsh
- [x] Replace yarn-based install in bitwarden/internal/base.zsh with binary download
- [x] Add bitwarden::internal::bitwarden::upgrade function
- [x] Update bitwarden/internal/main.zsh to use binary download instead of core::install bw
- [x] Verify module loads without errors
