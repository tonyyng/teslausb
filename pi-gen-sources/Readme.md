### Building a teslausb image


To build a ready to flash one-step setup image for CIFS, do the following:

1. Clone pi-gen from https://github.com/RPi-Distro/pi-gen
1. Follow the instructions in the pi-gen readme to install the required dependencies
1. In the pi-gen folder, run:
    ```
    echo 'IMG_NAME=teslausb' > config
    echo 'HOSTNAME=teslausb' >> config
    echo 'STAGE_LIST="stage0 stage1 stage2 stage_teslausb"' >> config
    rm -rf stage2/EXPORT_NOOBS
    mkdir stage_teslausb
    touch stage_teslausb/EXPORT_IMAGE
    cp stage2/prerun.sh stage_teslausb/prerun.sh
    ```
1. Copy teslausb/pi-gen-sources/00-teslausb-tweaks to the pi-gen/stage_teslausb folder
1. Adjust `ROOT_MARGIN` in export-image/prerun.sh to have more free space on the root partition. As of this writing, pi-gen uses a `ROOT_MARGIN` of 20% of the used size, plus 200MB, which isn't enough for the storage temporarily required during teslausb initial setup. The prebuilt image uses a value of 20%+400MB, which allows installation to complete and leaves about 450 MB free after installation is complete.
1. Run `build.sh` or `build-docker.sh`, depending on how you configured pi-gen to build the image
1. Sit back and relax, this could take a while (for reference, on a dual-core 2.6 Ghz Intel Core i3 and 50 Mbps internet connection, it took under an hour)
If all went well, the image will be in the `deploy` folder. Use Etcher or similar tool to flash it.
