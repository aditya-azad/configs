#!/usr/bin/env bash
# All-in-one setup for eagle
set -euo pipefail

# ---------------------------------------------------------------- env (common.sh + eagle.env)

CONFIGS_REPO="$HOME/.config"
PACKAGES_DIR="$CONFIGS_REPO/bash/packages"
TASKS_DIR="$CONFIGS_REPO/bash/tasks"

USERNAME="eagle7"
GIT_FULL_NAME="Aditya Azad"
GIT_EMAIL="adityaazad121@gmail.com"
ROS_DOMAIN_ID=7

[[ "$USERNAME" == "$(id -un)" ]] || { echo "run as '$USERNAME' (you are '$(id -un)')" >&2; exit 1; }

HOME_DIR="$HOME"
USER_UID="$(id -u)"
XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$USER_UID}"
DBUS_SESSION_BUS_ADDRESS="${DBUS_SESSION_BUS_ADDRESS:-unix:path=$XDG_RUNTIME_DIR/bus}"
CODE_DIR="$HOME_DIR/code"
SOFTWARE_DIR="$HOME_DIR/.software"
BASHRC_FILE="$HOME_DIR/.bashrc"
MISE_BIN="$HOME_DIR/.local/bin/mise"
CARGO_BIN="$HOME_DIR/.cargo/bin"
ARCH="$(uname -m)"

mkdir -p "$CODE_DIR" "$SOFTWARE_DIR"

# ---------------------------------------------------------------- ssh_key

mkdir -p "$HOME_DIR/.ssh"
chmod 0700 "$HOME_DIR/.ssh"

if [[ ! -f "$HOME_DIR/.ssh/id_ed25519" ]]; then
  ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f "$HOME_DIR/.ssh/id_ed25519" -N ""
  echo
  echo "!! A new SSH key was generated for '$USERNAME' ($HOME_DIR/.ssh/id_ed25519)." >&2
  echo "!! Add this public key to GitHub: Settings -> SSH and GPG keys -> New SSH key:" >&2
  echo
  cat "$HOME_DIR/.ssh/id_ed25519.pub"
  echo
  read -rp "Paste the public key above into GitHub, then press Enter to continue (Ctrl+C to abort): "
fi

# ---------------------------------------------------------------- git

git config --global user.name  "$GIT_FULL_NAME"
git config --global user.email "$GIT_EMAIL"

bash -c 'eval "$(ssh-agent -s)"; ssh-add "$HOME/.ssh/id_ed25519" 2>/dev/null || true' || true

# ---------------------------------------------------------------- rust

[[ -x "$CARGO_BIN/cargo" ]] || curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# ---------------------------------------------------------------- compilers

sudo apt-get install -y \
  git build-essential ninja-build gettext cmake unzip curl \
  xclip g++ pkg-config libfontconfig1-dev libxcb-xfixes0-dev \
  libxkbcommon-dev python3-pip

# ---------------------------------------------------------------- mise_runtimes

[[ -x "$MISE_BIN" ]] || curl https://mise.run | sh

# ---------------------------------------------------------------- net_tools

sudo apt-get install -y net-tools

# ---------------------------------------------------------------- chrony

if [[ "$(timedatectl show -p Timezone --value)" != "America/New_York" ]]; then
  sudo timedatectl set-timezone America/New_York
fi

sudo apt-get install -y chrony
sudo systemctl disable --now systemd-timesyncd.service 2>/dev/null || true
sudo systemctl enable --now chrony

# ---------------------------------------------------------------- zellij
# config is already at ~/.config/zellij (repo lives in ~/.config)

[[ -x "$CARGO_BIN/zellij" ]] || "$CARGO_BIN/cargo" install zellij

mkdir -p "$HOME_DIR/.config"
chmod 0755 "$HOME_DIR/.config"

# ---------------------------------------------------------------- ripgrep

[[ -x "$CARGO_BIN/rg" ]] || "$CARGO_BIN/cargo" install ripgrep

# ---------------------------------------------------------------- python_lsp
# per nvim config: pip install ruff pyrefly

pip3 install --user ruff pyrefly

# ---------------------------------------------------------------- neovim
# release tarball (0.12); config is already at ~/.config/nvim (repo lives in ~/.config)

nvim_version="0.12.0"
nvim_installed_version=""
[[ -f /usr/local/share/nvim-version ]] && nvim_installed_version="$(cat /usr/local/share/nvim-version)"

if [[ "$nvim_installed_version" != "$nvim_version" || ! -x /usr/local/bin/nvim ]]; then
  nvim_asset="nvim-linux-arm64.tar.gz"
  nvim_tmp="$(mktemp -d)"
  curl -fsSL -o "$nvim_tmp/nvim.tar.gz" \
    "https://github.com/neovim/neovim/releases/download/v${nvim_version}/${nvim_asset}"
  sudo rm -rf /opt/nvim
  sudo tar -C /opt -xzf "$nvim_tmp/nvim.tar.gz"
  sudo mv "/opt/${nvim_asset%.tar.gz}" /opt/nvim
  rm -rf "$nvim_tmp"
  sudo ln -sfn /opt/nvim/bin/nvim /usr/local/bin/nvim
  # remove leftovers from a previous source-built install
  sudo rm -rf /usr/local/share/nvim /usr/local/lib/nvim /usr/local/share/nvim-commit
  printf '%s\n' "$nvim_version" | sudo tee /usr/local/share/nvim-version >/dev/null
  sudo chmod 0644 /usr/local/share/nvim-version
fi

# ---------------------------------------------------------------- singularity

sudo apt-get install -y \
  autoconf automake cryptsetup fuse2fs git fuse libfuse-dev \
  libseccomp-dev libtool pkg-config runc squashfs-tools squashfs-tools-ng \
  uidmap wget zlib1g-dev

mkdir -p "$CODE_DIR"
chmod 0755 "$CODE_DIR"

if [[ ! -d "$CODE_DIR/singularity-ce-4.3.0" ]]; then
  bash -c "set -e; cd '$CODE_DIR'; curl -fsSL https://github.com/sylabs/singularity/releases/download/v4.3.0/singularity-ce-4.3.0.tar.gz | tar xzf -"
fi

if [[ ! -f "$CODE_DIR/singularity-ce-4.3.0/builddir/Makefile" ]]; then
  bash -c "set -e; cd '$CODE_DIR/singularity-ce-4.3.0'; ./mconfig --without-libsubid"
fi

if [[ ! -f "$CODE_DIR/singularity-ce-4.3.0/builddir/singularity" ]]; then
  bash -c "set -e; cd '$CODE_DIR/singularity-ce-4.3.0'; make -C builddir"
fi

[[ -x /usr/local/bin/singularity ]] || \
  sudo make -C "$CODE_DIR/singularity-ce-4.3.0/builddir" install

# ---------------------------------------------------------------- realsense

sudo apt-get install -y v4l-utils
mkdir -p "$CODE_DIR"
chmod 0755 "$CODE_DIR"

if [[ -d "$CODE_DIR/librealsense/.git" ]]; then
  git -C "$CODE_DIR/librealsense" fetch --all --tags 2>/dev/null || true
  git -C "$CODE_DIR/librealsense" checkout v2.56.3 2>/dev/null || true
else
  git clone --branch v2.56.3 https://github.com/IntelRealSense/librealsense.git "$CODE_DIR/librealsense"
fi

sudo bash -c "cd '$CODE_DIR/librealsense'; bash ./scripts/setup_udev_rules.sh"

# ---------------------------------------------------------------- nvidia_container_toolkit

sudo apt-get install -y curl

sudo install -d -m 0755 /usr/share/keyrings
tmp=$(mktemp)
curl -fsSL -o "$tmp" https://nvidia.github.io/libnvidia-container/gpgkey
sudo install -m 0644 "$tmp" /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
rm -f "$tmp"

curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list \
  | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' \
  | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list >/dev/null

sudo apt-get update
sudo apt-get install -y \
  nvidia-container-toolkit=1.17.8-1 \
  nvidia-container-toolkit-base=1.17.8-1 \
  libnvidia-container-tools=1.17.8-1 \
  libnvidia-container1=1.17.8-1

# ---------------------------------------------------------------- nvliblist

sudo mkdir -p /usr/local/etc/singularity
sudo chmod 0755 /usr/local/etc/singularity

sudo touch /usr/local/etc/singularity/nvliblist.conf

sudo sed -i '/# BEGIN configs jetson-nvliblist/,/# END configs jetson-nvliblist/d' /usr/local/etc/singularity/nvliblist.conf
sudo tee -a /usr/local/etc/singularity/nvliblist.conf >/dev/null <<'EOF'
# BEGIN configs jetson-nvliblist
libv4l2.so.0
color-lcms.so
desktop-shell.so
drm-backend.so
fullscreen-shell.so
gl-renderer.so
headless-backend.so
hmi-controller.so
ivi-controller.so
ivi-shell.so
libilmClient.so.2.3.2
libilmCommon.so.2.3.2
libilmControl.so.2.3.2
libilmInput.so.2.3.2
libweston-13.so.0
wayland-backend.so
libgstnvarguscamerasrc.so
libgstnvcompositor.so
libgstnvdrmvideosink.so
libgstnveglglessink.so
libgstnveglstreamsrc.so
libgstnvegltransform.so
libgstnvipcpipeline.so
libgstnvivafilter.so
libgstnvjpeg.so
libgstnvtee.so
libgstnvunixfd.so
libgstnvv4l2camerasrc.so
libgstnvvidconv.so
libgstnvvideo4linux2.so
libgstnvvideosink.so
libgstnvvideosinks.so
libgstnvegl-1.0.so.0
libgstnvexifmeta.so
libgstnvivameta.so
libnvsample_cudaprocess.so
libgstnvcustomhelper.so.1.0.0
libgstnvdsseimeta.so.1.0.0
libnveglstreamproducer.so
libgstnvcustomhelper.so
libgstnvdsseimeta.so
libnvdla_compiler.so
ld.so.conf
libjetsonpower.so
libnvargus.so
libnvargus_socketclient.so
libnvargus_socketserver.so
libnvbuf_fdmap.so.1.0.0
libnvbufsurface.so.1.0.0
libnvbufsurftransform.so.1.0.0
libnvcameratools.so
libnvcamerautils.so
libnvcam_imageencoder.so
libnvcamlog.so
libnvcamv4l2.so
libnvcapture.so
libnvcolorutil.so
libnvcucompat.so
libnvcudla.so
libnvcuvidv4l2.so
libnvdc.so
libnvddk_2d_v2.so
libnvddk_vic.so
libnvdecode2eglimage.so
libnvdla_runtime.so
libnvdsbufferpool.so.1.0.0
libnveventlib.so
libnvexif.so
libnvfnet.so
libnvfnetstoredefog.so
libnvfnetstorehdfx.so
libnvfusacapinterface.so
libnvfusacap.so
libnvgov_boot.so
libnvgov_camera.so
libnvgov_force.so
libnvgov_generic.so
libnvgov_gpucompute.so
libnvgov_graphics.so
libnvgov_il.so
libnvgov_spincircle.so
libnvgov_tbc.so
libnvgov_ui.so
libnvidia-allocator.so.1
libnvidia-egl-gbm.so.1.1.0
libnvidia-egl-wayland.so.1.1.11
libnvidia-glcore.so.540.4.0
libnvidia-glsi.so.540.4.0
libnvidia-glvkspirv.so.540.4.0
libnvidia-gpucomp.so.540.4.0
libnvidia-kms.so.540.4.0
libnvidia-ml.so.1
libnvidia-nvvm.so.540.4.0
libnvidia-ptxjitcompiler.so.540.4.0
libnvidia-rmapi-tegra.so.540.4.0
libnvidia-rtcore.so.540.4.0
libnvidia-tls.so.540.4.0
libnvidia-vksc-core.so.540.4.0
libnvid_mapper.so.1.0.0
libnvimp.so
libnvisppg.so
libnvisp.so
libnvisp_utils.so
libnvjpeg.so
libnvmedia_2d.so
libnvmedia2d.so
libnvmedia_dla.so
libnvmedia_eglstream.so
libnvmedia_ide_parser.so
libnvmedia_ide_sci.so
libnvmedia_iep_sci.so
libnvmedia_ijpd_sci.so
libnvmedia_ijpe_sci.so
libnvmedia_iofa_sci.so
libnvmedia_isp_ext.so
libnvmedialdc.so
libnvmedia.so
libnvmedia_tensor.so
libnvmm_contentpipe.so
libnvmmlite_image.so
libnvmmlite.so
libnvmmlite_utils.so
libnvmmlite_video.so
libnvmm_parser.so
libnvmm.so
libnvmm_utils.so
libnvodm_imager.so
libnvofsdk.so
libnvoggopus.so
libnvomxilclient.so
libnvomx.so
libnvosd.so
libnvos.so
libnvparser.so
libnvphsd.so
libnvphs.so
libnvplayfair.so
libnvpva_algorithms.so
libnvpvaintf.so
libnvpva.so
libnvpvaumd.so
libnvrm_chip.so
libnvrm_gpu.so
libnvrm_host1x.so
libnvrm_mem.so
libnvrm_stream.so
libnvrm_surface.so
libnvrm_sync.so
libnvscf.so
libnvscibuf.so.1
libnvscicommon.so.1
libnvscievent.so
libnvsciipc.so
libnvscistream.so.1
libnvscisync.so.1
libnvsocsys.so
libnvtegrahv.so
libnvtracebuf.so
libnvtvmr_2d.so
libnvtvmr.so
libnvv4l2.so
libnvv4l2convert.so
libnvvic.so
libnvvideoencode_ppe.so
libnvvideo.so
libsensors.hal-client.nvs.so
libsensors_hal.nvs.so
libsensors.l4t.no_fusion.nvs.so
libtegrav4l2.so
libtegrawfd.so
libv4l2_nvargus.so
libv4l2_nvcuvidvideocodec.so
libv4l2_nvvideocodec.so
libVkLayer_json_gen.so
libVkSCLayer_khronos_validation.so
libvulkansc.so.1.0.10
libwayland-client.so.0.22.0
libwayland-cursor.so.0.22.0
libwayland-egl.so.1.22.0
libwayland-server.so.0.22.0
ld.so.conf
nvidia-drm_gbm.so
tegra_gbm.so
tegra-udrm_gbm.so
libnvcucompat.so
libnvcudla.so
libv4l2.so.0.0.999999
libv4lconvert.so.0.0.999999
libv4l2_nvargus.so
libv4l2_nvcuvidvideocodec.so
libv4l2_nvvideocodec.so
libnvbufsurface.so
libnvbufsurftransform.so
libnvdsbufferpool.so
libnvidia-allocator.so
libnvidia-egl-gbm.so.1
libnvidia-kms.so
libnvidia-nvvm.so.4
libnvidia-ptxjitcompiler.so.1
libnvidia-vksc-core.so
libnvid_mapper.so
libnvscibuf.so
libnvscicommon.so
libnvscistream.so
libnvscisync.so
libv4l2.so.0
libv4lconvert.so.0
libvulkansc.so
libwayland-client.so
libwayland-cursor.so
libwayland-egl.so
libwayland-server.so
# END configs jetson-nvliblist
EOF

# ---------------------------------------------------------------- local_scripts

sudo apt-get install -y jq zip

for d in "$HOME_DIR/.local/bin" "$HOME_DIR/.local/lib" "$HOME_DIR/.local/share" \
         "$HOME_DIR/.vms" "$HOME_DIR/.vms/windows"; do
  mkdir -p "$d"
  chmod 0755 "$d"
done

install -m 0755 "$PACKAGES_DIR/wpi-vpn/wpi-vpn" "$HOME_DIR/.local/bin/wpi-vpn"
install -m 0644 "$PACKAGES_DIR/venvup/venvup" "$HOME_DIR/.local/lib/venvup"
install -m 0644 "$PACKAGES_DIR/rdid/rdid"     "$HOME_DIR/.local/lib/rdid"

# ---------------------------------------------------------------- bashrc_common

touch "$BASHRC_FILE"

sed -i '/# BEGIN bashrc eagle/,/# END bashrc eagle/d' "$BASHRC_FILE"
cat >> "$BASHRC_FILE" <<'EOF'
# BEGIN bashrc eagle
alias start='xdg-open'
alias brc='nvim ~/.bashrc'
alias dev='./scripts/dev.sh'

case ":$PATH:" in
  *:"$HOME/.local/bin":*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

alias cdc='cd ~/code'
alias cdd='cd ~/Downloads'

[ -f "$HOME/.local/lib/venvup" ] && source "$HOME/.local/lib/venvup"
[ -f "$HOME/.local/lib/rdid" ]   && source "$HOME/.local/lib/rdid"

alias z='zellij'
alias tmux='zellij'
alias scp='rsync -avP'

alias vim='nvim'
alias vi='nvim'
export EDITOR=nvim

set -o vi
bind -m vi-command 'Control-l: clear-screen'
bind -m vi-insert 'Control-l: clear-screen'

export PATH=${PATH}:/usr/src/tensorrt/bin/
alias r2='source /opt/ros/humble/setup.bash'
alias ws='source ./install/setup.bash'
alias cws='rm -rf ./build ./install ./log'
alias bws='colcon build --symlink-install'
alias chrons='chronyc sources'
alias chronr='sudo systemctl restart chronyd'
alias chronc='sudo nvim /etc/chrony/chrony.conf'
alias acp='source ~/code/acp_ws/install/setup.bash'
alias sin='sudo chmod 666 /dev/ttyTHS1 && singularity exec --nv -B /run ~/code/singularity/jetson_6_2.sif /bin/bash'
alias fan='sudo jetson_clocks --fan'
export ROS_DOMAIN_ID=$ROS_DOMAIN_ID
export ROS_LOCALHOST_ONLY=0
export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp

eval "$(~/.local/bin/mise activate bash)"

PS1='\[\e[38;5;196m\]\u@\h\[\e[38;5;28m\]:\w\[\e[0m\]\$ '

# END bashrc eagle
EOF

# ---------------------------------------------------------------- pi

mkdir -p "$HOME_DIR/.pi/agent"
chmod 0755 "$HOME_DIR/.pi/agent"

[[ -x "$HOME_DIR/.local/bin/pi" || -x /usr/bin/pi ]] || curl -fsSL https://pi.dev/install.sh | sh

cfg="$HOME_DIR/.pi/agent/settings.json"

cat > "$cfg" <<'EOF'
{
  "packages": [
    "npm:pi-subagents",
    "npm:@zhushanwen/pi-ask-user",
    "npm:pi-agent-browser-native",
    "npm:pi-mcp-adapter",
    "npm:pi-notify",
    "npm:pi-vim"
  ],
  "defaultProvider": "openrouter",
  "defaultModel": "z-ai/glm-5.3-flash"
}
EOF
