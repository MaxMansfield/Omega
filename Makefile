name ?= omega
version ?= 0.1.0
arch ?= x86_64
build ?= debug
target ?= $(arch)-unknown-linux-gnu

kname := $(name)-$(arch)
kernel := build/arch/$(arch)/$(kname).bin

# Rust and Cargo
cargo := cargo
cfile := Cargo.toml
readme := README.md

rust_os := target/$(target)/$(build)/lib$(name).a
cargo_flags := build -j $(shell nproc)  --target=$(target)

ifeq ($(build), release)
	cargo_flags += --$(build)
endif

# NASM and assembly
assembly_source_files := $(wildcard src/arch/$(arch)/*.asm)
assembly_object_files := $(patsubst src/arch/$(arch)/%.asm, \
	build/arch/$(arch)/%.o, $(assembly_source_files))

linker_script := src/arch/$(arch)/linker.ld

ld_flags := -n --gc-sections -T $(linker_script) -o $(kernel) $(assembly_object_files) $(rust_os)

#Booting
grub_dir := src/arch/$(arch)/boot/grub
grub_cfg := $(grub_dir)/grub.cfg
define grub_cfg_body

endef

# Output formats
iso := build/arch/$(arch)/$(kname).iso


.PHONY: all clean run iso $(cargo)

all: $(kernel)


clean:
	 @(cargo clean && \
	 test -d build && \
	 rm -r build   && \
	 test -d ${grub_dir} && \
	 rm -r ${grub_dir}) || exit 0

run: $(iso)
	@printf "\nRunning...\n"
	@qemu-system-$(arch) -cdrom $(iso)

iso: $(iso)
	@echo "Making ISO..."

# add the name and version to the readme
readme:
	@sed -i "1s/.*/# ${name}/" $(readme)
	@sed -i "2s/.*/#### v${version}/" $(readme)

$(grub_dir):
		mkdir -p $(grub_dir)

$(grub_cfg): $(grub_dir)
	@printf "set timeout=10\n\
	set default=0\n\
	menuentry '%s v%s%s (%s)' {\n\t\
	multiboot2 /boot/%s.bin\n\tboot\n\
	}" $(name)  ${version} $(shell echo ${build} | head -c 1) ${arch} $(kname) > $(grub_cfg)

$(iso): $(kernel) $(grub_cfg)
	@mkdir -p build/isofiles/boot/grub
	@cp $(kernel) build/isofiles/boot/$(kname).bin
	@cp $(grub_cfg) build/isofiles/boot/grub
	@grub-mkrescue -o $(iso) build/isofiles 2> /dev/null
	@rm -r build/isofiles

$(kernel): readme $(cargo) $(rust_os) $(assembly_object_files) $(linker_script)
	@printf "\n\n"
	ld $(ld_flags)

# Replace the name and version in Cargo.toml and README.md
$(cargo): $(cfile)
	@printf "\n"
	@sed -i "2s/.*/name = \"${name}\"/" $<
	@sed -i "3s/.*/version = \"${version}\"/" $<
	$@  $(cargo_flags)

# compile assembly files
build/arch/$(arch)/%.o: src/arch/$(arch)/%.asm
	@printf "\t"
	@mkdir -p $(shell dirname $@)
	nasm -felf64 $< -o $@
