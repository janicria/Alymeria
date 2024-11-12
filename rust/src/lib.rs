
use godot::prelude::*;
use godot::classes::{Sprite2D, ISprite2D};

mod defeat_panel;

struct AlyRust;

#[gdextension]
unsafe impl ExtensionLibrary for AlyRust {}
