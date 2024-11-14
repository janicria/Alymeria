
use godot::prelude::*;

mod health_ui;

struct MycoRust;

#[gdextension]
unsafe impl ExtensionLibrary for MycoRust {}
