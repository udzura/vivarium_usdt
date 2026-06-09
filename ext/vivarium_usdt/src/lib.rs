#![allow(unused)]
use magnus::{function, prelude::*, Error, Ruby};

#[magnus::init]
fn init(ruby: &Ruby) -> Result<(), Error> {
    let module = ruby.define_module("VivariumUsdt")?;
    module.define_singleton_method("invoke_start_probe", function!(invoke_start_probe, 3))?;
    module.define_singleton_method("invoke_stop_probe", function!(invoke_stop_probe, 3))?;
    module.define_singleton_method("invoke_raise_probe", function!(invoke_raise_probe, 4))?;
    Ok(())
}

fn to_fixed_cstr(s: &str) -> [u8; 128] {
    let mut buf = [0u8; 128];
    let bytes = s.as_bytes();
    let len = bytes.len().min(127);
    buf[..len].copy_from_slice(&bytes[..len]);
    buf
}

pub(crate) fn invoke_start_probe(method_name: String, file: String, lineno: i64) -> Result<(), Error> {
    #[cfg(target_os = "linux")]
    {
        use probe::probe;
        let m = to_fixed_cstr(&method_name);
        let f = to_fixed_cstr(&file);
        probe::probe!(vivarium_usdt, start_probe, m.as_ptr(), f.as_ptr(), lineno);
    }
    Ok(())
}

pub(crate) fn invoke_stop_probe(method_name: String, file: String, lineno: i64) -> Result<(), Error> {
    #[cfg(target_os = "linux")]
    {
        use probe::probe;
        let m = to_fixed_cstr(&method_name);
        let f = to_fixed_cstr(&file);
        probe::probe!(vivarium_usdt, stop_probe, m.as_ptr(), f.as_ptr(), lineno);
    }
    Ok(())
}

pub(crate) fn invoke_raise_probe(
    error_name: String,
    message: String,
    file: String,
    lineno: i64,
) -> Result<(), Error> {
    #[cfg(target_os = "linux")]
    {
        use probe::probe;
        let e = to_fixed_cstr(&error_name);
        let msg = to_fixed_cstr(&message);
        let f = to_fixed_cstr(&file);
        probe::probe!(vivarium_usdt, raise_probe, e.as_ptr(), msg.as_ptr(), f.as_ptr(), lineno);
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use rb_sys_test_helpers::ruby_test;

    #[ruby_test]
    fn test_hello() {
        assert!(true);
    }
}
