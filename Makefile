arch ?= x86_64
mode ?= debug

kname := Omega-$(arch)
kernel := build/arch/$(arch)/$(kname).bin
iso := build/arch/$(arch)/$(kname).iso

linker_script := src/arch/$(arch)/linker.ld
grub_dir := src/arch/$(arch)/boot/grub
grub_cfg := $(grub_dir)/grub.cfg
assembly_source_files := $(wildcard src/arch/$(arch)/*.asm)
assembly_object_files := $(patsubst src/arch/$(arch)/%.asm, \
	build/arch/$(arch)/%.o, $(assembly_source_files))

.PHONY: all clean run iso

all: $(kernel)


clean:
	@rm -r build && cargo clean

run: $(iso)
	@qemu-system-$(arch) -cdrom $(iso)

iso: $(iso)

$(iso): $(kernel) $(grub_cfg)
	@mkdir -p build/isofiles/boot/grub
	@cp $(kernel) build/isofiles/boot/$(kname).bin
	@cp $(grub_cfg) build/isofiles/boot/grub
	@grub-mkrescue -o $(iso) build/isofiles 2> /dev/null
	@rm -r build/isofiles

$(kernel): $(assembly_object_files) $(linker_script)
	@ld -n -T $(linker_script) -o $(kernel) $(assembly_object_files)

# compile assembly files
build/arch/$(arch)/%.o: src/arch/$(arch)/%.asm
	@mkdir -p $(shell dirname $@)
	@nasm -felf64 $< -o $@
