//! The vgab.rs file controls printing to the VGA buffer in color
use core::ptr::Unique;
use spin::Mutex;

macro_rules! kprintln {
    ($fmt:expr) => (kprint!(concat!($fmt, "\n")));
    ($fmt:expr, $($arg:tt)*) => (kprint!(concat!($fmt, "\n"), $($arg)*));
}

macro_rules! kprint {
    ($($arg:tt)*) => ({
        use core::fmt::Write;
        let mut writer = $crate::vgab::WRITER.lock();
        writer.write_fmt(format_args!($($arg)*)).unwrap();
    });
}


const BUFFER_HEIGHT: usize = 25;
const BUFFER_WIDTH: usize = 80;

/// The printable colors
#[allow(dead_code)]
#[repr(u8)]
pub enum Color {
    Black      = 0,
    Blue       = 1,
    Green      = 2,
    Cyan       = 3,
    Red        = 4,
    Magenta    = 5,
    Brown      = 6,
    LightGray  = 7,
    DarkGray   = 8,
    LightBlue  = 9,
    LightGreen = 10,
    LightCyan  = 11,
    LightRed   = 12,
    Pink       = 13,
    Yellow     = 14,
    White      = 15,
}


/// ColorCodes are used to represent the foreground and background colors
#[derive(Clone,Copy)]
struct ColorCode(u8);

impl ColorCode {
    const fn new(fg: Color, bg: Color) -> ColorCode {
        ColorCode((bg as u8)  << 4 | (fg as u8))
    }
}

/// Kchar is a kernel character that can be written by vgab
#[repr(C)]
#[derive(Clone,Copy)]
struct Kchar {
    ///ascii is the ascii character of the Kchar
    ascii: u8,

    ///color_code is the foreground and background color of the character
    color_code: ColorCode,
}

/// Buffer holds all the kernel characters to be written
struct Buffer {
    /// chars is the information (characters) of the buffer
    chars: [[Kchar; BUFFER_WIDTH]; BUFFER_HEIGHT],
}

pub struct Writer {
    /// The column position to write to
    colpos: usize,

    /// The ColorCode to write
    color_code: ColorCode,

    /// The buffer to write from
    buffer: Unique<Buffer>,
}

impl Writer {

    /// Writes a byte to the vga buffer
    pub fn byte(&mut self, byte: u8) {
        match byte {
            b'\n' => self.endl(),
            byte => {
                if self.colpos >= BUFFER_WIDTH {
                    self.endl();
                }

                let row = BUFFER_HEIGHT - 1;
                let col = self.colpos;

                self.buffer().chars[row][col] = Kchar {
                    ascii: byte,
                    color_code: self.color_code,
                };
                self.colpos += 1;
            }
        }
    }

    /// Returns a mutable reference to the buffer
    fn buffer(&mut self) -> &mut Buffer {
        unsafe{ self.buffer.get_mut() }
    }

    /// Inserts a new line into the buffer
    fn endl(&mut self) {
        for row in 0..(BUFFER_HEIGHT - 1) {
            let buffer = self.buffer();
            buffer.chars[row] = buffer.chars[row + 1]
        }
        self.clear_row(BUFFER_HEIGHT - 1);
        self.colpos = 0;

    }

    fn clear_row(&mut self, row: usize) {
        let blank = Kchar {
            ascii: b' ',
            color_code: self.color_code,
        };

        self.buffer().chars[row] = [blank; BUFFER_WIDTH];
    }

    pub fn clear_screen() {
        for _ in 0..BUFFER_HEIGHT {
            kprintln!("");
        }
    }
}

impl ::core::fmt::Write for Writer {
    fn write_str(&mut self, s: &str) -> ::core::fmt::Result {
        for byte in s.bytes() {
            self.byte(byte)
        }
        Ok(())
    }
}

pub static WRITER: Mutex<Writer> = Mutex::new(Writer {
    colpos: 0,
    color_code: ColorCode::new(Color::LightGreen, Color::Black),
    buffer: unsafe { Unique::new(0xb8000 as *mut _) },
});

pub fn clear_screen() {
    Writer::clear_screen();
}
