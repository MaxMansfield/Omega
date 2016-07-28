//! This is the main point of entry for the kernel
#![feature(lang_items)]
#![feature(const_fn)]
#![feature(unique)]
#![no_std]
extern crate rlibc;
extern crate spin;


///The vgab module controls printing to the VGA buffer_ptr
#[macro_use]
mod vgab;

#[no_mangle]
pub extern fn kmain() {
    vgab::clear_screen();
    kprintln!("VGA: Buffer Ready.");

    let mut i: i64 = 0;
    loop {
        kprintln!("Kernel Running! - {}", i);
        i = i + 1;
    }
}

#[lang = "eh_personality"] extern fn eh_personality() {}
#[lang = "panic_fmt"] extern fn panic_fmt() -> ! {loop{}}

// Deny unwinding at all costs
#[allow(non_snake_case)]
#[no_mangle]
pub extern "C" fn _Unwind_Resume() -> ! {
    loop {}
}
