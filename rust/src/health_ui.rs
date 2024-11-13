use godot::prelude::*;
use godot::classes::{HBoxContainer, IHBoxContainer, Label};


#[derive(GodotClass)]
#[class(base=HBoxContainer)]
struct HealthUIRust {
    #[export]
    show_max_health: bool,
    base: Base<HBoxContainer>
}

#[godot_api]
impl IHBoxContainer for HealthUIRust {
    fn init(base: Base<HBoxContainer>) -> Self {
        Self {
            show_max_health: false,
            base,
        }
    }
}

#[godot_api]
impl HealthUIRust {
    #[func]
    fn update_stats(&mut self, health: i32, max_health: i32) {
        let mut text = health.to_string();
        if self.show_max_health {
            text.push('/');
            text.push_str(&max_health.to_string());
        }
        self
        .base()
        .get_node_as::<Label>("%HealthLabel")
        .set_text(text.into());
    }
}
