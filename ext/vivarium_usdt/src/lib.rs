#![allow(unused)]
use magnus::{function, prelude::*, Error, Ruby};

#[magnus::init]
fn init(ruby: &Ruby) -> Result<(), Error> {
    let module = ruby.define_module("VivariumUsdt")?;
    module.define_singleton_method("invoke_start_probe", function!(invoke_start_probe, 1))?;
    module.define_singleton_method("invoke_stop_probe", function!(invoke_stop_probe, 1))?;
    module.define_singleton_method("invoke_raise_probe", function!(invoke_raise_probe, 1))?;

    let kernel = ruby.module_kernel();
    kernel.define_singleton_method(
        "__helper_get_hash_from_name",
        function!(__helper_get_hash_from_name, 1),
    )?;
    Ok(())
}

pub(crate) fn invoke_start_probe(method_id: i64) -> Result<(), Error> {
    #[cfg(target_os = "linux")]
    {
        use probe::probe;
        probe::probe!(vivarium_usdt, start_probe, method_id);
    }
    Ok(())
}

pub(crate) fn invoke_stop_probe(method_id: i64) -> Result<(), Error> {
    #[cfg(target_os = "linux")]
    {
        use probe::probe;
        probe::probe!(vivarium_usdt, stop_probe, method_id);
    }
    Ok(())
}

pub(crate) fn invoke_raise_probe(error_id: i64) -> Result<(), Error> {
    #[cfg(target_os = "linux")]
    {
        use probe::probe;
        probe::probe!(vivarium_usdt, raise_probe, error_id);
    }
    Ok(())
}

pub(crate) fn __helper_get_hash_from_name(name: String) -> Result<i64, Error> {
    use std::collections::hash_map::DefaultHasher;
    use std::hash::{Hash, Hasher};

    let mut hasher = DefaultHasher::new();
    name.hash(&mut hasher);
    let hash = hasher.finish() as i64;
    Ok(hash)
}

#[cfg(test)]
mod tests {
    use rb_sys_test_helpers::ruby_test;

    #[ruby_test]
    fn test_hello() {
        assert!(true);
    }
}
