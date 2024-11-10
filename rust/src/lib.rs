
use godot::prelude::*;
use godot::classes::{Sprite2D, ISprite2D};


struct AlyRust;

#[gdextension]
unsafe impl ExtensionLibrary for AlyRust {}


#[derive(GodotClass)]
#[class(base=Sprite2D)]
struct Goblin {
    #[export]
    speed: f64,
    angular_speed: f64,

    base: Base<Sprite2D>
}

#[godot_api]
impl ISprite2D for Goblin {
    fn init(base: Base<Sprite2D>) -> Self {
        Self {
            speed: 400.0,
            angular_speed: std::f64::consts::PI,
            base,
        }
    }

    fn process(&mut self, delta: f64) {
        // Rotation
        let radians = (self.angular_speed * delta) as f32;
        self.base_mut().rotate(radians);

        // Spin
        let rotation = self.base().get_rotation();
        let velocity = Vector2::UP.rotated(rotation) * self.speed as f32;
        self.base_mut().translate(velocity * delta as f32);
    }
}

#[godot_api]
impl Goblin {
    #[func]
    fn explode(&mut self){
        self.base_mut().queue_free();
        panic!()
    }
    #[func]
    fn get_stats(&self) -> Array<f64> {
        array![self.speed, self.angular_speed]
    }
}
