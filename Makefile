META_SIFIVE_COMMIT = rel/meta-sifive/hifive-premier-p550
U_BOOT_COMMIT      = u-boot-2024.01-EIC7X
OPENSBI_COMMIT     = a2b255b88918715173942f2c5e1f97ac9e90c877

CROSS_COMPILE = riscv64-unknown-linux-gnu-
ARCH          = riscv

# On macOS the default riscv toolchain is different
ifeq ($(shell uname), Darwin)
    CROSS_COMPILE = riscv64-elf-
endif

all: fw_payload

meta-sifive:
	git clone https://github.com/sifive/meta-sifive
	cd meta-sifive && git checkout $(META_SIFIVE_COMMIT)

u-boot: meta-sifive
	git clone https://github.com/eswincomputing/u-boot
	cd u-boot && git checkout $(U_BOOT_COMMIT) && git apply ../meta-sifive/recipes-bsp/u-boot/files/riscv64/*

opensbi: meta-sifive
	git clone https://github.com/riscv-software-src/opensbi
	cd opensbi && git checkout $(OPENSBI_COMMIT) && git apply ../meta-sifive/recipes-bsp/opensbi/opensbi-sifive-hf-prem/*

u-boot.bin: u-boot
	make -C u-boot CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH) hifive_premier_p550_defconfig
	make -C u-boot CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH) -j$(nproc)
	cp u-boot/u-boot.bin .

fw_payload: u-boot.bin
	PLATFORM=eswin/eic770x FW_PAYLOAD_PATH=..u-boot.bin FW_FDT_PATH=../u-boot/u-boot.dtb make -C opensbi CROSS_COMPILE=$(CROSS_COMPILE) ARCH=$(ARCH) PLATFORM_RISCV_ISA=rv64imafdc_zicsr_zifencei

clean:
	rm -rf u-boot meta-sifive opensbi

