#!/bin/bash

set -e

start_dir=$(pwd)

mkdir -p ~/code
cd ~/code

source ~/.cargo/env

eval "$(~/.local/bin/mise activate bash)"

# net tools
sudo apt install -y net-tools

# chrony
sudo apt install -y chrony

# zellij
cargo install zellij

# du dust
cargo install du-dust

# ripgrep
cargo install ripgrep

# eza
cargo install eza

# python libs
pip3 install python-lsp-server python-lsp-black python-lsp-isort pylsp-mypy mypy flake8 catkin_pkg numpy empy==3.3.4 lark pyyaml

# neovim
git clone https://github.com/neovim/neovim
cd neovim
git checkout stable
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
cd ..
rm -rf neovim

# btop
wget https://github.com/aristocratos/btop/releases/download/v1.4.5/btop-aarch64-linux-musl.tbz
tar -xjf btop-aarch64-linux-musl.tbz
cd btop
sudo make GPU_SUPPORT=true
python3 -m pip install nvidia-ml-py
cd ..
rm -rf btop-aarch64-linux-musl.tbz

# singularity
pushd ~/code
sudo apt-get install -y \
   autoconf \
   automake \
   cryptsetup \
   fuse2fs \
   git \
   fuse \
   libfuse-dev \
   libseccomp-dev \
   libtool \
   pkg-config \
   runc \
   squashfs-tools \
   squashfs-tools-ng \
   uidmap \
   wget \
   zlib1g-dev
export VERSION=4.3.0 && \
    wget https://github.com/sylabs/singularity/releases/download/v${VERSION}/singularity-ce-${VERSION}.tar.gz && \
    tar -xzf singularity-ce-${VERSION}.tar.gz && \
    cd singularity-ce-${VERSION}
./mconfig --without-libsubid && \
    make -C builddir && \
    sudo make -C builddir install
cd ..
rm -rf singularity*
popd

# realsense
sudo apt install v4l-utils
tag="v2.56.3"
pushd ~/code
git clone https://github.com/IntelRealSense/librealsense.git
cd librealsense
git fetch
git checkout $tag
bash ./scripts/setup_udev_rules.sh
cd ..
rm -rf librealsense
popd

# container toolkit
sudo apt-get install curl
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt-get update
export NVIDIA_CONTAINER_TOOLKIT_VERSION=1.17.8-1
  sudo apt-get install -y \
      nvidia-container-toolkit=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
      nvidia-container-toolkit-base=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
      libnvidia-container-tools=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
      libnvidia-container1=${NVIDIA_CONTAINER_TOOLKIT_VERSION}

# nvidia libs to container
cat << EOF | sudo tee -a /usr/local/etc/singularity/nvliblist.conf 

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
libnvv4lconvert.so
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
EOF

cd "$start_dir"
