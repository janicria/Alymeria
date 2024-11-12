use godot::prelude::*;
use godot::classes::{HBoxContainer, IHBoxContainer, Sprite2D, Label};


#[derive(GodotClass)]
#[class(tool, base=HBoxContainer)]
struct HealthUIRust {
    base: Base<HBoxContainer>
}

#[godot_api]
impl IHBoxContainer for HealthUIRust {
    fn init(base: Base<HBoxContainer>) -> Self {
        Self {
            base,
        }
    }
}

#[godot_api]
impl HealthUIRust {
    #[func]
    fn update_stats(&mut self, stats: Array<i32>) {
        let mut label = self.base().
        get_node_as::<Label>("HealthLabel");
        label.set_text(stats.at(0).to_string().into());
    }
}
