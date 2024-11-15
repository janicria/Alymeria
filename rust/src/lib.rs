
use godot::prelude::*;

mod health_ui;
mod bestiary;

struct MycoRust;

#[gdextension]
unsafe impl ExtensionLibrary for MycoRust {}
