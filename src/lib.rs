//! This is the main point of entry for the kernel
#![feature(lang_items)]
#![feature(const_fn)]
#![feature(unique)]
#![no_std]
extern crate rlibc;

///The vgab module controls printing to the VGA buffer_ptr
mod vgab;
use core::fmt::Write;

#[no_mangle]
pub extern fn kmain() {
    // ATTENTION: we have a very small stack and no guard page

    vgab::write_shit();
    loop {}
}

#[lang = "eh_personality"] extern fn eh_personality() {}
#[lang = "panic_fmt"] extern fn panic_fmt() -> ! {loop{}}

// Deny unwinding at all costs
#[allow(non_snake_case)]
#[no_mangle]
pub extern "C" fn _Unwind_Resume() -> ! {
    loop {}
}
